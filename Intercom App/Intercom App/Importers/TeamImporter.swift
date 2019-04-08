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
    
    var teamMembers: User?
    var userID: Int?
    var teamBaseURL = URL(string: "https://intercom-be.herokuapp.com/api/users")!
    var userEmail = UserManager.shared.authUser?.email
    var userNikname = UserManager.shared.authUser?.nickname
    
    
    func getUser() {
        
        let usersBaseURL = URL(string: "https://intercom-be.herokuapp.com/api/users")!
        
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        guard let email = userEmail, let name = userNikname else { return }
        let parameters = ["nickname": name, "email": email]
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        
        var request = URLRequest(url: usersBaseURL)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    // handle json...
                    
                    
                        if let userID = json["id"] as? Int {
                            print(userID)
                        self.userID = userID
                        self.fetchTeam(userID: userID)
                    }
                    
                }
            } catch let error {
                print(error.localizedDescription)
            }
            
        })
        task.resume()
        
    }
    
    
    func fetchTeam(userID: Int) {
        
        teamBaseURL.appendPathComponent("\(userID)")
        var request = URLRequest(url: teamBaseURL)

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
                
                let decodedTeam = try jsonDecoder.decode(User.self, from: teamData)
                
                self.teamMembers = decodedTeam
                
                //Reload the table with current data
                DispatchQueue.main.async {
                    self.tlvc!.tableView.reloadData()
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
