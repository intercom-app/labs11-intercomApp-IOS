//
//  GroupChatRoomViewController.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 3/26/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//




import UIKit
import AVFoundation
import PushKit
import TwilioVoice


let baseURLString = "https://intercom-be-farste.herokuapp.com/api/voice/"
let accessTokenEndpoint = "accessToken"

let twimlParamTo = "to"

class ChatroomViewController: UIViewController, PKPushRegistryDelegate, TVONotificationDelegate, TVOCallDelegate, AVAudioPlayerDelegate, UITextFieldDelegate {
    
    
   
    @IBOutlet weak var userNameLabel1: UILabel!
    @IBOutlet weak var userNameLabel2: UILabel!
    @IBOutlet weak var userNameLabel3: UILabel!
    @IBOutlet weak var userNameLabel4: UILabel!
    @IBOutlet weak var userNameLabel5: UILabel!
    @IBOutlet weak var userNameLabel6: UILabel!
    @IBOutlet weak var userNameLabel7: UILabel!
    @IBOutlet weak var userNameLabel8: UILabel!
    @IBOutlet weak var userNameLabel9: UILabel!
    @IBOutlet weak var userNameLabel10: UILabel!
    @IBOutlet weak var userNameLabel11: UILabel!
    var labelArray: [UILabel]?
    
    func setupLabel() {
        labelArray = [userNameLabel1, userNameLabel2, userNameLabel3, userNameLabel4, userNameLabel5, userNameLabel6, userNameLabel7, userNameLabel8, userNameLabel9, userNameLabel10, userNameLabel11]
        for tag in 0...10 {
            if labelArray?[tag].tag == tag + 1 {
                labelArray?[tag].isHidden = true
            }
        }
    }
    
    
    
    @IBOutlet weak var editOutlet: UIBarButtonItem!
    @IBOutlet weak var placeCallButton: UIButton!
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var outgoingValue: UITextField!
    @IBOutlet weak var callControlView: UIView!
    @IBOutlet weak var muteSwitch: UISwitch!
    @IBOutlet weak var speakerSwitch: UISwitch!
    
