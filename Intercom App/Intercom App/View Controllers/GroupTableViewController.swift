//
//  GroupTableViewController.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 3/22/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class GroupTableViewController: UITableViewController {

    //Overrides
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        GroupController.shared.gtvc = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Pull the information in the background of the main thread
        DispatchQueue.global().async {
            GroupController.shared.fetchGroups()
            GroupController.shared.getUser()
        }
    }
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
                GroupController.shared.postRequest(groupName: groupName)
                
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(addCommentAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return GroupController.shared.groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! GroupViewTableViewCell

        cell.groupNameLabel.text = GroupController.shared.groups[indexPath.row].name
        cell.numberOfUsers.text = GroupController.shared.groups[indexPath.row].createdAt

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let group = GroupController.shared.groups[indexPath.row]
            GroupController.shared.groups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            GroupController.shared.deleteRequest(groupID: group.id!)
        }
    }
    
   

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let destination = segue.destination as! GroupDetailViewController
        destination.group = GroupController.shared.groups[indexPath.row]
    }

}
