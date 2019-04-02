//
//  ViewController.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 3/28/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import AVFoundation
import AVKit

class AddViewController: UIViewController, UITableViewDataSource, CallDataDelegate,AddTableViewCellDelegate {

    // MARK: Class properties
    var callData: CallData!
    
    // MARK: IBOutlet properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var endCallButton: UIButton!
    @IBOutlet weak var ongoingCallLabel: UILabel!
    @IBOutlet weak var ongoingCallLabelTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var silenceButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: IBAction methods
    @IBAction func unwindToAddViewController(segue: UIStoryboardSegue) { viewDidLoad() }
    
    @IBAction func ongoingCallTapped(_ sender: UITapGestureRecognizer) {
        print("tapped ongoing call label")
        performSegue(withIdentifier: "segueToInCallViewController", sender: self)
    }
    
    @IBAction func endCallTapped(_ sender: UIButton) {
        print("end call tapped")
        UIDevice.current.isProximityMonitoringEnabled = false
// //        Tear down all callData components
//        callData.audioEngine.stop()
//        callData.serviceBrowser.stopBrowsingForPeers()
//        callData.advertiserAssistant.stop()
//        callData.mcSession.disconnect()
//        callData.currentTableView = nil
        callData.forceDeinit()
        
        let previousDisplayName = callData.thisUser.peerID.displayName
        callData = CallData(displayName: previousDisplayName)
        viewDidLoad() // Simulate arriving here for the first time
//        numConnectedUsersChanged(in: callData)
        // TODO: Reload appropriate table views here
    }
    
    @IBAction func muteButtonTapped(_ sender: UIButton) {
        // Swap mute status when mute button is tapped
        callData.muteToggled()
        switch callData.thisUser.muteStatus {
        case .on:
            muteButton.alpha = ButtonAlpha.on.rawValue
        case .off:
            muteButton.alpha = ButtonAlpha.off.rawValue
        }
    }
    
  
    
    @IBAction func silenceButtonTapped(_ sender: UIButton) {
        // Swap silence status of all connected and unconnected peers when silence all button is tapped
        callData.silenceOthersToggled()
        
        switch callData.thisUser.silenceOthersStatus {
        case .on:
            silenceButton.alpha = ButtonAlpha.on.rawValue
        case .off:
            silenceButton.alpha = ButtonAlpha.off.rawValue
        }
    }
    
    // MARK: viewDidLoad()
    override func viewDidLoad() { // NOTE: Will have issues if this doesn't get called after any segue -- and I doubt it will be
        super.viewDidLoad()
        print("addViewController's viewDidLoad() was called")
        // Try including currentTableView fennagling in delegate
        callData.currentTableView = tableView
        callData.delegate = self
        // TODO: Check for already set values which will affect the UI and update the UI accordingly (ex. mute button opacity)
        nameLabel.text = callData.thisUser.peerID.displayName
        numConnectedPeersChanged(in: callData)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let inCallVC = segue.destination as? InCallViewController {
            print("segue to in call view controller")
            inCallVC.callData = callData
        }
        else if let _ = segue.destination as? NameViewController {
            // Tear down all callData components
            print("segue to name view controller")
            callData.audioEngine.stop()
            callData.serviceBrowser.stopBrowsingForPeers()
            callData.advertiserAssistant.stop()
            callData.mcSession.disconnect()
            callData.currentTableView = nil
        }
    }

    // MARK: TableView Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Assuming there's only 1 section
        return callData.nearbyPeers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addTableViewCell") as! AddTableViewCell
        cell.peer = callData.nearbyPeers[indexPath.row]
        cell.nameLabel.text = cell.peer.peerID.displayName
        cell.delegate = self
        return cell
    }
    
    // MARK: CallData Delegate method
    func numConnectedPeersChanged(in callData: CallData) {
        // Set various UI Elements to reflect whether we're in a call
        DispatchQueue.main.async {
            if callData.mcSession.connectedPeers.count > 0 {
                // Set connected peers label
                self.ongoingCallLabel.isEnabled = true
                self.ongoingCallLabelTapGestureRecognizer.isEnabled = true
                self.ongoingCallLabel.text = callData.connectedPeers.count == 1 ? "Ongoing Call: \(callData.mcSession.connectedPeers.count) Peer" : "Ongoing Call: \(callData.mcSession.connectedPeers.count) Peers"
                self.muteButton.isEnabled = true
                self.silenceButton.isEnabled = true
                self.endCallButton.isEnabled = true
                UIDevice.current.isProximityMonitoringEnabled = true
                
                // TODO: Replace these constant alpha values with an enum
                if callData.thisUser.muteStatus == .on {
                    self.muteButton.alpha = ButtonAlpha.on.rawValue
                } else {
                    self.muteButton.alpha = ButtonAlpha.off.rawValue
                }
                
                if callData.thisUser.silenceOthersStatus == .on {
                    self.silenceButton.alpha = ButtonAlpha.on.rawValue
                } else {
                    self.silenceButton.alpha = ButtonAlpha.off.rawValue
                }
                
            } else {
                // Set connected peers label
                self.ongoingCallLabel.isEnabled = false
                self.ongoingCallLabelTapGestureRecognizer.isEnabled = false
                self.ongoingCallLabel.text = "Not In Call"
                self.muteButton.isEnabled = false
                self.silenceButton.isEnabled = false
                self.endCallButton.isEnabled = false
                UIDevice.current.isProximityMonitoringEnabled = false
            }
        }
    }
    
    // MARK: AddTableViewCell delegate method - Triggered when add button is pressed in table view cell
    func addTableViewCellAddButtonPressed(on peer: Peer) {
        callData.serviceBrowser.invitePeer(peer.peerID, to: callData.mcSession, withContext: nil, timeout: 0.0)
    }
    
}
