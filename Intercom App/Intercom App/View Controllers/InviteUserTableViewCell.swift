//
//  InviteUserTableViewCell.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 4/11/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class InviteUserTableViewCell: UITableViewCell {
    

    //create your closure here
    var buttonPressed : (() -> ()) = {}
    
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userDisplayName: UILabel!
    @IBOutlet weak var inviteButtonOutlet: UIButton!

    
    
    @IBAction func inviteButton(_ sender: Any) {
        buttonPressed()
        
//        guard let groupID = group?.groupID else { return }
//        if invited {
//            inviteButtonOutlet.setTitle("Invite", for: .normal)
//            inviteButtonOutlet.setTitleColor(kInviteButtonTextColor, for: .normal)
//            inviteButtonOutlet.setTitleShadowColor(.black, for: .normal)
//            invited = false
//            GroupController.shared.deleteInvitation(groupID: groupID, userID: userID)
//            GroupController.shared.postActivity(groupID: groupID, massage: "Cancelled " + "\(String(describing: userName!))" + " invitation.")
//        } else {
//            inviteButtonOutlet.setTitle("Invited", for: .normal)
//            inviteButtonOutlet.setTitleColor(.lightGray, for: .normal)
//            GroupController.shared.postInvitation(groupID: groupID, userID: userID)
//            GroupController.shared.postActivity(groupID: groupID, massage: "Invited " + "\(String(describing: userName!))" + " to the group")
//            invited = true
        
}
}
