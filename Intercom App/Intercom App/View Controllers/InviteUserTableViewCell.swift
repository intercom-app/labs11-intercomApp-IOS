//
//  InviteUserTableViewCell.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 4/11/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class InviteUserTableViewCell: UITableViewCell {

    var group: Groups?
    var userID: Int?
    var userName: String?
    var invited: Bool = false
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userDisplayName: UILabel!
    @IBOutlet weak var inviteButtonOutlet: UIButton!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if invited {
            
            inviteButtonOutlet.setTitle("Invited", for: .normal)
            inviteButtonOutlet.setTitleColor(.gray, for: .normal)
        } else {
            inviteButtonOutlet.setTitle("Invite", for: .normal)
            inviteButtonOutlet.setTitleColor(.green, for: .normal)
        }
    }

    
    @IBAction func inviteButton(_ sender: Any) {
        guard let groupID = group?.groupID else { return }
        if invited {
            inviteButtonOutlet.setTitle("Invite", for: .normal)
            inviteButtonOutlet.setTitleColor(.green, for: .normal)
            invited = false
            GroupController.shared.deleteInvitation(groupID: groupID, userID: userID)
            GroupController.shared.postActivity(groupID: groupID, massage: "Cancelled " + "\(String(describing: userName!))" + " invitation.")
        } else {
            inviteButtonOutlet.setTitle("Invited", for: .normal)
            inviteButtonOutlet.setTitleColor(.gray, for: .normal)
            GroupController.shared.postInvitation(groupID: groupID, userID: userID)
            GroupController.shared.postActivity(groupID: groupID, massage: "Invited " + "\(String(describing: userName!))" + " to the group")
            invited = true
        }
    }
}
