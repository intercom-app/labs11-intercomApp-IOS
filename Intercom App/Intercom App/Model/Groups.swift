//
//  Groups.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 4/5/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

struct Groups: Codable {
    var membershipCreatedAt: String?
    var groupCreatedAt: String
    var groupID: Int
    var groupName: String
   // var phoneNumber: JSONNull?
    var callStatus: Bool
    var activities, callParticipants, owners, members: [Users]
    var invitees: [Users]
    var inviteCreatedAt, ownershipCreatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case membershipCreatedAt, groupCreatedAt
        case groupID = "groupId"
        case groupName, callStatus, activities, callParticipants, owners, members, invitees, inviteCreatedAt, ownershipCreatedAt
    }
}
