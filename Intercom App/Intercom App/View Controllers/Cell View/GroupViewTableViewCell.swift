//
//  GroupViewTableViewCell.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 3/22/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class GroupViewTableViewCell: UITableViewCell {

    var groupId: Int?
    
    @IBOutlet weak var groupOwnedToImage: UIImageView!
    @IBOutlet weak var groupOwnedToNameLabel: UILabel!
    @IBOutlet weak var groupOwnedTonumberOfUsers: UILabel!
    
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var joinGroupbutton: UIButton!
    
    @IBAction func joinGroupButtonAction(_ sender: Any) {
        
    }
    
    @IBAction func declineButtonAction(_ sender: Any) {
        GroupController.shared.deleteInvitation(groupID: groupId!, userID: TeamImporter.shared.userID)
        GroupController.shared.postActivity(groupID: groupId!, massage: "Declined to join the group")
        TeamImporter.shared.fetchCurentUserDetails(userID: TeamImporter.shared.userID!)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
