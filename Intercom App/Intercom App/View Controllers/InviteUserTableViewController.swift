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
    var invitedUserId: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       invitedUserId = []
        TeamImporter.shared.iuvc = self
        TeamImporter.shared.fetchAllUsers { (allUsers) in
            self.allUsers = allUsers
            self.findAllInviteesInTheGroup()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        DispatchQueue.global().async {
            TeamImporter.shared.getUserAndFetchAllDetails()
        }
       
    }
    
    func findAllInviteesInTheGroup() {
        guard let groupInvitees = group?.invitees else { return }
        for numberOfGroup in groupInvitees {
            let id = numberOfGroup.id
            invitedUsersShouldBeInactive(userID: id)
        }
        
    }
    func invitedUsersShouldBeInactive(userID: Int)  {
        guard let allUsers = allUsers else { return }
        for user in allUsers {
            if userID == user.id {
                self.invitedUserId.append(userID)
            }
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
        if invitedUserId != [] {
        for id in invitedUserId {
        if user.id == id {
            cell.invited = true
            
            cell.userID = user.id
            cell.userName = user.displayName
            if let imageURL = user.avatar {
                let url = URL(string: imageURL)!
                if let imageData = try? Data(contentsOf: url) {
                    cell.userAvatar.image = UIImage(data: imageData)
                }
            }
                    cell.userDisplayName.text = user.displayName
                    cell.group = self.group
                    return cell
        } else {
        cell.userID = user.id
        }
        }
        } else {
            cell.userID = user.id
        }
        cell.userName = user.displayName
        if let imageURL = user.avatar {
            let url = URL(string: imageURL)!
            if let imageData = try? Data(contentsOf: url) {
                cell.userAvatar.image = UIImage(data: imageData)
            }
        }
        cell.userDisplayName.text = user.displayName
        cell.group = self.group
        return cell
    }
    
}
