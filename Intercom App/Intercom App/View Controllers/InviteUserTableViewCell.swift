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
    let kInviteButtonTextColor = UIColor(displayP3Red: 1/255, green: 178/255, blue: 1/255, alpha: 1)
    var invited: Bool = false
    var isOwner: Bool = false
    
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userDisplayName: UILabel!
    @IBOutlet weak var inviteButtonOutlet: UIButton!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if isOwner {
            inviteButtonOutlet.setTitle("Owner", for: .normal)
            inviteButtonOutlet.setTitleColor(.lightGray, for: .normal)
            inviteButtonOutlet.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
            inviteButtonOutlet.isEnabled = false
        } else {
            if invited {
                
                inviteButtonOutlet.setTitle("Invited", for: .normal)
                inviteButtonOutlet.setTitleColor(.lightGray, for: .normal)
                inviteButtonOutlet.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
            } else {
                inviteButtonOutlet.setTitle("Invite", for: .normal)
                inviteButtonOutlet.setTitleColor(kInviteButtonTextColor, for: .normal)
                inviteButtonOutlet.setTitleShadowColor(.black, for: .normal)
                inviteButtonOutlet.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
            }
        }
    }
    
    
    @IBAction func inviteButton(_ sender: Any) {
        guard let groupID = group?.groupID else { return }
        if invited {
            inviteButtonOutlet.setTitle("Invite", for: .normal)
            inviteButtonOutlet.setTitleColor(kInviteButtonTextColor, for: .normal)
            inviteButtonOutlet.setTitleShadowColor(.black, for: .normal)
            invited = false
            GroupController.shared.deleteInvitation(groupID: groupID, userID: userID)
            GroupController.shared.postActivity(groupID: groupID, massage: "Cancelled " + "\(String(describing: userName!))" + " invitation.")
        } else {
            inviteButtonOutlet.setTitle("Invited", for: .normal)
            inviteButtonOutlet.setTitleColor(.lightGray, for: .normal)
            GroupController.shared.postInvitation(groupID: groupID, userID: userID)
            GroupController.shared.postActivity(groupID: groupID, massage: "Invited " + "\(String(describing: userName!))" + " to the group")
            invited = true
            
        }
    }
}
