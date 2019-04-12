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
    var callStatus: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        TeamImporter.shared.cavc = self
        DispatchQueue.global().async {
//            TeamImporter.shared.getUserAndFetchAllDetails(completion: { (users) in
//                self.tableView.reloadData()
//            })
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
        if let imageURL = activity.avatar {
            let url = URL(string: imageURL)!
            if let imageData = try? Data(contentsOf: url) {
                cell.imageView?.image = UIImage(data: imageData)
            }
        }
        return cell
    }
}
