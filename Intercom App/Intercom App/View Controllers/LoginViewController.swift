//
//  LoginViewController.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 3/21/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//


//import FacebookCore
//import FacebookLogin
//import TwitterKit
import UIKit

class LoginViewController: UIViewController {

    let teamListViewController = TeamListViewController()
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    // Facebook login permissions
    // Add extra permissions you need
    // Remove permissions you don't need
    
   // private let readPermissions: [ReadPermission] = [ .publicProfile, .email, .userFriends, .custom("user_posts") ]

    @IBAction func didTapLoginButton(_ sender: LoginButton) {
        // Regular login attempt. Add the code to handle the login by email and password.
        guard let email = usernameTextField.text, let pass = passwordTextField.text else {
            // It should never get here
            return
        }
        didLogin(method: "email and password", info: "Email: \(email) \n Password: \(pass)")
    }

    @IBAction func didTapFacebookLoginButton(_ sender: FacebookLoginButton) {
        // Facebook login attempt
        
      //  let loginManager = LoginManager()
       // loginManager.logIn(readPermissions: readPermissions, viewController: self, completion: didReceiveFacebookLoginResult)
    }

    @IBAction func didTapTwitterLoginButton(_ sender: TwitterLoginButton) {
        // Twitter login attempt
        
//        TWTRTwitter.sharedInstance().logIn(completion: { session, error in
//            if let session = session {
//                // Successful log in with Twitter
//                print("signed in as \(session.userName)");
//                let info = "Username: \(session.userName) \n User ID: \(session.userID)"
//                self.didLogin(method: "Twitter", info: info)
//            } else {
//                print("error: \(error?.localizedDescription)");
//            }
//        })
    }
    
    @IBAction func didTapGoogleLoginButton(_ sender: GoogleLoginButton) {
//        GIDSignIn.sharedInstance().delegate = self
//        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().signIn()
     
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

//    private func didReceiveFacebookLoginResult(loginResult: LoginResult) {
//        switch loginResult {
//        case .success:
//            didLoginWithFacebook()
//        case .failed(_): break
//        default: break
//        }
//    }
//
//    private func didLoginWithFacebook() {
//        // Successful log in with Facebook
//        if let accessToken = AccessToken.current {
//            let facebookAPIManager = FacebookAPIManager(accessToken: accessToken)
//            facebookAPIManager.requestFacebookUser(completion: { (facebookUser) in
//                if let _ = facebookUser.email {
//                    let info = "First name: \(facebookUser.firstName!) \n Last name: \(facebookUser.lastName!) \n Email: \(facebookUser.email!)"
//                    self.didLogin(method: "Facebook", info: info)
//                }
//            })
//        }
//    }

    private func didLogin(method: String, info: String) {
        let message = "Successfully logged in with \(method). " + info
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: { (_) in
            print("User click Done button")
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TeamListViewController") as! TeamListViewController
            self.present(nextViewController, animated:true, completion:nil)
            }))
        self.present(alert, animated: true, completion: nil)
        
    }
//    //MARK:Google SignIn Delegate
//    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
//        // myActivityIndicator.stopAnimating()
//    }
//
//    // Present a view that prompts the user to sign in with Google
//    func sign(_ signIn: GIDSignIn!,
//              present viewController: UIViewController!) {
//        self.present(viewController, animated: true, completion: nil)
//    }
//
//    // Dismiss the "Sign in with Google" view
//    func sign(_ signIn: GIDSignIn!,
//              dismiss viewController: UIViewController!) {
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    //completed sign In
//    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//
//        if (error == nil) {
//            // Perform any operations on signed in user here.
//            let userId = user.userID                  // For client-side use only!
//            let idToken = user.authentication.idToken // Safe to send to the server
//            let fullName = user.profile.name
//            let givenName = user.profile.givenName
//            let familyName = user.profile.familyName
//            let email = user.profile.email
//            // ...
//        } else {
//            print("\(error.localizedDescription)")
//        }
//    }
    
}
