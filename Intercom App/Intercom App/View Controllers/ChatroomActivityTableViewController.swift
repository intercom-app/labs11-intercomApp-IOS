//
//  ChatroomActivityTableViewController.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 4/10/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class ChatroomActivityTableViewController: UITableViewController {

    var group: Groups?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       tableView.reloadData()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return group?.activities.count ?? 0
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath)
        guard let activity = group?.activities[indexPath.row] else { return cell}
        guard let activityString = activity.activity else { return cell }
        cell.textLabel?.text = activity.displayName + ": " + activityString
        cell.detailTextLabel?.text = activity.createdAt
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "inviteSegue" {
            let destination = segue.destination as! InviteUserTableViewController
            destination.group = self.group
        }
    }
}
