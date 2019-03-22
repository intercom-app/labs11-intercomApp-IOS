//
//  TeamImporter.swift
//  Intercom App
//
//  Created by Lotanna Igwe-Odunze on 3/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class TeamImporter {
    
    static let shared = TeamImporter()
    
    var tlvc: TeamListViewController?
    
    var teamMembers: [User] = []
    
    var teamBaseURL = URL(string: "https://intercom-be.herokuapp.com/api/users")!
    
    func fetchTeam() {
        
        var request = URLRequest(url: teamBaseURL)

        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
    
            if let teamError = error {
                print("Error getting team members from API: \(teamError)")
                
            return
                
            } //End of error handling.
            
            guard let teamData = data else {
                
                print("Data was not recieved.")
                
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                
                let decodedTeam = try jsonDecoder.decode([User].self, from: teamData)
                
                self.teamMembers = decodedTeam
                
                //Reload the table with current data
                DispatchQueue.main.async { self.tlvc!.tableView.reloadData() }

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
