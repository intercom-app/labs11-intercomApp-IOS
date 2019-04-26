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
    
    
    var cavc: ChatroomActivityTableViewController?
    var gtvc: GroupListViewController?
    var iuvc: InviteUserTableViewController?
    var ulvc: UserListTableViewController?
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
    
    func deleteGroupRequest(groupID: Int) {
        
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
            //Reload the table with current data
            DispatchQueue.main.async {
                self.gtvc?.tableView.reloadData()
                self.iuvc?.tableView.reloadData()
                self.cavc?.tableView.reloadData()
                self.ulvc?.tableView.reloadData()
                
            }
        })
        task.resume()
    }
    
    func postCallParticipants(groupID: Int) {
        guard let id = TeamImporter.shared.userID else {
            fatalError("cant fetch user ID: \(String(describing: TeamImporter.shared.userID))")
        }
        let parameters = ["userId" : id] as [String : Any]
        
        var groupsURL = URL(string: "https://intercom-be.herokuapp.com/api/groups")!
        groupsURL.appendPathComponent("\(groupID)")
        groupsURL.appendPathComponent("callParticipants")
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
            //Reload the table with current data
            DispatchQueue.main.async {
                self.gtvc?.tableView.reloadData()
                self.iuvc?.tableView.reloadData()
                self.cavc?.tableView.reloadData()
                self.ulvc?.tableView.reloadData()
                
            }
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
            //Reload the table with current data
            DispatchQueue.main.async {
                self.gtvc?.tableView.reloadData()
                self.iuvc?.tableView.reloadData()
                self.cavc?.tableView.reloadData()
                self.ulvc?.tableView.reloadData()
            }
            
            TeamImporter.shared.getUserAndFetchAllDetails()
        })
        task.resume()
    }
    
    func deleteCallParticipants(groupID: Int, completion: @escaping (Bool) -> Void = { _ in }) {
        guard let id = TeamImporter.shared.userID else {
            fatalError("cant fetch user ID: \(String(describing: TeamImporter.shared.userID))")
        }
        
        var groupsURL = URL(string: "https://intercom-be.herokuapp.com/api/groups")!
        groupsURL.appendPathComponent("\(groupID)")
        groupsURL.appendPathComponent("callParticipants")
        groupsURL.appendPathComponent("\(id)")
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: groupsURL)
        request.httpMethod = "DELETE" //set http method as DELETE
        
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
            if let JSONString = String(data: data, encoding: String.Encoding.utf8) {
                print(JSONString)
                if JSONString.count < 3 {
                    completion(true)
                } else {
                    completion(false)
                }
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
    
    func changeCallStatus(groupID: Int?, callStatus: Bool) {
        guard let userID = TeamImporter.shared.userID else {
            fatalError("cant fetch user ID")
        }
        let parameters = ["callStatus" : callStatus]
        
        //create the session object
        let session = URLSession.shared
        var url: URL?
        //now create the URLRequest object using the url object
        if let groupID = groupID {
            url = URL(string: "https://intercom-be.herokuapp.com/api/groups")?.appendingPathComponent("\(groupID)")
            
        } else {
            url = URL(string: "https://intercom-be.herokuapp.com/api/users/")?.appendingPathComponent("\(userID)")
        }
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT" //set http method as PUT
        
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
    
    func deleteGroupMamber(groupID: Int, userID: Int?, completion: @escaping (Bool) -> Void = { _ in }) {
        guard let id = userID else {
            fatalError("cant fetch user ID")
        }
        
        var groupsURL = URL(string: "https://intercom-be.herokuapp.com/api/groups")!
        groupsURL.appendPathComponent("\(groupID)")
        groupsURL.appendPathComponent("groupMembers")
        groupsURL.appendPathComponent("\(id)")
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: groupsURL)
        request.httpMethod = "DELETE" //set http method as DELETE
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            completion(true)
            DispatchQueue.main.async {
                
                self.ulvc?.tableView.reloadData()
            }
        })
        task.resume()
    }
    
    func deleteInvitation(groupID: Int, userID: Int?) {
        guard let id = userID else {
            fatalError("cant fetch user ID")
        }
        
        var groupsURL = URL(string: "https://intercom-be.herokuapp.com/api/groups")!
        groupsURL.appendPathComponent("\(groupID)")
        groupsURL.appendPathComponent("groupInvitees")
        groupsURL.appendPathComponent("\(id)")
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: groupsURL)
        request.httpMethod = "DELETE" //set http method as DELETE
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            //Reload the table with current data
            
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
    
    func fetchGroupMembers(gropeId: Int, completion: @escaping ([AllUsers]) -> Void = { _ in }) {
        var teamURL = URL(string: "https://intercom-be.herokuapp.com/api/groups")!
        teamURL.appendPathComponent("\(gropeId)")
        teamURL.appendPathComponent("groupMembers/detailed")
        var request = URLRequest(url: teamURL)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            if let response = urlResponse {
                print(response)
            }
            if let teamError = error {
                print("Error getting team members from API: \(teamError)")
                
                return
                
            } //End of error handling.
            
            guard let teamData = data else {
                
                print("Data was not recieved.")
                
                return
            }
            if let JSONString = String(data: data!, encoding: String.Encoding.utf8) {
                print(JSONString)
            }
            do {
                //create json object from data
                let jsonDecoder = JSONDecoder()
                
                let decodedTeam = try jsonDecoder.decode([AllUsers].self, from: teamData)
                
                        completion(decodedTeam)
                    
                
            } catch let error {
                print(error.localizedDescription)
            }
           // print(json)
            } .resume() //Resumes the fetch function if it's been suspended e.g. because of errors.
    }
    
    func fetchGroupActiity(gropeId: Int, completion: @escaping ([Activity]) -> Void = { _ in }) {
        var teamURL = URL(string: "https://intercom-be.herokuapp.com/api/groups")!
        teamURL.appendPathComponent("\(gropeId)")
        teamURL.appendPathComponent("activities")
        var request = URLRequest(url: teamURL)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            if let response = urlResponse {
                print(response)
            }
            if let teamError = error {
                print("Error getting team members from API: \(teamError)")
                
                return
                
            } //End of error handling.
            
            guard let teamData = data else {
                
                print("Data was not recieved.")
                
                return
            }
            if let JSONString = String(data: data!, encoding: String.Encoding.utf8) {
                print(JSONString)
            }
            do {
                //create json object from data
                let jsonDecoder = JSONDecoder()
                
                let decodedTeam = try jsonDecoder.decode([Activity].self, from: teamData)
                
                completion(decodedTeam)
                
                
            } catch let error {
                print(error.localizedDescription)
            }
            // print(json)
            } .resume() //Resumes the fetch function if it's been suspended e.g. because of errors.
    }
    
}
