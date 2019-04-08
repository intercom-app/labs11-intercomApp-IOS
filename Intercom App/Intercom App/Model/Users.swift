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
    let stripeID: JSONNull?
    let firstName, lastName: String?
    let displayName, email: String
    let phoneNumber: Int?
    let callStatus: Int
    let billingSubcription: BillingSubcription
    let createdAt: String
    let groupsOwned, groupsBelongedTo, groupsInvitedTo: [Groups]?
    let activityID: Int?
    let activityCreatedAt: String?
    let activity: String?
    let inviteeCreatedAt, memberCreatedAt, ownerCreatedAt, participantCreatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case stripeID = "stripeId"
        case firstName, lastName, displayName, email, phoneNumber, callStatus, billingSubcription, createdAt, groupsOwned, groupsBelongedTo, groupsInvitedTo
        case activityID = "activityId"
        case activityCreatedAt, activity, inviteeCreatedAt, memberCreatedAt, ownerCreatedAt, participantCreatedAt
    }
}

enum CreatedAtEnum: String, Codable {
    case the20190404014425 = "2019-04-04 01:44:25"
}

enum CreatedAt: String, Codable {
    case the20190404014426 = "2019-04-04 01:44:26"
}

enum BillingSubcription: String, Codable {
    case free = "free"
    case premium = "premium"
}

// MARK: Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
