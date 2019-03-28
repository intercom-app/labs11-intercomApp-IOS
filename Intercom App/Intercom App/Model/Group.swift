//
//  Group.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 3/22/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class Group: Codable {
    
    
    
    var name: String
    var id: Int?
    var phoneNumber: String?
    var callStatus: Int?
    var createdAt: String?
    
    init(name: String, id: Int?, phoneNumber: String?, callStatus: Int?, cratedAt: String?) {
        self.name = name
        self.id = id
        self.phoneNumber = phoneNumber
        self.callStatus = callStatus
        self.createdAt = cratedAt
    }
    
}
