//
//  GroupTableViewController.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 3/22/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class GroupListViewController: UITableViewController {

    
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TeamImporter.shared.gtvc = self
        GroupController.shared.gtvc = self
        //Pull the information in the background of the main thread
        DispatchQueue.global().async {
            TeamImporter.shared.getUserAndFetchAllDetails()
        }
    }
   
    
    @IBAction func addNewGroupe(_ sender: Any) {
        
            let alert = UIAlertController(title: "Add a Group", message: "Write your group name below:", preferredStyle: .alert)
            var commentTextField: UITextField?
            
            alert.addTextField { (textField) in
                textField.placeholder = "Group Name:"
                commentTextField = textField
            }
            
            let addCommentAction = UIAlertAction(title: "Add Group", style: .default) { (_) in
                
                guard let groupName = commentTextField?.text else { return }
                GroupController.shared.createNewGroup(groupName: groupName)
                
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(addCommentAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return TeamImporter.shared.allGroups?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return TeamImporter.shared.allGroups?[section].count ?? 0
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupsCell", for: indexPath) as! GroupViewTableViewCell
        
        guard let group = TeamImporter.shared.allGroups?[indexPath.section][indexPath.row] else { return cell }
        
        
        if indexPath.section == 2 {
           guard let group = TeamImporter.shared.allGroups?[2][indexPath.row] else { return cell }
            cell.joinGroupbutton.isHidden = false
            cell.declineButton.isHidden = false
            
            cell.groupOwnedToNameLabel.text = group.groupName
            cell.groupOwnedTonumberOfUsers.text = group.groupCreatedAt
            return cell
        } else {
            cell.joinGroupbutton.isHidden = true
            cell.declineButton.isHidden = true
        }
        
        cell.groupOwnedToNameLabel.text = group.groupName
        cell.groupOwnedTonumberOfUsers.text = group.groupCreatedAt

        return cell

    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
        let label = UILabel()
        label.center = view.center
        label.text = "Owned Groups"
        label.backgroundColor = UIColor.lightGray
            return label
        } else if section == 1 {
            let label = UILabel()
            label.text = "Groups Belong To"
            label.backgroundColor = UIColor.lightGray
            return label
        } else {
            let label = UILabel()
            label.text = "Groups Invited To"
            label.backgroundColor = UIColor.lightGray
            return label
        }
        
    }
    

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            guard let group = TeamImporter.shared.allGroups?[indexPath.section][indexPath.row] else { return }
            if group.owners.first?.id == TeamImporter.shared.userID {
                if editingStyle == UITableViewCell.EditingStyle.delete {
            TeamImporter.shared.allGroups?[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            GroupController.shared.deleteGroupRequest(groupID: group.groupID)
            }
        }
    }
    
   

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let destination = segue.destination as! ChatroomViewController
        guard let group = TeamImporter.shared.allGroups?[indexPath.section][indexPath.row] else { return }
        destination.group = group
        TeamImporter.shared.getUserAndFetchAllDetails()
    }

}
