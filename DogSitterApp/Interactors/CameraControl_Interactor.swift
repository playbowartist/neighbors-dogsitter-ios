//
//  CameraControl_Interactor.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/18/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import Foundation
import FirebaseFunctions
import FirebaseFirestore

class CameraControl_Interactor {
    
    let cameraControlVM: CameraControlViewModel
    
    init(cameraControlVM: CameraControlViewModel) {
        self.cameraControlVM = cameraControlVM
    }
    
    func startRecording(networkingAPI: [NetworkingAPIProtocol]?, completionHandler: (() -> Void)?) {
        
        // Determine whether networkingAPI is passed as a parameter
        var startRecordingAPI: NetworkingAPIProtocol {
            if let networkingAPI = networkingAPI {
                return networkingAPI[0]
            } else {
                let session = URLSession(configuration: .default)
                let httpService = HttpService(session: session)
                return NetworkingAPI(httpService: httpService)
            }
        }
        
        var getCameraAPI: NetworkingAPIProtocol {
            if let networkingAPI = networkingAPI {
                return networkingAPI[1]
            } else {
                let session = URLSession(configuration: .default)
                let httpService = HttpService(session: session)
                return NetworkingAPI(httpService: httpService)
            }
        }
        
        // Check startRecording was successful before retrieving cameraUrl
        startRecordingAPI.startRecording { (success) in
            // completionHandler must be inside DispatchQueue
            // otherwise, it will be executed before cameraUrl assignment
            guard success == true else {
                DispatchQueue.main.async {
                    self.cameraControlVM.cameraUrl = nil
                    completionHandler?()
                }
                return
            }
            
            getCameraAPI.getCameraUrl { (url) in
                guard let url = url else {
                    DispatchQueue.main.async {
                        self.cameraControlVM.cameraUrl = nil
                        completionHandler?()
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    self.cameraControlVM.cameraUrl = url
                    completionHandler?()
                }
            }
        }
    }
    
    func stopRecording(networkingAPI: NetworkingAPIProtocol?, completionHandler: (() -> Void)?) {
        
        // Determine whether networkingAPI is passed as a parameter
        var stopRecordingAPI: NetworkingAPIProtocol {
            if let networkingAPI = networkingAPI {
                return networkingAPI
            } else {
                let session = URLSession(configuration: .default)
                let httpService = HttpService(session: session)
                return NetworkingAPI(httpService: httpService)
            }
        }
        
        // Set cameraUrl to nil whether successful or not
        stopRecordingAPI.stopRecording { (success) in
            
            DispatchQueue.main.async {
                self.cameraControlVM.cameraUrl = nil
                completionHandler?()
            }
        }
    }
    
    func addUserInfo() {
        
        let db = Firestore.firestore()
//        var ref: DocumentReference? = nil
        let newData: [String: Any] = [
            "display_name": "Test User 2",
            "email": "testuser2@gmail.com",
        ]
        
        db.document("Users/San Francisco, Ca/DogSitters/TestDogSitter2").setData(newData) {
            error in
            
            if let error = error {
                print("Error adding data: \(error)")
            } else {
                print("Data successfully written")
            }
        }
    }
    
    func sendNotification() {
        
        sleep(2)
        
        let clientEmail = "josalgado12709@gmail.com"
        let androidChannel = "FirebaseMessage"
//        let fcmToken = "faC_BH0ERo6HbrNh_8HqNO:APA91bGtoHvWh1x5fiJfJIUVAzSLqoBKwQPZjz18Q4EFPEJuQ7mbbbCxWABBnEjv04RBlhjpr-Nurdgb5v5FkiJQ2cwyToWaBZe3kANOnBgTjcHAm1syXJY2QPJ9B4GtkWFrC1OAuw1i"
        
        let fcmToken = "eO7P9aVXKEElrK-_WMogI-:APA91bE0XPWZTxeI_gp2zmVMWo0Z4vG89TS77r4aO_G1RjdRHSnJ9vQTg2lVSrbQ7uyq7PZK7vlazd6Ej5-de9lI53LuuJEW8HbwaTSqe2ofTwSpmJGuSwobEnh5Hm-gDEBeCTMYhC0e"
        
        let imageUrlString = "https://imgproxy.geocaching.com/29f2d5cd7e35051b4bc048191eb78dffebe04bf0?url=http%3A%2F%2Fwww.bassethoundsrunning.com%2Fwp-content%2Fuploads%2F2013%2F02%2Fbasset_hound_running_0084thumb.jpg"
        let data: [String: Any] = [
            "clientEmail": clientEmail,
            "fcmToken": fcmToken,
            "androidChannel": androidChannel,
            "imageUrlString": imageUrlString,
        ]
        
        let functions = Functions.functions()
        functions.httpsCallable("testCallable").call(data) { (result, error) in
            
            if let error = error as NSError? {
              if error.domain == FunctionsErrorDomain {
                let code = FunctionsErrorCode(rawValue: error.code)
                let message = error.localizedDescription
                let details = error.userInfo[FunctionsErrorDetailsKey]
              
                print("Error inside testCallable: ", code, message, details)
                }
              // ...
                return
            }
            print("No error returned from testCallable")
            
            if let result = result {
                print("data returned:", result.data)
            }
        }
    }
}
