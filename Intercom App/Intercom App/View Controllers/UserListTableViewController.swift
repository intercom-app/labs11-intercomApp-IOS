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
    @IBOutlet weak var inviteButtonOutlet: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        if TeamImporter.shared.userID == group?.owners.first?.id {
            inviteButtonOutlet.isEnabled = true
        } else {
            inviteButtonOutlet.isEnabled = false
            
        }
        TeamImporter.shared.ulvc = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GroupController.shared.fetchGroupMembers(gropeId: group!.groupID) { (group) in
            self.group = group
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return group?.members.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        guard let user = group?.members[indexPath.row] else { return cell }
        cell.textLabel?.text = user.displayName.capitalized
        
        if TeamImporter.shared.userID == group?.owners.first?.id {
        // declare the button
        let customDetailDisclosureButton = UIButton.init(type: .detailDisclosure)
        
        // set the image for .normal and .selected
        customDetailDisclosureButton.setImage(UIImage(named: "remove-1")?.withRenderingMode(.alwaysTemplate), for: .normal)
        customDetailDisclosureButton.setImage(UIImage(named: "remove-1")?.withRenderingMode(.alwaysTemplate), for: .selected)
        
        // add a target action
        customDetailDisclosureButton.addTarget(self, action: #selector(accessoryButtonTapped), for: .touchUpInside)
        
        cell.accessoryView = customDetailDisclosureButton
        }
        return cell
    }
    
    @objc func accessoryButtonTapped() {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        guard let user = group?.members[indexPath.row] else { return }
        GroupController.shared.deleteGroupMamber(groupID: group!.groupID, userID: user.id)
        GroupController.shared.postActivity(groupID: group!.groupID, massage: "Removed \(user.displayName) from group.")
        GroupController.shared.fetchGroupMembers(gropeId: group!.groupID) { (group) in
            self.group = group
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 65))
        let label = UILabel(frame: CGRect(x: 20, y: 25, width: tableView.frame.size.width, height: 65))
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "MAMBERS"
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
