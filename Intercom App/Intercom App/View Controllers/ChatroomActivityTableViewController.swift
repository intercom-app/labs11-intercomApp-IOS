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
        self.tableView.tableFooterView = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        TeamImporter.shared.cavc = self
        
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
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 65))
        let label = UILabel(frame: CGRect(x: 20, y: 25, width: tableView.frame.size.width, height: 65))
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "ACTIVITY"
        label.textColor = UIColor.gray
        view.backgroundColor = UIColor.groupTableViewBackground
        view.addSubview(label)
        return view
    }
}
