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
   

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
