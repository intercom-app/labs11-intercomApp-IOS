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
    
    
    var gtvc: GroupListViewController?
    var groups: [Group] = []
    var groupBaseURL = URL(string: "https://intercom-be.herokuapp.com/api/groups")!
    var id = TeamImporter.shared.teamMembers?.id
    
    
    
    
    func fetchGroups() {
        var usersBaseURL = URL(string: "https://intercom-be.herokuapp.com/api/users")!
        guard let userID = id else { return }
        usersBaseURL.appendPathComponent("\(userID)")
        usersBaseURL.appendPathComponent("groupsBelongedTo")
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
    
    
    func postRequest(groupName: String) {
        
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        
        let parameters = ["name": groupName]
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: groupBaseURL)
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
            self.fetchGroups()
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    // handle json...
                  
                }
            } catch let error {
                print(error.localizedDescription)
            }
           
        })
        task.resume()
    }
    
    func deleteRequest(groupID: Int) {
        
        //create the session object
        let session = URLSession.shared
        let url = groupBaseURL.appendingPathComponent("\(groupID)")
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        
        request.httpMethod = "DELETE" //set http method as POST
        
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
            self.fetchGroups()
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    // handle json...
                    
                }
            } catch let error {
                print(error.localizedDescription)
            }
            
        })
        task.resume()
    }
    
    
    func putRequest(groupID: Int, groupName: String) {
        
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        
        let parameters = ["name": groupName] as [String : Any]
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: URL(string: "https://intercom-be.herokuapp.com/api/groups/" + "\(groupID)")!)
        request.httpMethod = "PUT" //set http method as POST
        
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
            self.fetchGroups()
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    // handle json...
                    
                }
            } catch let error {
                print(error.localizedDescription)
            }
            
        })
        task.resume()
    }

}
