//
//  UserData.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 3/29/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import AVFoundation

class UserData {
    var mcPeerID: MCPeerID
    var muteStatus: ControlStatus = .off
    var silenceOthersStatus: ControlStatus = .off
    var audioPlayer = AVAudioPlayerNode()
    
    init(displayName: String) {
        mcPeerID = MCPeerID(displayName: displayName)
    }
    
    init(peerID: MCPeerID) {
        self.mcPeerID = peerID
    }
}
