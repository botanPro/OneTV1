//
//  AppDelegate.swift
//  OneTV
//
//  Created by Botan Amedi on 06/03/2025.
//

import UIKit
import RealmSwift
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseMessaging
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //UserDefaults.standard.setValue("false", forKey: "login")
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        if XLanguage.get() == .none {
            XLanguage.set(Language: .English)
            UserDefaults.standard.setValue("English", forKey: "lang")
            UserDefaults.standard.setValue(1, forKey: "Selectedlanguage")
        }
        
        
        
        FirebaseApp.configure()
        
        // Set up Firebase Messaging delegate
        Messaging.messaging().delegate = self
        
        // Set up UNUserNotificationCenter delegate
        UNUserNotificationCenter.current().delegate = self
        
        // Request notification permissions
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if granted {
                print("Notification permission granted.")
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            } else {
                print("Notification permission denied.")
            }
        }
        
        
        
        
        return true
    }
    
    
    // Handle successful APNS token registration
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let apnsToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("APNS Token: \(apnsToken)")
        
        // Pass the APNS token to Firebase Messaging
        Messaging.messaging().apnsToken = deviceToken
        
        // Now fetch the FCM token
        Messaging.messaging().token { token, error in
            if error != nil {
                //print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                UpdateOneSignalIdAPI.Update(UUID: token)
                // Send the FCM token to your server if needed
            }
        }
    }
    
    // Handle failure to register for remote notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }
    
    // Handle FCM token updates
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: NSNotification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
            
        )
        UpdateOneSignalIdAPI.Update(UUID: fcmToken ?? "")
        // Send the FCM token to your server if needed
    }
    
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

