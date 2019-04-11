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
    
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userDisplayName: UILabel!
    
    @IBAction func declineButton(_ sender: Any) {
        
    }
    
    @IBAction func joinGroupButton(_ sender: Any) {
        
    }
    
}
