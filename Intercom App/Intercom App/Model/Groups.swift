//
//  Groups.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 4/5/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct Groups: Codable {
    
    let membershipCreatedAt: String?
    let groupCreatedAt: String?
    let groupId: Int?
    let groupName: String?
    let phoneNumber: Int?
    let callStatus: Int
    let activities, callParticipants, owners, members: [Users]?
    let invitees: [Users]?
    let inviteCreatedAt, ownershipCreatedAt: String?
}
