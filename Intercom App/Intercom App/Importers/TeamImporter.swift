//
//  TeamImporter.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 3/27/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import Stripe

class TeamImporter {
    
    static let shared = TeamImporter()
    
    var givc: GroupInvitesTableViewController?
    var cavc: ChatroomActivityTableViewController?
    var gtvc: GroupListViewController?
    var iuvc: InviteUserTableViewController?
    var ulvc: UserListTableViewController?
    var bvc: BillingViewController?
    var teamMembers: Users?
    var userID: Int?
    var teamBaseURL = URL(string: "https://intercom-be.herokuapp.com/api/users")!
    var userEmail = userProfile.email
    var userNikname = userProfile.nickname
    var allGroups: [[Groups]]?
    
    func getUserAndFetchAllDetails(completion: @escaping ([Users]) -> Void = { _ in }) {
        
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
                        self.fetchCurentUserDetails(userID: userID) // need to change
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        
    }
    
    func makePaymentSendAmount(amount: String?, completion: @escaping (Double) -> Void = { _ in }) {
        
        let baseURL = URL(string: "https://intercom-be.herokuapp.com/api/billing")!.appendingPathComponent("addMoney")
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        guard let userid = userID, let amount = amount else { return }
        let parameters = ["userId": "\(userid)", "amountToAdd": amount] as [String : Any]
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
//        create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            print(response ?? "no responce")
            
            guard let data = data else {
                return
            }
            if let JSONString = String(data: data, encoding: String.Encoding.utf8) {
                print(JSONString)
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    // handle json...
                    
                    
                    if let updatedAccountBalance = json["updatedAccountBalance"] as? Double {
                    completion(updatedAccountBalance)
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        
    }
    
    
    func addCardChangeCard(source: String?) {
        
        let baseURL = URL(string: "https://intercom-be.herokuapp.com/api/billing")!.appendingPathComponent("updateCreditCard")
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        guard let userid = userID, let source = source else { return }
        let parameters = ["userId": userid, "sourceId": source] as [String : Any]
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST" //set http method as POST
        print("test3")
        do {
             print("test1")
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            print("test")
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //        create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            print(response ?? "no responce")
            guard let data = data else {
                return
            }
            if let JSONString = String(data: data, encoding: String.Encoding.utf8) {
                print(JSONString)
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    // handle json...
                   
                    DispatchQueue.main.async {
                        self.bvc?.viewDidLoad()
                    }
                    
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        
    }
    
    func fetchCurentUserDetails(userID: Int) {
        var teamURL = URL(string: "https://intercom-be.herokuapp.com/api/users")!
        teamURL.appendPathComponent("\(userID)")
        teamURL.appendPathComponent("detailed")
        var request = URLRequest(url: teamURL)
        
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
                let jsonDecoder = JSONDecoder()
//                if let JSONString = String(data: teamData, encoding: String.Encoding.utf8) {
//                    print(JSONString)
//                }
                let decodedTeam = try jsonDecoder.decode(Users.self, from: teamData)
                
                self.teamMembers = decodedTeam
                
                self.allGroups = ([self.teamMembers!.groupsOwned!, self.teamMembers!.groupsBelongedTo!, self.teamMembers!.groupsInvitedTo] as? [[Groups]])
                
                //Reload the table with current data
                DispatchQueue.main.async {
                    self.gtvc?.tableView.reloadData()
                    self.iuvc?.tableView.reloadData()
                    self.cavc?.tableView.reloadData()
                    self.ulvc?.tableView.reloadData()
                    self.givc?.tableView.reloadData()
                    
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
    
    func fetchAllUsers(completion: @escaping ([AllUsers]?) -> Void = { _ in }) {
        let usersURL = URL(string: "https://intercom-be.herokuapp.com/api/users")!
        
        var request = URLRequest(url: usersURL)
        
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
                let jsonDecoder = JSONDecoder()
                
                let decodedTeam = try jsonDecoder.decode([AllUsers].self, from: teamData)
                
                
                completion(decodedTeam)
                //Reload the table with current data
                DispatchQueue.main.async {
                    self.iuvc?.tableView.reloadData()
                }
                
//                // Convert to a string and print
//                if let JSONString = String(data: teamData, encoding: String.Encoding.utf8) {
//                    print(JSONString)
//                }
            }
            catch { //In case Decoding doesn't work.
                
                NSLog("Error: \(error.localizedDescription)")
                
                return
            }
            
            } .resume() //Resumes the fetch function if it's been suspended e.g. because of errors.
        
    } //End of fetch team function.
    
    func putCardLast4(last4: String?, completion: @escaping (Users) -> Void = { _ in }) {
        
        var usersBaseURL = URL(string: "https://intercom-be.herokuapp.com/api/users")!
        
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        guard let last4 = last4, let id = userID else { return }
        let parameters = ["last4": last4]
        
        usersBaseURL.appendPathComponent("\(id)")
        usersBaseURL.appendPathComponent("last4")
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        
        var request = URLRequest(url: usersBaseURL)
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
            
            if let JSONString = String(data: data, encoding: String.Encoding.utf8) {
                print(JSONString)
            }
            
           
        })
        task.resume()
        
    }
    
    func fetchLast4(completion: @escaping (String?) -> Void = { _ in }) {
        var usersURL = URL(string: "https://intercom-be.herokuapp.com/api/users")!
        guard let id = userID else { return }
        usersURL.appendPathComponent("\(id)")
        usersURL.appendPathComponent("last4")
        var request = URLRequest(url: usersURL)
        
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
            
            // Convert to a string and print
            if let JSONString = String(data: teamData, encoding: String.Encoding.utf8) {
                print(JSONString)
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                
                let cardLast4 = try jsonDecoder.decode([String: String?].self, from: teamData)
                
                if let last4 = cardLast4["last4"] {
                   
                completion(last4)
                }
            }
            catch { //In case Decoding doesn't work.
                
                NSLog("Error: \(error.localizedDescription)")
                
                return
            }
            
            } .resume() //Resumes the fetch function if it's been suspended e.g. because of errors.
        
    } //End of fetch team function.
    
    func editUserDisplayName(userDispayName: String) {
        
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        
        let parameters = ["displayName": userDispayName] as [String : Any]
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        guard let id = userID else { return }
        var request = URLRequest(url: URL(string: "https://intercom-be.herokuapp.com/api/users/" + "\(id)")!)
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
}
