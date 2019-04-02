//
//  InCallViewController.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 3/28/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import AVFoundation
import MultipeerConnectivity

class InCallViewController: UIViewController, UITableViewDataSource, CallDataDelegate {

    // MARK: Class properties
    var callData: CallData!
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var silenceButton: UIButton!
    @IBOutlet weak var endCallButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: IBActions
    @IBAction func addPeersPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToAddViewController", sender: self)
    }
    
    @IBAction func endCallPresssed(_ sender: UIButton) {
//        // Tear down all callData components
//        callData.audioEngine.stop()
//        callData.serviceBrowser.stopBrowsingForPeers()
//        callData.advertiserAssistant.stop()
//        callData.mcSession.disconnect()
//        callData.currentTableView = nil
        UIDevice.current.isProximityMonitoringEnabled = false
        
        callData.forceDeinit()
        
        let previousDisplayName = callData.thisUser.peerID.displayName
        callData = CallData(displayName: previousDisplayName)
        
        performSegue(withIdentifier: "unwindToAddViewController", sender: self)
    }
    
    @IBAction func muteButtonPressed(_ sender: UIButton) {
        callData.muteToggled()
        switch callData.thisUser.muteStatus {
        case .on:
            muteButton.alpha = ButtonAlpha.on.rawValue
        case .off:
            muteButton.alpha = ButtonAlpha.off.rawValue
        }
    }
    
    @IBAction func silenceButtonPressed(_ sender: UIButton) {
        // Swap silence status of all connected and unconnected peers when silence all button is tapped
        callData.silenceOthersToggled()
        switch callData.thisUser.silenceOthersStatus {
        case .on:
            silenceButton.alpha = ButtonAlpha.on.rawValue
        case .off:
            silenceButton.alpha = ButtonAlpha.off.rawValue
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        callData.currentTableView = tableView
        callData.delegate = self
        nameLabel.text = callData.thisUser.peerID.displayName
        numConnectedPeersChanged(in: callData)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Table View Data Source Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return callData.connectedPeers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "inCallTableViewCell") as! InCallTableViewCell
        cell.peer = callData.connectedPeers[indexPath.row]
        cell.nameLabel.text = cell.peer.peerID.displayName
        switch cell.peer.silencedStatus {
        case .on:
            cell.silenceButton.alpha = ButtonAlpha.on.rawValue
        case .off:
            cell.silenceButton.alpha = ButtonAlpha.off.rawValue
        }
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addVC = segue.destination as? AddViewController {
            addVC.callData = callData
        }
    }
    
    // MARK: CallData delegate method
    func numConnectedPeersChanged(in callData: CallData) {
        // Set various UI Elements to reflect whether we're in a call
        DispatchQueue.main.async {
            if callData.mcSession.connectedPeers.count > 0 {
                self.muteButton.isEnabled = true
                self.silenceButton.isEnabled = true
                self.endCallButton.isEnabled = true
                
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
                // If number of connected peers drops to zero, act as if end call button has been pressed and end call
                self.endCallPresssed(self.endCallButton)
            }
        }
    }

}
