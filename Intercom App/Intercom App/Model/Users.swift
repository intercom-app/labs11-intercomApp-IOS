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
    let stripeID: String?
    let twilioSubSID, firstName, lastName: JSONNull?
    let avatar: String?
    let displayName: String
    let email: String?
    let phoneNumber: JSONNull?
    let callStatus: Bool
    let billingSubcription: BillingSubcription
    let createdAt: String
    let groupsOwned, groupsBelongedTo: [Groups]?
    let groupsInvitedTo: [Groups]?
    let activityID: Int?
    let activityCreatedAt: String?
    let activity: String?
    let inviteeCreatedAt, memberCreatedAt, ownerCreatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case stripeID = "stripeId"
        case twilioSubSID, firstName, lastName, avatar, displayName, email, phoneNumber, callStatus, billingSubcription, createdAt, groupsOwned, groupsBelongedTo, groupsInvitedTo
        case activityID = "activityId"
        case activityCreatedAt, activity, inviteeCreatedAt, memberCreatedAt, ownerCreatedAt
    }
    enum BillingSubcription: String, Codable {
        case free = "free"
        case premium = "premium"
    }
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

class JSONCodingKey: CodingKey {
    let key: String
    
    required init?(intValue: Int) {
        return nil
    }
    
    required init?(stringValue: String) {
        key = stringValue
    }
    
    var intValue: Int? {
        return nil
    }
    
    var stringValue: String {
        return key
    }
}



