//
//  UserManager.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 4/9/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class UserManager {
    
    static let shared = UserManager()
    
    var localUser: UserRep?
    
    
 
    
    struct UserRep: Codable {
        let id: Int
        let stripeID: String?
        let twilioSubSID: JSONNull?
        var firstName: String?
        var lastName: String?
        var photo: UIImage?
        var avatar: String?
        var displayName: String
        var email: String?
        var phoneNumber: Int?
        var billingSubcription: BillingSubcription
       
        enum CodingKeys: String, CodingKey {
            case id
            case stripeID = "stripeId"
            case twilioSubSID, firstName, lastName, avatar, displayName, email, phoneNumber, billingSubcription
        }
        enum BillingSubcription: String, Codable {
            case free = "free"
            case premium = "premium"
        }
    }

}
