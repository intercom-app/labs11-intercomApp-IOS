//
//  User.swift
//  Intercom App
//
//  Created by Lotanna Igwe-Odunze on 3/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct User: Codable {
    
    var id: Int
    var firstName: String
    var lastName: String?
    var displayName: String
    var email: String
    var phoneNumber: Int
    var callStatus: Int
    var billingSubcription: String
}
