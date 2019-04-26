//
//  UserListTableViewController.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 4/15/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class UserListTableViewController: UITableViewController {
    
    var group: Groups?
    var allUsers: [AllUsers]?
    
    @IBOutlet weak var inviteButtonOutlet: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        GroupController.shared.fetchGroupMembers(gropeId: group!.groupID) { (users) in
            self.allUsers = users
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        if TeamImporter.shared.userID == group?.owners.first?.id {
            inviteButtonOutlet.isEnabled = true
        } else {
            inviteButtonOutlet.isEnabled = false
            
        }
        TeamImporter.shared.ulvc = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GroupController.shared.fetchGroupMembers(gropeId: group!.groupID) { (users) in
            self.allUsers = users
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // if allUsers == nil {
       // return group?.members.count ?? 0
       // } else {
            return allUsers?.count ?? 0
     //   }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! MemberTableViewCell
        guard let user = allUsers?[indexPath.row] else { return cell }
        cell.group = self.group
       
            cell.activityLabel.text = user.displayName.capitalized
        
        cell.userListTableViewController = self
        cell.user = user
       // self.allUsers = cell.allUsers
//        if cell.bool {
//            cell.bool = false
//            GroupController.shared.fetchGroupMembers(gropeId: group!.groupID) { (users) in
//                self.allUsers = users
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            }
//        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 65))
        let label = UILabel(frame: CGRect(x: 20, y: 25, width: tableView.frame.size.width, height: 65))
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "MEMBERS"
        label.textColor = UIColor.gray
        view.backgroundColor = UIColor.groupTableViewBackground
        view.addSubview(label)
        return view
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "inviteSegue" {
            let destination = segue.destination as! InviteUserTableViewController
            destination.group = self.group
        }
    }
}
