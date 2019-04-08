//
//  Users.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 4/5/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct Users: Codable {
    let id: Int
    let stripeId: String?
    let firstName, lastName, displayName: String?
    let email: String
    let phoneNumber: String?
    let callStatus: Int
    let billingSubcription: BillingSubcription
    let createdAt: String
    let groupsOwned, groupsBelongedTo, groupsInvitedTo: [Groups]?
    let activityId: Int?
    let activityCreatedAt: String?
    let activity: String?
    let memberCreatedAt, ownerCreatedAt, participantCreatedAt, inviteeCreatedAt: String?
}

enum BillingSubcription: String, Codable {
    case free = "free"
    case premium = "premium"
}
