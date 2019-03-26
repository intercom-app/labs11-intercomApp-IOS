//
//  LoginViewController.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 3/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//



import UIKit

class LoginViewController: UIViewController {

    let teamListViewController = TeamListViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    
    @IBAction func didTapLoginButton(_ sender: LoginButton) {
  
        // need connection to Auth0
       
        didLogin()
    }

    private func didLogin() {
        let message = "Successfully logged"
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: { (_) in
            print("User click Done button")
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TeamListViewController") as! TeamListViewController
            self.present(nextViewController, animated:true, completion:nil)
            }))
        self.present(alert, animated: true, completion: nil)
        
    }
}
