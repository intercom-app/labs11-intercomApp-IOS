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
    
    
    @IBOutlet weak var groupOwnedToNameLabel: UILabel!
    @IBOutlet weak var groupOwnedTonumberOfUsers: UILabel!
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
