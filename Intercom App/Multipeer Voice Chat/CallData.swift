//
//  CallData.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 3/29/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//


import Foundation
import AVFoundation
import MultipeerConnectivity

class CallData: NSObject {
    
    // MARK: Properties
    var mcSession: MCSession!
    var advertiserAssistant: MCAdvertiserAssistant!
    var serviceBrowser: MCNearbyServiceBrowser!
    let kServiceType = "mp-voice-chat"
    
    var audioEngine = AVAudioEngine()
    var audioPlayerNode = AVAudioPlayerNode() // REMOVE if possible
    let audioFormat = AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 1)
    
    var nearbyPeers: [Peer] = []
    var connectedPeers: [Peer] = []
    var thisUser: ThisUser!
    
    var delegate: CallDataDelegate?
    weak var currentTableView: UITableView?
    
    // MARK: Initializers
    init(displayName: String) {
        super.init()
        
        setUpThisUser(displayName: displayName)
        setUpMCSession()
        setUpMCAdvertiserAssistant()
        setUpMCNearbyServiceBrowser()
        setUpAudioSession()
    }
    
    // MARK: Setup methods
    func setUpThisUser(displayName: String) {
        let ourDefaults = UserDefaults.standard
        
        // Set up this user's MCPeerID and ThisUser object
        let thisUserMCPeerID = MCPeerID(displayName: displayName)
        thisUser = ThisUser(with: thisUserMCPeerID)
        
        // Store this display name in UserDefaults
//        ourDefaults.set(displayName, forKey: "displayName")
        
        // Grab and set stored values for silenceOthersStatus and muteStatus if stored in UserDefaults
        if let silenceOthersStoredValue = ourDefaults.object(forKey: "silenceOthers") as? Bool {
            print("stored silenceOthers value is \(silenceOthersStoredValue)")
            thisUser.silenceOthersStatus = silenceOthersStoredValue ? .on : .off
        }

        if let muteSelfStoredValue = ourDefaults.object(forKey: "muteSelf") as? Bool {
            print("stored muteSelf value is \(muteSelfStoredValue)")
            thisUser.muteStatus = muteSelfStoredValue ? .on : .off
        }
    }
    
    func setUpMCSession() {
        mcSession = MCSession(peer: thisUser.peerID, securityIdentity: nil, encryptionPreference: .none)
        mcSession.delegate = self
    }
    
    func setUpMCAdvertiserAssistant() {
        advertiserAssistant = MCAdvertiserAssistant(serviceType: kServiceType, discoveryInfo: nil, session: mcSession)
        advertiserAssistant.start()
    }
    
    func setUpMCNearbyServiceBrowser() {
        serviceBrowser = MCNearbyServiceBrowser(peer: thisUser.peerID, serviceType: kServiceType)
        serviceBrowser.delegate = self
        serviceBrowser.startBrowsingForPeers()
    }
    
    func setUpAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
            try audioSession.setPreferredIOBufferDuration(128.0 / 44100.0)
        } catch {
            fatalError("Unable to set up audio session correctly")
        }
        
        let inputNode = audioEngine.inputNode
        
        // Install tap on bus to grab audio data from mic and transmit to all connected peers
        inputNode.installTap(onBus: 0, bufferSize: 4096, format: audioFormat) { (buffer, time) in
            let abs_time = mach_absolute_time()
            let diff = abs_time - time.hostTime
            //print("There are \(self.mcSession.connectedPeers.count) connected peers")
            print("Sample host time: \(time.hostTime), System absolute time: \(abs_time), Diff: \(diff)")
            if (diff < 200000000 && self.thisUser.muteStatus == .off) { // Try to avoid sending data which is too old
                let dataVersion = self.toData(from: buffer)
                do {
                    try self.mcSession.send(dataVersion, toPeers: self.mcSession.connectedPeers, with: .unreliable)
                    print("sent data to connected peers")
                } catch {
                    print("error sending data to connected peers")
                }
            }
        }
        
        let spareAudioPlayerNode = AVAudioPlayerNode()
        let mainMixer = audioEngine.mainMixerNode
        audioEngine.attach(spareAudioPlayerNode)
        audioEngine.connect(spareAudioPlayerNode, to: mainMixer, format: audioFormat)
        
        do {
            try audioEngine.start()
        } catch {
            fatalError("Unable to start audio engine")
        }
        
    }
    
    // MARK: Deinitializer (I'm not sure if this is called as expected)
    deinit {
        audioEngine.stop()
        serviceBrowser.stopBrowsingForPeers()
        advertiserAssistant.stop()
        mcSession.disconnect()
        currentTableView = nil
    }
    
    func forceDeinit() {
        audioEngine.stop()
        serviceBrowser.stopBrowsingForPeers()
        advertiserAssistant.stop()
        mcSession.disconnect()
        currentTableView = nil
    }
    
}

// MARK: MCSessionDelegate methods
extension CallData: MCSessionDelegate {
    
    // Notifies when someone connects to or disconnects from the MCSession
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("peer with display name: \(peerID.displayName) connected")

            // Remove newly connected peer from nearbyPeers if it can be found
            if let correspondingNearbyPeerPos = nearbyPeers.firstIndex(where: { $0 == peerID }) {
                print("corresponding nearby peer found")
                let newPeer = nearbyPeers[correspondingNearbyPeerPos]

                connectedPeers.append(newPeer)
                nearbyPeers.remove(at: correspondingNearbyPeerPos)
                print("There are now \(connectedPeers.count) connected peers in the local array and \(mcSession.connectedPeers.count) peers in the mcSession.connectedPeers array")
                print("connectedPeers[0]'s display name is \(connectedPeers[0].peerID.displayName)")

                let mainMixer = audioEngine.mainMixerNode
                audioEngine.attach(newPeer.playerNode)
                audioEngine.connect(newPeer.playerNode, to: mainMixer, format: audioFormat)
                //                try! audioEngine.start()
            } else {
                print("unable to find newly connected peer in nearbyPeers")
            }

