//
//  AppDelegate.swift
//  Intercom App
//
//  Created by Lotanna Igwe-Odunze on 3/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import TwilioVoice
import UserNotifications
import Stripe
import Auth0

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var devToken: String?
    var environment: APNSEnvironment?
    let chatroom: ChatroomViewController? = nil
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NSLog("Twilio Voice Version: %@", TwilioVoice.version())
      
        STPPaymentConfiguration.shared().publishableKey = Constants.publishableKey
        chatroom?.registerDeviceToken()

        // Override point for customization after application launch.
        if #available(iOS 10, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (granted, error) in
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            })
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }

        self.environment = ProvisioningProfileInspector().apnsEnvironment()
        var envString = "Unknown"
        if environment != APNSEnvironment.unknown {
            if environment == APNSEnvironment.development {
                envString = "Development"
            } else {
                envString = "Production"
            }
        }
        print("APNS Environment detected as: \(envString) ");
        
//        window = UIWindow()
//        window?.makeKeyAndVisible()
//
//        let loginVC = LoginViewController.instantiate()
//        let mainVC = MainViewController.instantiate()
//
//        self.window?.rootViewController = SessionManager.tokens == nil ? loginVC : mainVC
//
        return true
    }
    
    //Auth0 requires this function in AppDelegate
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return Auth0.resumeAuth(url, options: options)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""
        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        print("Received token data! \(tokenString)")
        devToken = tokenString
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Couldn't register: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print("Message received.")
        if let aps = userInfo[AnyHashable("aps")] as? [AnyHashable: Any] {
            if let alert = aps[AnyHashable("alert")] as? String {
                let alertController = UIAlertController(title: "Incoming Notification", message: alert, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
            }
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
    }


}

