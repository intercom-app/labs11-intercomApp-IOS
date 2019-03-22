//
//  Group.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 3/22/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct Group: Codable, Equatable {
    
    var groupName: String
    var groupID: Int
    var groupToken: String?
    var userID: Int
    var userCount: Int
    var createdDate: String

}
