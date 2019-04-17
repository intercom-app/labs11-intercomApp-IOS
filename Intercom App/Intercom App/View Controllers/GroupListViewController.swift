//
//  GroupTableViewController.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 3/22/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class GroupListViewController: UITableViewController {
    
    var sectionHeaderInvitedTo: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        TeamImporter.shared.gtvc = self
        GroupController.shared.gtvc = self
        //Pull the information in the background of the main thread
        DispatchQueue.global().async {
            TeamImporter.shared.getUserAndFetchAllDetails()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        if section == 2 {
            return 1
        } else {
            return TeamImporter.shared.allGroups?[section].count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupsCell", for: indexPath) as! GroupViewTableViewCell
        
        guard let group = TeamImporter.shared.allGroups?[indexPath.section][indexPath.row] else { return cell }
        
        
        if indexPath.section == 2 {
            guard let group = TeamImporter.shared.allGroups?[2][indexPath.row] else { return cell }
            
            cell.groupId = group.groupID
            cell.groupOwnedToNameLabel.text = "Invites"
            
            // Configure Cell Badge
            if let badgeCount = TeamImporter.shared.allGroups?[2].count {
           cell.update(count: badgeCount)
            }
            return cell
        } else {
            
        }
        cell.groupId = group.groupID
        cell.groupOwnedToNameLabel.text = group.groupName
        cell.groupOwnedTonumberOfUsers.text = "\(group.members.count) users"
        
        return cell
        
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        if section == 0 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 65))
            let label = UILabel(frame: CGRect(x: 10, y: 25, width: tableView.frame.size.width, height: 65))
            label.font = UIFont.systemFont(ofSize: 14)
            label.text = "MY GROUPS"
            label.textColor = UIColor.gray
            view.backgroundColor = UIColor.groupTableViewBackground
            view.addSubview(label)
            return view
        } else if section == 1 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 65))
            let label = UILabel(frame: CGRect(x: 10, y: 25, width: tableView.frame.size.width, height: 65))
            label.font = UIFont.systemFont(ofSize: 14)
            label.text = "OTHER GROUPS"
            label.textColor = UIColor.gray
            view.backgroundColor = UIColor.groupTableViewBackground
            view.addSubview(label)
            return view
        } else {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 65))
            let label = UILabel(frame: CGRect(x: 10, y: 25, width: tableView.frame.size.width, height: 65))
            label.font = UIFont.systemFont(ofSize: 14)
            label.text = "GROUP INVITES"
            label.textColor = UIColor.gray
            view.backgroundColor = UIColor.groupTableViewBackground
            view.addSubview(label)
            return view
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if tableView.indexPathForSelectedRow?.section == 2 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "GroupInvites")
            self.navigationController?.pushViewController(vc!, animated: true)
            return false
        }
        return true
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        var segueIdentifier: String!
        if indexPath.section == 2 {
            segueIdentifier = "invitesSegue"
        } else{
            segueIdentifier = "chatroomSegue"
        }
        if segue.identifier == segueIdentifier {
            let destination = segue.destination as! ChatroomViewController
            guard let group = TeamImporter.shared.allGroups?[indexPath.section][indexPath.row] else { return }
            destination.group = group
        } else if segue.identifier == segueIdentifier {
            let vc = storyboard?.instantiateViewController(withIdentifier: "GroupInvites")
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
}

extension UITableViewCell {
    func update(count: Int) {
        // Count > 0, show count
        if count > 0 {
            
            // Create label
            let fontSize: CGFloat = 16
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: fontSize)
            label.textAlignment = .center
            label.textColor = UIColor.white
            label.backgroundColor = UIColor(displayP3Red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
            
            // Add count to label and size to fit
            label.text = "\(NSNumber(value: count))"
            label.sizeToFit()
            
            // Adjust frame to be square for single digits or elliptical for numbers > 9
            var frame: CGRect = label.frame
            frame.size.height += CGFloat(Int(0.4 * fontSize))
            frame.size.width = (count <= 9) ? frame.size.height : frame.size.width + CGFloat(Int(fontSize))
            label.frame = frame
            
            // Set radius and clip to bounds
            label.layer.cornerRadius = frame.size.height / 2.0
            label.clipsToBounds = true
            
            // Show label in accessory view and remove disclosure
            self.accessoryView = label
            self.accessoryType = .none
        } else {
            self.accessoryView = nil
            self.accessoryType = .disclosureIndicator
        }
    }
}
