//
//  InviteUserTableViewController.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 4/11/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class InviteUserTableViewController: UITableViewController {
    
    var group: Groups?
    var allUsers: [AllUsers]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TeamImporter.shared.iuvc = self
        TeamImporter.shared.fetchAllUsers { (allUsers) in
            self.allUsers = allUsers
        }
        DispatchQueue.global().async {
            TeamImporter.shared.getUserAndFetchAllDetails()
        }
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = allUsers?.count else { return 0 }
        return count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "inviteCell", for: indexPath) as! InviteUserTableViewCell
        guard let user = allUsers?[indexPath.row] else { return cell }

        cell.userDisplayName.text = user.displayName
        cell.userID = user.id
        cell.userName = user.displayName
        if let imageURL = user.avatar {
            let url = URL(string: imageURL)!
            if let imageData = try? Data(contentsOf: url) {
                cell.userAvatar.image = UIImage(data: imageData)
            }
        }
        cell.group = self.group
        return cell
    }
    
}
