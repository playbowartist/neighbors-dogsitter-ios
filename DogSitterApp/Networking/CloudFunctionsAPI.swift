//
//  CloudFunctionsAPI.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 12/2/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import Foundation
import FirebaseFunctions

class CloudFunctionsAPI {
    
    static func sendNotification(fcmToken: String, title: String?, body: String?, imageUrlString: String?, androidChannel: String?) {
        print("fcmToken in sendNotification:\n", fcmToken)
        let testToken = "eO7P9aVXKEElrK-_WMogI-:APA91bE0XPWZTxeI_gp2zmVMWo0Z4vG89TS77r4aO_G1RjdRHSnJ9vQTg2lVSrbQ7uyq7PZK7vlazd6Ej5-de9lI53LuuJEW8HbwaTSqe2ofTwSpmJGuSwobEnh5Hm-gDEBeCTMYhC0e"
        
        var data: [String: Any] = [
            "fcmToken": fcmToken
        ]
        
        if let title = title {
            data["title"] = title
        }
        if let body = body {
            data["body"] = body
        }
        if let imageUrlString = imageUrlString {
            data["imageUrlString"] = imageUrlString
        }
        if let androidChannel = androidChannel {
            data["androidChannel"] = androidChannel
        }
        
        let functions = Functions.functions()
        functions.httpsCallable("sendNotification").call(data) { (result, error) in

            if let error = error {
                print("sendNotification error: \(error)")
            }
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
                    let code = FunctionsErrorCode(rawValue: error.code)
                    let message = error.localizedDescription
                    let details = error.userInfo[FunctionsErrorDetailsKey]
                    print("Function error inside sendNotification:", code ?? "", message, details ?? "")
                }
                return
            }
        }
    }
}