    var userIdentity: String?
    var identity: String?
    var deviceTokenString:String?
    var voipRegistry:PKPushRegistry
    var incomingPushCompletionCallback: (()->Swift.Void?)? = nil
    var incomingAlertController: UIAlertController?
    var callInvite:TVOCallInvite?
    var call:TVOCall?
    var ringtonePlayer:AVAudioPlayer?
    var ringtonePlaybackCallback: (() -> ())?
    var names: [String] = []
    var group: Groups? {
        didSet {
            if let group = group {
            identity = "\(group.groupID)" + group.groupName
                if let nikName = TeamImporter.shared.userNikname {
                    userIdentity = nikName
                }
            }
        }
    }
    var usersArray: [String] = []
    
    
    func updateView() {
        outgoingValue.text = identity
        title = outgoingValue.text
        setupLabel()
        
                guard let users = self.group?.members else { return }
                self.names = []
                // guard let jsonCount = json.first?.count else { return }
                for nameArray in 0..<users.count {
                     let displayName = users[nameArray].displayName
                        print(displayName)
                        self.labelArray?[nameArray].isHidden = false
                        self.labelArray?[nameArray].text = displayName
                        self.names.append(displayName)
                    }
        
        if TeamImporter.shared.userID == group?.owners.first?.id {
            self.editOutlet.isEnabled = true
            
        }
        }
    
    
    required init?(coder aDecoder: NSCoder) {
        voipRegistry = PKPushRegistry.init(queue: DispatchQueue.main)
        super.init(coder: aDecoder)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = Set([PKPushType.voIP])
        TwilioVoice.logLevel = .verbose
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        toggleUIState(isEnabled: true, showCallControl: false)
        outgoingValue.delegate = self
        self.editOutlet.isEnabled = false
         updateView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editGroup" {
            let destination = segue.destination as! GroupEditViewController
            destination.group = self.group
        } else if segue.identifier == "activity" {
            let destination = segue.destination as! ChatroomActivityTableViewController
            destination.group = self.group
        }
    }
    
    func fetchAccessToken() -> String? {
        let endpointWithIdentity = String(format: "%@?identity=%@", accessTokenEndpoint, userIdentity ?? "")
        print(userIdentity ?? "not set")
        guard let accessTokenURL = URL(string: baseURLString + endpointWithIdentity) else {
            return nil
        }
        
        return try? String.init(contentsOf: accessTokenURL, encoding: .utf8)
    }
    
    func toggleUIState(isEnabled: Bool, showCallControl: Bool) {
        placeCallButton.isEnabled = isEnabled
        if (showCallControl) {
            callControlView.isHidden = false
            muteSwitch.isOn = false
            speakerSwitch.isOn = true
        } else {
            callControlView.isHidden = true
        }
    }
    
    @IBAction func placeCall(_ sender: UIButton) {
        if (self.call != nil) {
            self.call?.disconnect()
            self.toggleUIState(isEnabled: false, showCallControl: false)
        } else {
            guard let accessToken = fetchAccessToken() else {
                return
            }
            
            playOutgoingRingtone(completion: { [weak self] in
                if let strongSelf = self {
                    strongSelf.call = TwilioVoice.call(accessToken, params: [twimlParamTo : strongSelf.outgoingValue.text!], delegate: strongSelf)
                    strongSelf.toggleUIState(isEnabled: false, showCallControl: false)
                    
                }
            })
        }
    }
    
    @IBAction func muteSwitchToggled(_ sender: UISwitch) {
        if let call = call {
            call.isMuted = sender.isOn
        } else {
            NSLog("No active call to be muted")
        }
    }
    
    @IBAction func speakerSwitchToggled(_ sender: UISwitch) {
        toggleAudioRoute(toSpeaker: sender.isOn)
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        outgoingValue.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: PKPushRegistryDelegate
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        NSLog("pushRegistry:didUpdatePushCredentials:forType:");
        
        if (type != .voIP) {
            return
        }
        
        guard let accessToken = fetchAccessToken() else {
            return
        }
        
        let deviceToken = (credentials.token as NSData).description
        
        TwilioVoice.register(withAccessToken: accessToken, deviceToken: deviceToken) { (error) in
            if let error = error {
                NSLog("An error occurred while registering: \(error.localizedDescription)")
            }
            else {
                NSLog("Successfully registered for VoIP push notifications.")
            }
        }
        
        self.deviceTokenString = deviceToken
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        NSLog("pushRegistry:didInvalidatePushTokenForType:")
        
        if (type != .voIP) {
            return
        }
        
        guard let deviceToken = deviceTokenString, let accessToken = fetchAccessToken() else {
            return
        }
        
        TwilioVoice.unregister(withAccessToken: accessToken, deviceToken: deviceToken) { (error) in
            if let error = error {
                NSLog("An error occurred while unregistering: \(error.localizedDescription)")
            }
            else {
                NSLog("Successfully unregistered from VoIP push notifications.")
            }
        }
        
        self.deviceTokenString = nil
    }
    
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        NSLog("pushRegistry:didReceiveIncomingPushWithPayload:forType:completion:")
        
        // Save for later when the notification is properly handled.
        self.incomingPushCompletionCallback = completion;
        
        if (type == PKPushType.voIP) {
            TwilioVoice.handleNotification(payload.dictionaryPayload, delegate: self)
        }
    }
    
    func incomingPushHandled() {
        if let completion = self.incomingPushCompletionCallback {
            completion()
            self.incomingPushCompletionCallback = nil
        }
    }
    
    // MARK: TVONotificaitonDelegate
    func callInviteReceived(_ callInvite: TVOCallInvite) {
        if (callInvite.state == .pending) {
            handleCallInviteReceived(callInvite)
        } else if (callInvite.state == .canceled) {
            handleCallInviteCanceled(callInvite)
        }
    }
    
    func handleCallInviteReceived(_ callInvite: TVOCallInvite) {
        NSLog("callInviteReceived:")
        
        if (self.callInvite != nil && self.callInvite?.state == .pending) {
            NSLog("Already a pending call invite. Ignoring incoming call invite from \(callInvite.from)")
            self.incomingPushHandled()
            return
        } else if (self.call != nil && self.call?.state == .connected) {
            NSLog("Already an active call. Ignoring incoming call invite from \(callInvite.from)");
            self.incomingPushHandled()
            return;
        }
        
        self.callInvite = callInvite;
        
        let from = callInvite.from
        let alertMessage = "From: \(from)"
        
        playIncomingRingtone()
        
        let incomingAlertController = UIAlertController(title: "Incoming",
                                                        message: alertMessage,
                                                        preferredStyle: .alert)
        
        let rejectAction = UIAlertAction(title: "Reject", style: .default) { [weak self] (action) in
            if let strongSelf = self {
                strongSelf.stopIncomingRingtone()
                callInvite.reject()
                strongSelf.callInvite = nil
                
                strongSelf.incomingAlertController = nil
                strongSelf.toggleUIState(isEnabled: true, showCallControl: false)
            }
        }
        incomingAlertController.addAction(rejectAction)
        
        let ignoreAction = UIAlertAction(title: "Ignore", style: .default) { [weak self] (action) in
            if let strongSelf = self {
                /* To ignore the call invite, you don't have to do anything but just literally ignore it */
                
                strongSelf.callInvite = nil
                strongSelf.stopIncomingRingtone()
                strongSelf.incomingAlertController = nil
                strongSelf.toggleUIState(isEnabled: true, showCallControl: false)
            }
        }
        incomingAlertController.addAction(ignoreAction)
        
        let acceptAction = UIAlertAction(title: "Accept", style: .default) { [weak self] (action) in
            if let strongSelf = self {
                strongSelf.stopIncomingRingtone()
                strongSelf.call = callInvite.accept(with: strongSelf)
                strongSelf.callInvite = nil
                
                strongSelf.incomingAlertController = nil
                
            }
        }
        incomingAlertController.addAction(acceptAction)
        
        toggleUIState(isEnabled: false, showCallControl: false)
        present(incomingAlertController, animated: true, completion: nil)
        self.incomingAlertController = incomingAlertController
        
        // If the application is not in the foreground, post a local notification
        if (UIApplication.shared.applicationState != UIApplication.State.active) {
            let notification = UILocalNotification()
            notification.alertBody = "Incoming Call From \(from)"
            
            UIApplication.shared.presentLocalNotificationNow(notification)
        }
        
        self.incomingPushHandled()
    }
    
    func handleCallInviteCanceled(_ callInvite: TVOCallInvite) {
        NSLog("callInviteCanceled:")
        
        if (callInvite.callSid != self.callInvite?.callSid) {
            NSLog("Incoming (but not current) call invite from \(callInvite.from) canceled. Just ignore it.");
            return;
        }
        
        self.stopIncomingRingtone()
        playDisconnectSound()
        
        if (incomingAlertController != nil) {
            dismiss(animated: true) { [weak self] in
                if let strongSelf = self {
                    strongSelf.incomingAlertController = nil
                    strongSelf.toggleUIState(isEnabled: true, showCallControl: false)
                }
            }
        }
        
        self.callInvite = nil
        
        UIApplication.shared.cancelAllLocalNotifications()
        
        self.incomingPushHandled()
    }
    
    func notificationError(_ error: Error) {
        NSLog("notificationError: \(error.localizedDescription)")
    }
    
    
    // MARK: TVOCallDelegate
    func callDidConnect(_ call: TVOCall) {
        NSLog("callDidConnect:")
        
        self.call = call
        
        self.placeCallButton.setTitle("Hang Up", for: .normal)
        
        toggleUIState(isEnabled: true, showCallControl: true)
        toggleAudioRoute(toSpeaker: true)
    }
    
    func call(_ call: TVOCall, didFailToConnectWithError error: Error) {
        NSLog("Call failed to connect: \(error.localizedDescription)")
        
        callDisconnected()
    }
    
    func call(_ call: TVOCall, didDisconnectWithError error: Error?) {
        if let error = error {
            NSLog("Call failed: \(error.localizedDescription)")
        } else {
            NSLog("Call disconnected")
        }
        
        callDisconnected()
    }
    
    func callDisconnected() {
        self.call = nil
        
        playDisconnectSound()
        toggleUIState(isEnabled: true, showCallControl: false)
        self.placeCallButton.setTitle("Call", for: .normal)
    }
    
    
    // MARK: AVAudioSession
    func toggleAudioRoute(toSpeaker: Bool) {
        // The mode set by the Voice SDK is "VoiceChat" so the default audio route is the built-in receiver. Use port override to switch the route.
        do {
            if (toSpeaker) {
                try AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
            } else {
                try AVAudioSession.sharedInstance().overrideOutputAudioPort(.none)
            }
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    
    // MARK: Ringtone player & AVAudioPlayerDelegate
    func playOutgoingRingtone(completion: @escaping () -> ()) {
        self.ringtonePlaybackCallback = completion
        
        let ringtonePath = URL(fileURLWithPath: Bundle.main.path(forResource: "outgoing", ofType: "wav")!)
        do {
            self.ringtonePlayer = try AVAudioPlayer(contentsOf: ringtonePath)
            self.ringtonePlayer?.delegate = self
            
            playRingtone()
        } catch {
            NSLog("Failed to initialize audio player")
            self.ringtonePlaybackCallback?()
        }
    }
    
    func playIncomingRingtone() {
        let ringtonePath = URL(fileURLWithPath: Bundle.main.path(forResource: "incoming", ofType: "wav")!)
        do {
            self.ringtonePlayer = try AVAudioPlayer(contentsOf: ringtonePath)
            self.ringtonePlayer?.delegate = self
            self.ringtonePlayer?.numberOfLoops = -1
            
            playRingtone()
        } catch {
            NSLog("Failed to initialize audio player")
        }
    }
    
    func stopIncomingRingtone() {
        if (self.ringtonePlayer?.isPlaying == false) {
            return
        }
        
        self.ringtonePlayer?.stop()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord)
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func playDisconnectSound() {
        let ringtonePath = URL(fileURLWithPath: Bundle.main.path(forResource: "disconnect", ofType: "wav")!)
        do {
            self.ringtonePlayer = try AVAudioPlayer(contentsOf: ringtonePath)
            self.ringtonePlayer?.delegate = self
            self.ringtonePlaybackCallback = nil
            
            playRingtone()
        } catch {
            NSLog("Failed to initialize audio player")
        }
    }
    
    func playRingtone() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        } catch {
            NSLog(error.localizedDescription)
        }
        
        self.ringtonePlayer?.volume = 1.0
        self.ringtonePlayer?.play()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if (self.ringtonePlaybackCallback != nil) {
            DispatchQueue.main.async {
                self.ringtonePlaybackCallback!()
            }
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord)
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
