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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var devToken: String?
    var environment: APNSEnvironment?
    let chatroom: ChatroomViewController? = nil
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NSLog("Twilio Voice Version: %@", TwilioVoice.version())
        self.configureUserNotifications()	
        STPPaymentConfiguration.shared().publishableKey = Constants.publishableKey
        chatroom?.registerDeviceToken()
        let settings = UIUserNotificationSettings(types: .alert, categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        UIApplication.shared.registerForRemoteNotifications()

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
        return true
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

    func configureUserNotifications() {
        let rejectAction = UIMutableUserNotificationAction()
        rejectAction.activationMode = .background
        rejectAction.title = "Reject"
        rejectAction.identifier = "reject"
        rejectAction.isDestructive = true
        rejectAction.isAuthenticationRequired = false
        
        let acceptAction = UIMutableUserNotificationAction()
        acceptAction.activationMode = .background
        acceptAction.title = "Accept"
        acceptAction.identifier = "accept"
        acceptAction.isDestructive = false
        acceptAction.isAuthenticationRequired = false
        
        let actionCategory = UIMutableUserNotificationCategory()
        actionCategory.identifier = "ACTIONABLE"
        actionCategory.setActions([rejectAction, acceptAction], for: .default)
        
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: [actionCategory])
        UIApplication.shared.registerUserNotificationSettings(settings)
    }

}

