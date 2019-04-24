//
//  StripeTools.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 4/23/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import Stripe

struct StripeTools {
    
    //store stripe secret key
    private var stripeSecret = "mysecrettestkey"
    
    //generate token each time you need to get an api call
    func generateToken(card: STPCardParams, completion: @escaping (_ token: STPToken?) -> Void) {
        STPAPIClient.shared().createToken(withCard: card) { token, error in
            if let token = token {
                completion(token)
            }
            else {
                print(error as Any)
                completion(nil)
            }
        }
    }
    
    func getBasicAuth() -> String{
        return "Bearer \(self.stripeSecret)"
    }
    
}
