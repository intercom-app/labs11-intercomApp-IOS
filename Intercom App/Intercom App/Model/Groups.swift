//
//  Groups.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 4/5/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

struct Groups: Codable {
    let membershipCreatedAt: String?
    let groupCreatedAt: String
    let groupID: Int
    let groupName: String
    let phoneNumber: JSONNull?
    let callStatus: Int
    let activities, callParticipants, owners, members: [Users]
    let invitees: [Users]
    let inviteCreatedAt, ownershipCreatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case membershipCreatedAt, groupCreatedAt
        case groupID = "groupId"
        case groupName, phoneNumber, callStatus, activities, callParticipants, owners, members, invitees, inviteCreatedAt, ownershipCreatedAt
    }
}
