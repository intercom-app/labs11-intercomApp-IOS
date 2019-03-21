//
//  TeamImporter.swift
//  Intercom App
//
//  Created by Lotanna Igwe-Odunze on 3/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class TeamImporter {
    
    static var teamMembers: [User] = []
    
    var teamBaseURL = URL(string: "https://intercom-be.herokuapp.com/api/team")!
    
    
    
    func fetchTeam(completion: @escaping (Error?) -> Void) {
        
        var request = URLRequest(url: teamBaseURL)

        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
    
            if let teamError = error {
                print("Error getting team members from API: \(teamError)")
                
            completion(error)
                
            return
                
            } //End of error handling.
            
            guard let teamData = data else {
                
                print("Data was not recieved.")
                
                completion(error) //Implement the error message if we fail to get data.
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                
                let decodedTeam = try jsonDecoder.decode([User].self, from: teamData)
                
                print(teamData)
                print(decodedTeam)
                
                TeamImporter.teamMembers = decodedTeam
                
                completion(nil)
            }
            catch { //In case Decoding doesn't work.
                
                NSLog("Error: \(error.localizedDescription)")
                
                completion(error) //Show error message in Debugger log.
                return
            }
        } .resume() //Resumes the fetch function if it's been suspended e.g. because of errors.
        
    } //End of fetch team function.
}
