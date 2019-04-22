//
//  ProfileViewController.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 4/11/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userNewNameTextFieldOutlet: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameLabel.text = TeamImporter.shared.teamMembers?.displayName
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        guard let userName = userNewNameTextFieldOutlet.text else { return }
        if !userName.isEmpty {
            TeamImporter.shared.editUserDisplayName(userDispayName: userName)
            userNameLabel.text = userName
        }
        userNewNameTextFieldOutlet.text = nil
        TeamImporter.shared.getUserAndFetchAllDetails()
    }
    
    
}
