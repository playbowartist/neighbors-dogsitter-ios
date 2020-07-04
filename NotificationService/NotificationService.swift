//
//  NotificationService.swift
//  NotificationService
//
//  Created by Raymond Yu on 7/3/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import UserNotifications
import FirebaseMessaging

class NotificationService: UNNotificationServiceExtension, MessagingDelegate {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
//        print("\ninside didReceive")
//        InstanceID.instanceID().instanceID { (result, error) in
//            print("inside InstanceID")
//            
//            if let error = error {
//                print("\nError fetching remote instance ID: \(error)")
//            } else {
//                print("\nRemote instance ID token: \(result)")
//            }
//        }
        
        Messaging.messaging().delegate = self
        
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            
            FIRMessagingExtensionHelper().populateNotificationContent(bestAttemptContent, withContentHandler: contentHandler)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Successfully registered for Firebase notifications!")
        print("FCM registration token:", fcmToken)

        let dataDict: [String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}
