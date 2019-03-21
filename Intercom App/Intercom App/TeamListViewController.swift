//
//  TeamListViewController.swift
//  Intercom App
//
//  Created by Lotanna Igwe-Odunze on 3/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class TeamListViewController: UITableViewController {
    
    //Overrides
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        TeamImporter.shared.tlvc = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Pull the information in the background of the main thread
        DispatchQueue.main.async {
            TeamImporter.shared.fetchTeam()
        }
    }
    
   //Tableview Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return TeamImporter.shared.teamMembers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "teammateCell", for: indexPath)
        
        cell.textLabel?.text = TeamImporter.shared.teamMembers[indexPath.row].name
        
        return cell
    }
    
    
}
