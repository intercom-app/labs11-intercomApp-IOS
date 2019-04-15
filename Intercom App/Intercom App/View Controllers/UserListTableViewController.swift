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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TeamImporter.shared.ulvc = self
        DispatchQueue.global().async {
           
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
       
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard var group = self.group else { return }
        let user = group.members
       if group.owners.first?.id == TeamImporter.shared.userID {
            if editingStyle == UITableViewCell.EditingStyle.delete {
              // user.remove(at: indexPath.row)
                
            }
        }
    }
    
}
