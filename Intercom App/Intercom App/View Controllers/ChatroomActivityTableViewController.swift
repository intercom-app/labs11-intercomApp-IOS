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
    var activity: [Activities] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GroupController.shared.fetchGroupActivities(groupID: group!.groupID) { (test) in
            guard let test = test else { return }
            self.activity = test
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return activity.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath)
        cell.textLabel?.text = activity[indexPath.row].displayName + ": " + activity[indexPath.row].activity
        cell.detailTextLabel?.text = activity[indexPath.row].createdAt
        return cell
    }
   


}
