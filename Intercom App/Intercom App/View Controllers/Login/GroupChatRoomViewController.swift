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

let baseURLString = "https://3b57e324.ngrok.io"
let accessTokenEndpoint = "/accessToken"
let identity = "alice"
let twimlParamTo = "to"

class GroupChatRoomViewController: UIViewController, PKPushRegistryDelegate, TVONotificationDelegate, TVOCallDelegate, AVAudioPlayerDelegate, UITextFieldDelegate {
    
    
   
    @IBOutlet weak var placeCallButton: UIButton!
    @IBOutlet weak var groupImage: UIImageView!
    //@IBOutlet weak var outgoingValue: UITextField!
    @IBOutlet weak var callControlView: UIView!
    @IBOutlet weak var muteSwitch: UISwitch!
    @IBOutlet weak var speakerSwitch: UISwitch!
    
    var deviceTokenString:String?
    var voipRegistry:PKPushRegistry
    var incomingPushCompletionCallback: (()->Swift.Void?)? = nil
    var incomingAlertController: UIAlertController?
    var callInvite:TVOCallInvite?
    var call:TVOCall?
    var ringtonePlayer:AVAudioPlayer?
    var ringtonePlaybackCallback: (() -> ())?
    
    required init?(coder aDecoder: NSCoder) {
        voipRegistry = PKPushRegistry.init(queue: DispatchQueue.main)
        super.init(coder: aDecoder)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = Set([PKPushType.voIP])
        TwilioVoice.logLevel = .verbose
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func fetchAccessToken() -> String? {
        let endpointWithIdentity = String(format: "%@?identity=%@", accessTokenEndpoint, identity)
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
    
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        <#code#>
    }
    
    func callInviteReceived(_ callInvite: TVOCallInvite) {
        <#code#>
    }
    
    func notificationError(_ error: Error) {
        <#code#>
    }
    
    func callDidConnect(_ call: TVOCall) {
        <#code#>
    }
    
    func call(_ call: TVOCall, didFailToConnectWithError error: Error) {
        <#code#>
    }
    
    func call(_ call: TVOCall, didDisconnectWithError error: Error?) {
        <#code#>
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
