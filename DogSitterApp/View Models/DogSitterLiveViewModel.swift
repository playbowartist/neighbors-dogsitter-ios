//
//  DogSitterLiveViewModel.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/11/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

//import Combine
import Foundation
import AVFoundation
import FirebaseAuth
import FirebaseFirestore

class DogSitterLiveViewModel: ObservableObject {
    
    @Published var cameraUrl: URL?
    @Published var nowRecording: Bool = false
    @Published var disableStartButton = false
    @Published var disableStopButton = false
    
    var videoPlayer: AVPlayer? {
        guard let cameraUrl = self.cameraUrl else { return nil }
        return AVPlayer(url: cameraUrl)
    }

    // Temp:
//    let angelCamAuthHeader = "PersonalAccessToken afec708ac67fbccaa1a9b1c3ec3c31a34d740879"
    
    init() {
//        getLiveCameraUrl(networkingAPI: nil, completionHandler: nil)
        
        if let firebaseUser = Auth.auth().currentUser {
            FirestoreAPI.getAngelcamToken(firebaseID: firebaseUser.uid) { (angelcamToken) in
                guard let angelcamToken = angelcamToken else { return }
                print("\nangelcamToken: ", angelcamToken)
                self.getLiveCameraUrl(authHeader: angelcamToken, networkingAPI: nil, completionHandler: nil)
            }
            
            observeNowRecording(user: firebaseUser)
        }
    }
    
    // TODO: Dynamically fetch the angelCamAuthHeader using the DogSitter's firebaseID
    func getLiveCameraUrl(authHeader: String, networkingAPI: [NetworkingAPIProtocol]?, completionHandler: (() -> Void)?) {
        
        // Determine whether networkingAPI is passed as a parameter
        var getCameraAPI: NetworkingAPIProtocol {
            if let networkingAPI = networkingAPI {
                return networkingAPI[0]
            } else {
                return NetworkingAPIFactory.networkingAPI()
            }
        }
            
        getCameraAPI.getCameraUrl(authHeader: authHeader) { (url) in
            guard let url = url else {
                DispatchQueue.main.async {
                    self.cameraUrl = nil
                    completionHandler?()
                }
                return
            }
            
            DispatchQueue.main.async {
                // Test code url -- remove for production
                let url = URL(string: "https://m1-na8.angelcam.com/cameras/98280/streams/hls/playlist.m3u8?token=eyJjYW1lcmFfaWQiOiI5ODI4MCIsInRpbWUiOjE2MTkwNDQyMjQxODI3NDksInRpbWVvdXQiOjM2MDB9%2E1f75cd39a8b9f6d81001cf730e4b279fcec52468d3394d1c26a35e807c9f54ef")!
                print("\ncameraUrl: ", url)
                self.cameraUrl = url
                completionHandler?()
            }
        }
    }
    
    func observeNowRecording(user: User) {
        let db = Firestore.firestore()
        db.document("AngelCamUsers/\(user.uid)")
            .addSnapshotListener { (documentSnapshot, error) in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(String(describing: error))")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty")
                    return
                }
                print("Current data inside observeNowRecording in DogSitterLiveVM: \(data)")
                DispatchQueue.main.async {
                    self.nowRecording = data[DataBaseStrings.nowRecording] as? Bool ?? false
                    self.disableStartButton = self.nowRecording
                    self.disableStopButton = !self.nowRecording
                    print("isRecording in VM: \(self.nowRecording)")
                }
        }
    }
    
    func emailToFirebaseID(email: String, completionHandler: @escaping (String?) -> Void) {
        
        let db = Firestore.firestore()
        let docRef = db.document("AcuityUsers/" + email)
        docRef.getDocument { (document, error) in
            guard let document = document, document.exists,
                let data = document.data()
                else {
                    print("Email not found")
                    completionHandler(nil)
                    return
            }
            completionHandler(data["user_id"] as? String)
        }
    }
    
    func getFcmToken(type: String, city: String, user_id: String, completionHandler: @escaping (String?) -> Void) {
        
        let db = Firestore.firestore()
        let docRef = db.document("\(DataBaseStrings.users)/" + type + "/" + city + "/" + user_id)
        docRef.getDocument { (document, error) in
            guard let document = document, document.exists,
                let data = document.data()
                else {
                    print("User not found for fcm_token retrieval")
                    completionHandler(nil)
                    return
            }
            completionHandler(data["fcm_token"] as? String)
        }
    }
    
    func setIsRecording(to value: Bool, user: User) {
        
        let db = Firestore.firestore()
        let docRef = db.document("\(DataBaseStrings.angelcamUsers)/" + user.uid)
        
        docRef.updateData([
            DataBaseStrings.nowRecording : value
        ]) { (error) in
            if let error = error {
                print("Error setting nowRecording: \(error)")
            }
        }
    }
    
    func startStreamAndRecording(user: User, networkingAPI: NetworkingAPIProtocol?, completionHandler: (() -> Void)?) {
        
        // Start by getting Acuity appointments currently booked
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US")
        let today = dateFormatter.string(from: Date())
        
        // Determine whether networkingAPI is passed as a parameter
        var getAcuityAppointmentsAPI: NetworkingAPIProtocol {
            if let networkingAPI = networkingAPI {
                return networkingAPI
            } else {
                return NetworkingAPIFactory.networkingAPI()
            }
        }
        
        // TODO: Fetch this DogSitter's calendarID first, so can filter appointments by calendarID
        getAcuityAppointmentsAPI.getAcuityAppointments(minDate: today, maxDate: today, email: nil, phoneNumber: nil, calendarID: nil) { (appointmentList) in
        
            guard let appointmentList = appointmentList else { return }
            
            for appointment in appointmentList {
    
                self.emailToFirebaseID(email: appointment.email) { (user_id) in
                    guard let user_id = user_id else { return }
                        print("user_id:", user_id)

                    FirestoreAPI.saveAngelcamCustomerID(dogsitterID: user.uid, customerID: user_id, completionHandler: nil)
                    
                    // TODO: Once we need to send notifications to DogSitter as well, or beyond SanFrancisco,
                    // need to fetch UserType info from db using user_id
                    
                    self.getFcmToken(type: DataBaseStrings.customer, city: DataBaseStrings.sanFrancisco, user_id: user_id) { (fcm_token) in
                        guard let fcm_token = fcm_token else { return }
                        print("fcm_token:", fcm_token)
                        
                        CloudFunctionsAPI.sendNotification(fcmToken: fcm_token, title: UIStrings.notificationTitle, body: UIStrings.notificationBody, imageUrlString: UrlStrings.bassetImageUrlString, androidChannel: nil)
                        
                        self.setIsRecording(to: true, user: user)
                    }
                }
            }
            
            DispatchQueue.main.async {

                completionHandler?()
            }
        }
    }
}
