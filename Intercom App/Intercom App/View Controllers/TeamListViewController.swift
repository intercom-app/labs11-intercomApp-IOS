//
//  TeamListViewController.swift
//  Intercom App
//
//  Created by Lotanna Igwe-Odunze on 3/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import Auth0

class TeamListViewController: UITableViewController {
    
     
       //Overrides
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        TeamImporter.shared.tlvc = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Pull the information in the background of the main thread
        DispatchQueue.global().async {
            TeamImporter.shared.getUser()

        }
    }
    
   //Tableview Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "teammateCell", for: indexPath)
        
        cell.textLabel?.text = TeamImporter.shared.teamMembers?.displayName
        cell.detailTextLabel?.text = TeamImporter.shared.teamMembers?.email
        return cell
    }
   
    
}
