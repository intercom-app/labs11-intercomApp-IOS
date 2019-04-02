//
//  GroupeController.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 3/27/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class GroupController {
    
    static let shared = GroupController()
    
    
    var gtvc: GroupTableViewController?
    
    var groups: [Group] = []
    
    var groupBaseURL = URL(string: "https://intercom-be.herokuapp.com/api/groups")!
    
    func fetchGroups() {
        
        var request = URLRequest(url: groupBaseURL)
        
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            
            if let teamError = error {
                print("Error getting team members from API: \(teamError)")
                
                return
                
            } //End of error handling.
            
            guard let teamData = data else {
                if let JSONString = String(data: data!, encoding: String.Encoding.utf8) {
                    print(JSONString)
                }
                print("Data was not recieved.")
                
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                
                let decodedTeam = try jsonDecoder.decode([Group].self, from: teamData)
                
                self.groups = decodedTeam
                
                //Reload the table with current data
                DispatchQueue.main.async {
                    self.gtvc!.tableView.reloadData()
                }
                
                // Convert to a string and print
                if let JSONString = String(data: teamData, encoding: String.Encoding.utf8) {
                    print(JSONString)
                }
            }
            catch { //In case Decoding doesn't work.
                
                NSLog("Error: \(error.localizedDescription)")
                
                return
            }
            } .resume() //Resumes the fetch function if it's been suspended e.g. because of errors.
        
    } //End of fetch team function.
    
    
   
}
