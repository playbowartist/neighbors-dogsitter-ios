//
//  SelectUserTypeViewModel.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 10/6/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import Foundation
import FirebaseFirestore

class SelectUserTypeViewModel: ObservableObject {

    @Published var dogSitterIsSelected = false
    @Published var customerIsSelected = false
    var user_id: String?
    var userType: UserType?
    var userTypeString: String?
        
    func saveUserType(appStateUserData: UserData, completionHandler: @escaping (Result<UserType, ValidationError>) -> Void) {
        // First check that email & phoneNumber is found in Acuity
        // If found, save userData to Firestore
        // Else display error message to user
        // Also, perform input validation for email, preferably on the fly, else when Save
        
        // Basic data from firebase auth available for profile
        guard let user_id = appStateUserData.user_id else {
                print("Error, insufficient information to save user_type to database")
                completionHandler(.failure(.userDataError))
                return
        }
        if dogSitterIsSelected {
            self.userType = .dogsitter
            self.userTypeString = self.userType?.rawValue
        } else if customerIsSelected {
            self.userType = .customer
            self.userTypeString = self.userType?.rawValue
        }
        
        self.user_id = user_id
        self.saveFirebaseUserType(completionHandler: completionHandler)
    }
    
    func saveFirebaseUserType(completionHandler: @escaping (Result<UserType, ValidationError>) -> Void) {

        guard let userTypeString = self.userTypeString,
            let user_id = self.user_id
            else { return }

        let firestoreUserType: [String: Any] = [
            "user_id": user_id,
            "city": DataBaseStrings.sanFrancisco,
            "user_type": userTypeString,
        ]
        print("firestoreUserType:\n", firestoreUserType)
        
        let db = Firestore.firestore()
        db.document("/UserTypes/\(user_id)").setData(firestoreUserType) { (error) in
            if let error = error {
                print("Error writing document: \(error)")
                completionHandler(.failure(.userTypeError))
            } else {
                print("Document successfully written")
                // TODO: Return an error in completionHandler if save not successful
                guard let userType = self.userType else { return }
                completionHandler(.success(userType))
            }
        }
    }

}
