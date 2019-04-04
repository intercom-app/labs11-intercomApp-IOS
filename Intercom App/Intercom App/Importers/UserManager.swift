//
//  UserManager.swift
//  Intercom App
//
//  Created by Lotanna Igwe-Odunze on 4/3/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import Auth0

class UserManager {
    
    static let shared = UserManager()
    
    var authUser: UserInfo? { didSet { setUser() } }
    
    var user: User?
    
    func setUser() {
        
        //user?.id = Auth ID
        user?.displayName = (authUser?.preferredUsername)!
        user?.firstName = authUser?.givenName
        user?.lastName = authUser?.familyName
        user?.phoneNumber = Int((authUser?.phoneNumber)!)
        user?.email = (authUser?.email)!
        //user?.callStatus = Twilio info here
        //user?.billingSubcription = Stripe Info here
    }
    
}
