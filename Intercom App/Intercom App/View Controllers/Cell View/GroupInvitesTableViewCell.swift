//
//  GroupInvitesTableViewCell.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 4/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class GroupInvitesTableViewCell: UITableViewCell {
    
    var groupId: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var numberOfUsersLabel: UILabel!
    @IBOutlet weak var groupNameLabel: UILabel!
    
    
    @IBAction func joinGroupButtonAction(_ sender: Any) {
        guard let groupId = groupId else { return }
        GroupController.shared.deleteInvitation(groupID: groupId, userID: TeamImporter.shared.userID)
        GroupController.shared.addGroupMember(groupID: groupId)
        GroupController.shared.postActivity(groupID: groupId, massage: "Joined group.")
        TeamImporter.shared.fetchCurentUserDetails(userID: TeamImporter.shared.userID!)
    }
    
    @IBAction func declineButtonAction(_ sender: Any) {
        guard let groupId = groupId else { return }
        GroupController.shared.deleteInvitation(groupID: groupId, userID: TeamImporter.shared.userID)
        GroupController.shared.postActivity(groupID: groupId, massage: "Declined to join the group")
        TeamImporter.shared.fetchCurentUserDetails(userID: TeamImporter.shared.userID!)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
