//
//  OnboardingViewModel.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 9/27/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import Foundation
import FirebaseFirestore

class OnboardingViewModel: ObservableObject {

    @Published var first_name = ""
    @Published var last_name = ""
    @Published var email = ""
    
    var cleanUserData: CleanUserData?
    
    func saveUserInput(appStateUserData: UserData, completionHandler: @escaping (Result<CleanUserData, ValidationError>) -> Void) {
        // First check that email & phoneNumber is found in Acuity
        // If found, save userData to Firestore
        // Else display error message to user
        // Also, perform input validation for email, preferably on the fly, else when Save
        
        // Basic data from firebase auth available for profile
        guard let phoneNumber = appStateUserData.phone_number,
            let acuityPhoneNumber = InputValidation.acuityFormat(phoneNumber: phoneNumber),
            let user_id = appStateUserData.user_id,
            let fcm_token = appStateUserData.fcm_token,
            let userType = appStateUserData.userType else {
                print("Error, insufficient information to save profile to database")
                completionHandler(.failure(.userDataError))
                return
        }
        
        let cleanFirstName = self.first_name.trimmingCharacters(in: .whitespaces)
        let cleanLastName = self.last_name.trimmingCharacters(in: .whitespaces)
        let cleanEmail = self.email.trimmingCharacters(in: .whitespaces)
    
        self.cleanUserData = CleanUserData(
            phoneNumber: phoneNumber,
            acuityPhoneNumber: acuityPhoneNumber,
            user_id: user_id,
            fcm_token: fcm_token,
            userType: userType,
            firstName: cleanFirstName,
            lastName: cleanLastName,
            email: cleanEmail
        )
        
        self.checkAcuityClients(completionHandler: completionHandler)
    }
    
    func checkAcuityClients(completionHandler: @escaping (Result<CleanUserData, ValidationError>) -> Void) {
        
        guard let cleanUserData = self.cleanUserData else { return }
        
        let session = URLSession(configuration: .default)
        let httpService = HttpService(session: session)
        let networkingAPI = NetworkingAPI(httpService: httpService)
  
        // Removed check to see if user is in Acuity Dec. 2023
/*
        networkingAPI.getAcuityClients(phoneNumber: cleanUserData.acuityPhoneNumber) { clientList in
            
            // Notify user phone number not found
            guard let clientList = clientList else {
                print("Phone number not found in Acuity")
                completionHandler(.failure(.phoneError))
                return
            }
            // Check email and names match
            for client in clientList {
                
                guard client.firstName == cleanUserData.firstName,
                    client.lastName == cleanUserData.lastName else {
                        print("Name not found in Acuity")
                        completionHandler(.failure(.nameError))
                        return
                }
                
                guard client.email == cleanUserData.email else {
                    print("Email not found in Acuity")
                    completionHandler(.failure(.emailError))
                    return
                }
            }
*/
        self.saveFirebaseProfile(completionHandler: completionHandler)
    }

    func saveFirebaseProfile(completionHandler: @escaping (Result<CleanUserData, ValidationError>) -> Void) {

        guard let cleanUserData = self.cleanUserData else { return }

        let firestoreProfile: [String: Any] = [
            "user_id": cleanUserData.user_id,
            "phone_number": cleanUserData.acuityPhoneNumber,
            "display_name": cleanUserData.firstName + " " + cleanUserData.lastName,
            "email": cleanUserData.email,
            "is_active": true,
            "fcm_token": cleanUserData.fcm_token,
            "completed_onboarding": true,
        ]
        print("firestoreProfile:\n", firestoreProfile)
        
        let db = Firestore.firestore()
        db.document("/Users/\(cleanUserData.userType.rawValue)/\(DataBaseStrings.sanFrancisco)/\(cleanUserData.user_id)").setData(firestoreProfile) { (error) in
            if let error = error {
                print("Error writing Users firestore profile: \(error)")
                // Notify user that userData could not be saved
            } else {
                print("Users firestore profile successfully written")
                
                completionHandler(.success(cleanUserData))
                
                // Removed save to Acuity Database Dec. 2023
//                self.saveAcuityUsersLookup(completionHandler: completionHandler)
                // TODO: Return an error in completionHandler if save not successful
                
            }
        }
    }
    
    // Removed call to saveAcuityUsersLookup, and returned .success above
    func saveAcuityUsersLookup(completionHandler: @escaping (Result<CleanUserData, ValidationError>) -> Void) {
    
        guard let cleanUserData = self.cleanUserData else { return }
        
        let acuityLookup: [String: Any] = [
            "user_id": cleanUserData.user_id,
            "email": cleanUserData.email,
        ]
        
        let db = Firestore.firestore()
        db.document("/AcuityUsers/\(cleanUserData.email)").setData(acuityLookup) { (error) in
            if let error = error {
                print("Error writing AcuityUsersLookup: \(error)")
                // Notify user that userData could not be saved
            } else {
                print("AcuityUsersLookup successfully written")
                // TODO: Return an error in completionHandler if save not successful
                completionHandler(.success(cleanUserData))
            }
        }
    }

}

