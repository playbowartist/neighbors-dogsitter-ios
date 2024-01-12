//
//  AppDelegate.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/1/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import UIKit
import BackgroundTasks
import Firebase
import FirebaseAuthUI
//import FirebaseInstanceID
import FirebaseMessaging
import FirebaseInstallations

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    static var orientationLock = UIInterfaceOrientationMask.portrait
    var appState: AppState = AppState()
    
    func scheduleBackgroundFetch() {
        let request = BGAppRefreshTaskRequest(identifier: "com.playbowdogs.backgroundFetch")
        // Fetch no earlier than 1 minutes from now
        request.earliestBeginDate = Date(timeIntervalSinceNow: 1 * 10)
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule background fetch: \(error)")
        }
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
        
        // Create an operation that performs the main part of the background task
        let operation = FirestoreManager()
        
        // Provide an expiration handler for the background task
        // that cancels the operation
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
            //         Do Nothing for now
            //         operation.cancel()
//            PokeManager.urlSession.invalidateAndCancel()
        }
        
        operation.testPrint()
                
        task.setTaskCompleted(success: true)
        
        
        // Inform the system that the background task is complete
          // when the operation completes
//          operation.completionBlock = {
//             task.setTaskCompleted(success: !operation.isCancelled)
//          }

          // Start the operation
//          operationQueue.addOperation(operation)
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("D'oh, did not receive authorization from user for notifications: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
        
        // Setup to register background task
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.playbowdogs.backgroundFetch", using: nil) { task in
            if let task = task as? BGAppRefreshTask {
                self.handleAppRefresh(task: task)
            }
        }
        
//        // Schedule a new refresh task
//        self.scheduleBackgroundFetch()
        
        return true
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
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        print("\nApple device token for dev notifications:", deviceTokenString)
        
//        InstanceID.instanceID().instanceID { (result, error) in
//            if let error = error {
//                print("\nError fetching remote instance ID and fcmToken: \(error)\n")
//            } else if let result = result {
//                print("FCM registration token: \(result.token)\n")
//            }
//        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for Apple push notifications: \(error.localizedDescription)")
    }

//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
//        print("Successfully registered for Firebase notifications!")
//        print("FCM registration token:", fcmToken)
//
//        let dataDict: [String: String] = ["token": fcmToken]
//        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
//        // TODO: If necessary send token to application server.
//        // Note: This callback is fired at each app startup and whenever a new token is generated.
//    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)

        // Print message ID.
//        let gcmMessageIDKey = "gcm.message_id"
//        if let messageID = userInfo[gcmMessageIDKey] {
//          print("Message ID: \(messageID)")
//        }

        // Print full message.
        print("\nNotification userInfo:\n", userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
    
    // This function will be called when the app receives a notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    // This function will be called right after user taps on the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("\ninside userNotifCenter inside AppDelegate and setting tabSelection to .liveVideoView\n")
        self.appState.tabSelection = .liveVideoView
        
        let application = UIApplication.shared
        
        if(application.applicationState == .active){
            print("user tapped the notification bar when the app is in foreground")
            
        }
        
        if(application.applicationState == .inactive)
        {
            print("user tapped the notification bar when the app is in background")
        }
        
        completionHandler()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("\nFCM registration token inside AppDelegate messaging():\n\(fcmToken)")

        guard let fcmToken = fcmToken else {
            print("Did not receive FCM registration token")
            return
        }
        
        let dataDict: [String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server/database.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}

