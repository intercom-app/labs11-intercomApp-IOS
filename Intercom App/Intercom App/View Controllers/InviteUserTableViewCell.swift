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
    
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userDisplayName: UILabel!
    @IBOutlet weak var inviteButtonOutlet: UIButton!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if userID == 0 {
            
            inviteButtonOutlet.setTitle("Invited", for: .normal)
            inviteButtonOutlet.setTitleColor(.gray, for: .normal)
            inviteButtonOutlet.isEnabled = false
        } else {
           print(userID)
        }
    }

    
    @IBAction func inviteButton(_ sender: Any) {
        
        if userID == 0 {
        } else {
        
        inviteButtonOutlet.setTitle("Invited", for: .normal)
        inviteButtonOutlet.setTitleColor(.gray, for: .normal)
        inviteButtonOutlet.isEnabled = false
        GroupController.shared.postInvitation(groupID: group!.groupID, userID: userID)
        GroupController.shared.postActivity(groupID: group!.groupID, massage: "Invited " + "\(String(describing: userName!))" + " to the group")
            
        TeamImporter.shared.getUserAndFetchAllDetails()
    }
    
    }
}
