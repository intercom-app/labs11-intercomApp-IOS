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
    var groups: [Groups] = []
    var groupBaseURL = URL(string: "https://intercom-be.herokuapp.com/api/groups")!
    var id = TeamImporter.shared.userID
    var groupID: Int?
    var names: [String] = []
   
    func createNewGroup(groupName: String) {
        
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
            TeamImporter.shared.getUserAndFetchAllDetails()
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    
                    if let groupID = json["id"] as? Int {
                        print(groupID)
                        self.groupID = groupID
                        self.addGroupOwner(groupID: groupID)
                        
                    }
                    
                }
            } catch let error {
                print(error.localizedDescription)
            }
           
        })
        task.resume()
    }
    
    func addGroupOwner(groupID: Int) {
        guard let id = TeamImporter.shared.userID else {
            fatalError("cant fetch user ID: \(String(describing: TeamImporter.shared.userID))")
        }
        let parameters = ["userId" : id]
        
        var groupsURL = URL(string: "https://intercom-be.herokuapp.com/api/groups")!
        groupsURL.appendPathComponent("\(groupID)")
        groupsURL.appendPathComponent("groupOwners")
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: groupsURL)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
//
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            TeamImporter.shared.getUserAndFetchAllDetails()
        })
        task.resume()
    }
    
    func addGroupMember(groupID: Int) {
        guard let id = TeamImporter.shared.userID else {
            fatalError("cant fetch user ID: \(String(describing: TeamImporter.shared.userID))")
        }
        let parameters = ["userId" : id]
        
        var groupsURL = URL(string: "https://intercom-be.herokuapp.com/api/groups")!
        groupsURL.appendPathComponent("\(groupID)")
        groupsURL.appendPathComponent("groupMembers")
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: groupsURL)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            //TeamImporter.shared.getUser()
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
            TeamImporter.shared.getUserAndFetchAllDetails()
            
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
    
    func postActivity(groupID: Int, massage: String) {
        guard let id = TeamImporter.shared.userID else {
            fatalError("cant fetch user ID: \(String(describing: TeamImporter.shared.userID))")
        }
        let parameters = ["userId" : id, "activity" : massage] as [String : Any]
        
        var groupsURL = URL(string: "https://intercom-be.herokuapp.com/api/groups")!
        groupsURL.appendPathComponent("\(groupID)")
        groupsURL.appendPathComponent("activities")
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: groupsURL)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            guard error == nil else {
                return
            }
            //TeamImporter.shared.getUser()
        })
        task.resume()
    }
    
    func postInvitation(groupID: Int, userID: Int?) {
        guard let id = userID else {
            fatalError("cant fetch user ID")
        }
        let parameters = ["userId" : id]
        
        var groupsURL = URL(string: "https://intercom-be.herokuapp.com/api/groups")!
        groupsURL.appendPathComponent("\(groupID)")
        groupsURL.appendPathComponent("groupInvitees")
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: groupsURL)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            //TeamImporter.shared.getUser()
        })
        task.resume()
    }
    
    
    func deleteFromeInvitations(groupID: Int) {
        guard let id = TeamImporter.shared.userID else {
            fatalError("cant fetch user ID: \(String(describing: TeamImporter.shared.userID))")
        }
        //let parameters = ["userId" : id, "activity" : massage] as [String : Any]
        
        var groupsURL = URL(string: "https://intercom-be.herokuapp.com/api/groups")!
        groupsURL.appendPathComponent("\(groupID)")
        groupsURL.appendPathComponent("groupInvitees")
        groupsURL.appendPathComponent("\(id)")
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: groupsURL)
        
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
            TeamImporter.shared.getUserAndFetchAllDetails()
            
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
    
    
    func editGroupName(groupID: Int, groupName: String) {
        
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
            
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    // handle json...
                    TeamImporter.shared.getUserAndFetchAllDetails()
                   
                }
            } catch let error {
                print(error.localizedDescription)
            }
            
        })
        task.resume()
    }

}
