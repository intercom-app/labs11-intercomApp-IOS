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
        //displayInformation()
    }
    
    var currentUser: Users?
    
    var userImage: UIImage?
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var fullnameLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var callStatusLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var creationDateLabel: UILabel!
    
    @IBOutlet weak var subscriptionLabel: UILabel!
    
    
    func displayInformation() {
    
        usernameLabel.text = currentUser?.displayName ?? "Add a Username"
        photoView.image = userImage
        fullnameLabel.text = "\(currentUser?.firstName) \(currentUser?.lastName)"
        //phoneLabel.text = currentUser?.phoneNumber as String
        if currentUser?.callStatus == true { callStatusLabel.text = "Call Status: On a Call" } else { callStatusLabel.text = "Call Status: Available" }
        emailLabel.text = currentUser?.email
        creationDateLabel.text = currentUser?.createdAt
        let subscription = String(describing: currentUser?.billingSubcription)
        subscriptionLabel.text = subscription
    }
    
    
    
}
