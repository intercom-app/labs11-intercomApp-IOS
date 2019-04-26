//
//  MemberTableViewCell.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 4/25/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class MemberTableViewCell: UITableViewCell {

    
    var group: Groups?
    var user: AllUsers?
//    var bool: Bool = false
    var userListTableViewController: UserListTableViewController?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        removeMemberOutlet.isHidden = true
        if TeamImporter.shared.userID == group?.owners.first?.id {
            removeMemberOutlet.isHidden = false
        }
        
    }
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var removeMemberOutlet: UIButton!
    @IBAction func removeMembarButton(_ sender: Any) {
        guard let user = user else { return }
        GroupController.shared.deleteGroupMamber(groupID: group!.groupID, userID: user.id) { (bool) in
//            self.bool = bool
            DispatchQueue.main.async {
                self.userListTableViewController?.viewDidLoad()
            }

        }
        GroupController.shared.postActivity(groupID: group!.groupID, massage: "Removed \(user.displayName) from group.")
        
    }
}
