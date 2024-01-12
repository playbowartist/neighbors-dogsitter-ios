//
//  FirestoreAPI.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 9/24/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import Foundation
import FirebaseFirestore

class FirestoreAPI {
    
    static func getProfile(firebaseID: String, userType: UserType, city: String, completionHandler: @escaping (UserData?) -> Void) {
        
        let db = Firestore.firestore()
        var ref: DocumentReference?
        ref = db.document("/\(DataBaseStrings.users)/\(userType.rawValue)/\(city)/\(firebaseID)")
        ref?.getDocument() { (document, error) in
            
            guard let document = document,
                document.exists else {
                    completionHandler(nil)
                    return
            }
            
            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
            
            let userData = UserData(
                user_id: document.get("user_id") as? String,
                first_name: document.get("first_name") as? String,
                last_name: document.get("last_name") as? String,
                display_name: document.get("display_name") as? String,
                profile_photo: document.get("profile_photo") as? String,
                email: document.get("email") as? String ?? "",
                phone_number: document.get("phone_number") as? String,
                address: nil,
                city: nil,
                state: nil,
                zip_code: nil,
                is_active: nil,
                completed_onboarding: document.get("completed_onboarding") as? Bool,
                userType: userType,
                fcm_token: document.get("fcm_token") as? String,
                auth_token: nil,
                jwtToken: nil,
                firebaseID: document.get("user_id") as? String,
                password: nil
            )
            completionHandler(userData)
        }
    }
    
    static func getUserType(firebaseID: String, completionHandler: @escaping (UserData?) -> Void) {
        
        let db = Firestore.firestore()
        var ref: DocumentReference?
        ref = db.document("/UserTypes/\(firebaseID)")
        ref?.getDocument() { (document, error) in
            
            guard let document = document,
                document.exists else {
                    completionHandler(nil)
                    return
            }
            
            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
            
            var userType: UserType?
            let userTypeString = document.get("user_type") as? String ?? ""
            switch userTypeString {
            case DataBaseStrings.customer: userType = .customer
            case DataBaseStrings.dogsitter: userType = .dogsitter
            default: userType = nil
            }
            
            let userData = UserData(
                user_id: document.get("user_id") as? String,
                first_name: nil,
                last_name: nil,
                display_name: nil,
                profile_photo: nil,
                email: nil,
                phone_number: nil,
                address: nil,
                city: document.get("city") as? String,
                state: nil,
                zip_code: nil,
                is_active: nil,
                completed_onboarding: nil,
                userType: userType,
                fcm_token: nil,
                auth_token: nil,
                jwtToken: nil,
                firebaseID: document.get("user_id") as? String,
                password: nil
            )
            completionHandler(userData)
        }
    }
    
    static func emailToFirebaseID(email: String, completionHandler: @escaping (String?) -> Void) {
        
        let db = Firestore.firestore()
        let docRef = db.document(DataBaseStrings.acuityUsers + "/" + email)
        docRef.getDocument { (document, error) in
            guard let document = document, document.exists,
                let data = document.data()
                else {
                    print("Email not found in attempt to retrieve firebaseID")
                    completionHandler(nil)
                    return
            }
            completionHandler(data["user_id"] as? String)
        }
    }
    
    static func getAngelcamToken(firebaseID: String, completionHandler: @escaping (String?) -> Void) {
        
        let db = Firestore.firestore()
        let docRef = db.document(DataBaseStrings.angelcamUsers + "/" + firebaseID)
        docRef.getDocument { (document, error) in
            guard let document = document, document.exists,
                let data = document.data()
                else {
                    print("Angelcam token not found from Firestore")
                    completionHandler(nil)
                    return
            }
            completionHandler(data["angelcam_token"] as? String)
        }
    }
    
    static func getRecordedClipsCollection(userType: UserType, city: String, firebaseID: String, completionHandler: @escaping () -> Void) {
        
        let db = Firestore.firestore()
        let collectionRef = db.collection("/\(DataBaseStrings.users)/\(userType.rawValue)/\(city)/\(firebaseID)/RecordedClips")
        collectionRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting RecordedClips collection: \(error)")
                return
            }
            
            guard let querySnapshot = querySnapshot else { return }
            
            for document in querySnapshot.documents {
                print("\(document.documentID) => \(document.data())")
            }
        }
    }
    
    static func saveFcmToken(fcmToken: String, firebaseID: String, userType: UserType, city: String, completionHandler: @escaping () -> Void) {
        
        let db = Firestore.firestore()
        var ref: DocumentReference?
        ref = db.document("/\(DataBaseStrings.users)/\(userType.rawValue)/\(city)/\(firebaseID)")
        ref?.updateData(
            [DataBaseStrings.fcmToken: fcmToken]
        ) { error in
            if let error = error {
                print("Error updating document: \(error)")
                completionHandler()
            } else {
                print("fcmToken successfully updated")
                completionHandler()
            }
        }
    }
    
    static func saveAngelcamCustomerID(dogsitterID: String, customerID: String, completionHandler: (() -> Void)?) {
        
        let db = Firestore.firestore()
        var ref: DocumentReference?
        ref = db.document("/\(DataBaseStrings.angelcamUsers)/\(dogsitterID)")
        ref?.updateData(
            [DataBaseStrings.customerID: customerID]
        ) { error in
            if let error = error {
                print("Error updating document: \(error)")
                completionHandler?()
            } else {
                print("AngelcamUsers customer_id successfully updated")
                completionHandler?()
            }
        }
    }
}

