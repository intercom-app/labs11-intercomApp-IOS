//
//  Group.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 3/22/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct Group: Codable, Equatable {
    
    var name: String
    var id: Int
    var phoneNumber: String?
    var callStatus: Int
    var createdAt: String

}
