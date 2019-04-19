//
//  GroupInvitesTableViewController.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 4/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class GroupInvitesTableViewController: UITableViewController {
    
    var group: Groups?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TeamImporter.shared.givc = self
        self.tableView.tableFooterView = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        DispatchQueue.global().async {
            TeamImporter.shared.getUserAndFetchAllDetails()
        }
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return TeamImporter.shared.allGroups?[2].count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "invitesCell", for: indexPath) as! GroupInvitesTableViewCell
        
        guard let group = TeamImporter.shared.allGroups?[2][indexPath.row] else { return cell }
        
        cell.groupId = group.groupID
        cell.groupNameLabel.text = group.groupName
        var memberCountString: String?
        if group.members.count > 1 {
            memberCountString = "\(group.members.count) users"
        } else {
            memberCountString = "\(group.members.count) user"
        }
        cell.numberOfUsersLabel.text = memberCountString
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 65))
        let label = UILabel(frame: CGRect(x: 20, y: 25, width: tableView.frame.size.width, height: 65))
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "INVITE REQUEST"
        label.textColor = UIColor.gray
        view.backgroundColor = UIColor.groupTableViewBackground
        view.addSubview(label)
        return view
    }
}
