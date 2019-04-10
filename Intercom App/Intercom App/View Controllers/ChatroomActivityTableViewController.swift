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

       
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath)

        cell.textLabel?.text = group?.groupName

        return cell
    }
   


}
