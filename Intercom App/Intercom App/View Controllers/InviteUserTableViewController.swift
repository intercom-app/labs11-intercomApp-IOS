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
    var allUsers: [AllUsers] = []
    var members: [AllUsers] = []
    var invitees: [AllUsers] = []
    var groupOwner: [AllUsers] = []
    var otherUsers: [AllUsers] = []
    var groupMembers: [[AllUsers]] = []
    var searchedUsers: [[AllUsers]] = []
    var searchedUsersArray: [AllUsers] = []
    var isSearching = false
    let kInviteButtonTextColor = UIColor(displayP3Red: 1/255, green: 178/255, blue: 1/255, alpha: 1)
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TeamImporter.shared.iuvc = self
        TeamImporter.shared.fetchAllUsers { (allUsers) in
            self.allUsers = allUsers ?? []
            self.findAllInviteesInTheGroup()
            self.groupMembers = [self.members, self.invitees, self.otherUsers]
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        DispatchQueue.global().async {
            TeamImporter.shared.getUserAndFetchAllDetails()
        }
        
        // search delegate
        searchBar.delegate = self
        
        // hide keyboard when tapping on the screen
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.singleTap(sender:)))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    @objc func singleTap(sender: UITapGestureRecognizer) {
        self.searchBar.resignFirstResponder()
    }
    
    func findAllInviteesInTheGroup() {
        
        if isSearching {
            guard let groupInvitees = group?.invitees else { return }
            self.invitees.removeAll()
            for userOfGroup in groupInvitees {
                let id = userOfGroup.id
                for user in searchedUsersArray {
                    if id == user.id {
                        self.invitees.append(user)
                    }
                }
            }
            guard let groupMembers = group?.members else { return }
            self.members.removeAll()
            for userOfGroup in groupMembers {
                let id = userOfGroup.id
                for user in searchedUsersArray {
                    if id == user.id {
                        self.members.append(user)
                    }
                }
            }
            self.otherUsers.removeAll()
            for user in searchedUsersArray {
                if (!self.members.contains { ($0.id == user.id)}) && (!self.invitees.contains { ($0.id == user.id)}) && user.id != TeamImporter.shared.userID {
                    self.otherUsers.append(user)
                }
            }
            let invArr = invitees.sorted {$0.displayName < $1.displayName}
            let membArr = members.sorted {$0.displayName < $1.displayName}
            let othArr = otherUsers.sorted {$0.displayName < $1.displayName}
            self.searchedUsers = [membArr, invArr, othArr]
            tableView.reloadData()
        } else {
            
            guard let groupInvitees = group?.invitees else { return }
            self.invitees.removeAll()
            for userOfGroup in groupInvitees {
                let id = userOfGroup.id
                for user in allUsers {
                    if id == user.id {
                        self.invitees.append(user)
                    }
                }
            }
            self.members.removeAll()
            guard let groupMembers = group?.members else { return }
            for userOfGroup in groupMembers {
                let id = userOfGroup.id
                for user in allUsers {
                    if id == user.id {
                        self.members.append(user)
                    }
                }
            }
            self.otherUsers.removeAll()
            for user in allUsers {
                if (!self.members.contains { ($0.id == user.id)}) && (!self.invitees.contains { ($0.id == user.id)}) && user.id != TeamImporter.shared.userID {
                    self.otherUsers.append(user)
                }
            }
            self.invitees.sort {$0.displayName < $1.displayName}
            self.members.sort {$0.displayName < $1.displayName}
            self.otherUsers.sort {$0.displayName < $1.displayName}
            tableView.reloadData()
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.isSearching {
            if searchedUsers.count > 1 {
                switch section {
                case 0:
                    return searchedUsers[0].count
                case 1:
                    return searchedUsers[1].count
                default:
                    return searchedUsers[2].count
                }
            }
        } else {
            if groupMembers.count > 1 {
                switch section {
                case 0:
                    return groupMembers[0].count
                case 1:
                    return groupMembers[1].count
                default:
                    return groupMembers[2].count
                }
            } else {
                return 0
            }
        }
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "inviteCell", for: indexPath) as! InviteUserTableViewCell
        var userData: [[AllUsers]]?
        if self.isSearching {
            userData = searchedUsers
        } else {
            userData = groupMembers
        }
        
        guard let userDataBase = userData else { return cell }
        guard let groupID = self.group?.groupID else { return cell }
        cell.userDisplayName.text = ""
        cell.userAvatar.image = nil
        switch indexPath.section {
        case 0:
            let user = userDataBase[0][indexPath.row]
            cell.userDisplayName.text = user.displayName
            cell.inviteButtonOutlet.setTitle("", for: .normal)
            if let avatorStringUrl = user.avatar {
                let url = URL(string: avatorStringUrl)
                DispatchQueue.global().async {
                    guard let data = try? Data(contentsOf: url!) else { return }
                    DispatchQueue.main.async {
                        cell.userAvatar.image = UIImage(data: data)
                    }
                }
            }
            return cell
        case 1:
            let user = userDataBase[1][indexPath.row]
            cell.userDisplayName.text = user.displayName
            cell.inviteButtonOutlet.setTitle("Invited", for: .normal)
            cell.inviteButtonOutlet.setTitleColor(.lightGray, for: .normal)
            cell.inviteButtonOutlet.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
            if let avatorStringUrl = user.avatar {
                let url = URL(string: avatorStringUrl)
                DispatchQueue.global().async {
                    guard let data = try? Data(contentsOf: url!) else { return }
                    DispatchQueue.main.async {
                        cell.userAvatar.image = UIImage(data: data)
                    }
                }
            }
            cell.buttonPressed = {
                
                cell.inviteButtonOutlet.setTitle("Invite", for: .normal)
                cell.inviteButtonOutlet.setTitleColor(self.kInviteButtonTextColor, for: .normal)
                cell.inviteButtonOutlet.setTitleShadowColor(.black, for: .normal)
                GroupController.shared.deleteInvitation(groupID: groupID, userID: user.id)
                GroupController.shared.postActivity(groupID: groupID, massage: "Cancelled " + "\(String(describing: user.displayName))" + " invitation.")
                self.invitees.remove(at: indexPath.row)
                self.otherUsers.append(user)
                self.otherUsers.sort {$0.displayName < $1.displayName}
                self.invitees.sort {$0.displayName < $1.displayName}
                self.groupMembers = [self.members, self.invitees, self.otherUsers]
                self.tableView.reloadData()
            }
            return cell
        default:
            let user = userDataBase[2][indexPath.row]
            cell.userDisplayName.text = user.displayName
            cell.inviteButtonOutlet.setTitle("Invite", for: .normal)
            cell.inviteButtonOutlet.setTitleShadowColor(.black, for: .normal)
            cell.inviteButtonOutlet.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
            cell.inviteButtonOutlet.setTitleColor(kInviteButtonTextColor, for: .normal)
            if let avatorStringUrl = user.avatar {
                let url = URL(string: avatorStringUrl)
                DispatchQueue.global().async {
                    guard let data = try? Data(contentsOf: url!) else { return }
                    DispatchQueue.main.async {
                        cell.userAvatar.image = UIImage(data: data)
                    }
                }
            }
            
            cell.buttonPressed = {
                cell.inviteButtonOutlet.setTitle("Invited", for: .normal)
                cell.inviteButtonOutlet.setTitleColor(.lightGray, for: .normal)
                GroupController.shared.postInvitation(groupID: groupID, userID: user.id)
                GroupController.shared.postActivity(groupID: groupID, massage: "Invited " + "\(String(describing: user.displayName))" + " to the group")
                self.otherUsers.remove(at: indexPath.row)
                self.invitees.append(user)
                self.groupMembers = [self.members, self.invitees, self.otherUsers]
                self.invitees.sort {$0.displayName < $1.displayName}
                self.otherUsers.sort {$0.displayName < $1.displayName}
                self.tableView.reloadData()
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 65))
            let label = UILabel(frame: CGRect(x: 10, y: 25, width: tableView.frame.size.width, height: 65))
            label.font = UIFont.systemFont(ofSize: 14)
            label.text = "MEMBERS"
            label.textColor = UIColor.gray
            view.backgroundColor = UIColor.groupTableViewBackground
            view.addSubview(label)
            return view
        } else if section == 1 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 65))
            let label = UILabel(frame: CGRect(x: 10, y: 25, width: tableView.frame.size.width, height: 65))
            label.font = UIFont.systemFont(ofSize: 14)
            label.text = "INVITES"
            label.textColor = UIColor.gray
            view.backgroundColor = UIColor.groupTableViewBackground
            view.addSubview(label)
            return view
        } else {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 65))
            let label = UILabel(frame: CGRect(x: 10, y: 25, width: tableView.frame.size.width, height: 65))
            label.font = UIFont.systemFont(ofSize: 14)
            label.text = "USERS"
            label.textColor = UIColor.gray
            view.backgroundColor = UIColor.groupTableViewBackground
            view.addSubview(label)
            return view
        }
    }
    
}

extension InviteUserTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            self.isSearching = false
            print("search text cleard")
            self.findAllInviteesInTheGroup()
        }
        print("Text is: \(searchText)")
        self.searchedUsersArray = self.allUsers.filter({ (text:AllUsers) -> Bool in
            return (text.displayName.trimmingCharacters(in: CharacterSet.whitespaces).lowercased().contains(searchText.trimmingCharacters(in: .whitespaces).lowercased()))
        })
        
//        if searchedUsersArray.count > 0 {
            self.isSearching = true
            self.findAllInviteesInTheGroup()
//        }
//        else {
//            self.isSearching = false
//        }
        self.tableView.reloadData()
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.isSearching = false
        self.findAllInviteesInTheGroup()
        tableView.reloadData()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.isSearching = false
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.isSearching = false
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        tableView.reloadData()
    }
}