            DispatchQueue.main.async {
                self.currentTableView?.reloadData()
            }
        case .connecting:
            print("peer with display name: \(peerID.displayName) is connecting")
        case .notConnected:
            print("no longer in contact with peer with display name: \(peerID.displayName)")

            // Remove the peer from the list of connected peers if it's there
            if let peerIndexToRemove = connectedPeers.firstIndex(where: { $0 == peerID }) {
                let playerNodeToDetach = connectedPeers[peerIndexToRemove].playerNode
                audioEngine.detach(playerNodeToDetach)
                connectedPeers.remove(at: peerIndexToRemove)
            }

            DispatchQueue.main.async {
                self.currentTableView?.reloadData()
            }
        @unknown default:
            fatalError("Swich error")
        }
        
        delegate?.numConnectedPeersChanged(in: self)

        print("nearbyPeers looks like: ")
        for peer in nearbyPeers {
            print("\"\(peer.peerID.displayName)\"")
        }
        print("connectedPeers looks like: ")
        for peer in connectedPeers {
            print("\"\(peer.peerID.displayName)\"")
        }
    }
    
    // Recieve and now reconstruct data
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("recieved data from peer with display name: \(peerID.displayName)")
        
        if let indexOfCorrespondingUserData = connectedPeers.firstIndex(where: { $0 == peerID }) {
            let peer = connectedPeers[indexOfCorrespondingUserData]
            let playerNode = peer.playerNode
            peer.timesPlayed = peer.timesPlayed &+ 1
            if (peer.timesPlayed % 63 == 0) {
                // Reset this player node every so often to deal with potential lag issues
                print("Resetting audio playback node")
                playerNode.stop()
            }
            let reconstructedBuffer = toPCMBuffer(data: data)
            playerNode.scheduleBuffer(reconstructedBuffer, completionHandler: nil)
            if (playerNode.engine?.isRunning ?? false) {
                playerNode.play()
            } else {
                print("Engine isn't running, so playerNode won't play")
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("recieved an InputStream from peer with display name: \(peerID.displayName)")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("started recieving a resource from peer with display name: \(peerID.displayName)")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("finished recieving a resource from peer with display name: \(peerID.displayName)")
    }
    
}

// MARK: MCNearbyServiceBrowserDelegate methods
extension CallData: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("found new peer with display name: \(peerID.displayName)")
        
        // Only add the peer if they're not already in nearbyPeers.
        // This is needed because this function gets called when the app is opened and closed again
        if !nearbyPeers.contains(where: {$0 == peerID} ) {
            nearbyPeers.append(Peer(with: peerID))
            DispatchQueue.main.async {
                self.currentTableView?.reloadData()
            }
            if currentTableView == nil {
                print("currentTableView is nil")
            }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("lost peer with display name: \(peerID.displayName)")
        
        if let peerPos = nearbyPeers.firstIndex(where: { $0 == peerID }) {
            nearbyPeers.remove(at: peerPos)
        }
        DispatchQueue.main.async {
            self.currentTableView?.reloadData()
        }
    }
    
}

// MARK: Methods dealing with unpacking/repacking audio buffers
extension CallData {
    
    func toData(from pcmBuffer: AVAudioPCMBuffer) -> Data {
        let channelCount = 1
        let channels = UnsafeBufferPointer(start: pcmBuffer.floatChannelData, count: channelCount)
        let channel0Data = Data(bytes: channels[0], count: Int(pcmBuffer.frameCapacity * pcmBuffer.format.streamDescription.pointee.mBytesPerFrame))
        
        return channel0Data
    }
    
    func toPCMBuffer(data: Data) -> AVAudioPCMBuffer {
        let nsDataVersion = NSData(data: data)
        let audioFormat = AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 1)
        let audioBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat!, frameCapacity: 4410)
        audioBuffer?.frameLength = 4410
        let channels = UnsafeBufferPointer(start: audioBuffer?.floatChannelData, count: Int((audioBuffer?.format.channelCount)!))
        nsDataVersion.getBytes(UnsafeMutableRawPointer(channels[0]), length: nsDataVersion.length)
        
        return audioBuffer!
    }
    
}

// MARK: Method for toggling global mute and silence statuses
extension CallData {
    
    func silenceOthersToggled() {
//        let ourDefaults = UserDefaults.standard
        
        switch thisUser.silenceOthersStatus {
        case .on:
            thisUser.silenceOthersStatus = .off
            
            for peer in nearbyPeers {
                peer.silencedStatus = .off
            }
            for peer in connectedPeers {
                peer.silencedStatus = .off
            }
        case .off:
            thisUser.silenceOthersStatus = .on
            
            for peer in nearbyPeers {
                peer.silencedStatus = .on
            }
            for peer in connectedPeers {
                peer.silencedStatus = .on
                
            }
        }
        
        switch thisUser.silenceOthersStatus {
        case .on:
            print("on")
        case .off:
            print("off")
        }
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
    
    func muteToggled() {
//        let ourDefaults = UserDefaults.standard
        
        switch thisUser.muteStatus {
        case .on:
            thisUser.muteStatus = .off
        case .off:
            thisUser.muteStatus = .on
        }
        
//        ourDefaults.set(thisUser.muteStatus, forKey: "muteSelf")
    }

}

protocol CallDataDelegate {
    func numConnectedPeersChanged(in callData: CallData)
}
