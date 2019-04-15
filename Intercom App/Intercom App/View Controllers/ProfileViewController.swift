//
//  ProfileViewController.swift
//  Intercom App
//
//  Created by Lotanna Igwe-Odunze on 3/27/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        displayInformation()
    }
    
    var pulledUser: Users?
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var fullnameLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var callStatusLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var creationDateLabel: UILabel!
    
    @IBOutlet weak var subscriptionLabel: UILabel!
    
    
    func displayInformation() {
    
        usernameLabel.text = pulledUser?.displayName ?? "Add a Username"
        
        if let currentUser = pulledUser {
        
          //  photoView.image = UserManager.shared.buildUserPhoto(user: currentUser)
            
        }
        
        fullnameLabel.text = "\(pulledUser?.firstName) \(pulledUser?.lastName)"
        //phoneLabel.text = currentUser?.phoneNumber as String
        
        if pulledUser?.callStatus == true { callStatusLabel.text = "Call Status: On a Call" } else { callStatusLabel.text = "Call Status: Available" }
        
        emailLabel.text = pulledUser?.email
        
        creationDateLabel.text = pulledUser?.createdAt
        
        let subscription = String(describing: pulledUser?.billingSubcription)
        
        subscriptionLabel.text = subscription
    }
    
    
    
}
