//
//  LoginViewController.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 3/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//



import UIKit
import Auth0



class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func didTapLoginButton(_ sender: LoginButton) {
        showLogin()
    }
    
    func showLogin() {
        Auth0
            .webAuth()
            .audience("https://voicechatroom.auth0.com/api/v2/")
            .scope("openid profile email")
            .start {
                switch $0 {
                case .failure(let error):
                    print("Error showing login: \(error)")
                case .success(let credentials):
                    guard let accessToken = credentials.accessToken, let idToken = credentials.idToken else { return }
                    SessionManager.tokens = Tokens(accessToken: accessToken, idToken: idToken)
                    SessionManager.retrieveProfile({ (user, error) in
                     
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "GroupNavController") as! UINavigationController
                    self.present(nextViewController, animated:true, completion:nil)
                    }
                        })
                }
        }
    }
}
