//
//  User.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/1/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import Foundation

struct UserData {
    var user_id: String?
    var first_name: String?
    var last_name: String?
    var display_name: String?
    var profile_photo: String?
    var email: String?
    var phone_number: String?
    var address: String?
    var city: String?
    var state: String?
    var zip_code: String?
    var is_active: Bool?
    var completed_onboarding: Bool?
    var userType: UserType?
    var fcm_token: String?
    // Not used:
    var auth_token: String?
    var jwtToken: String?
    var firebaseID: String?
    var password: String?
}

struct CleanUserData {
    var phoneNumber: String
    var acuityPhoneNumber: String
    var user_id: String
    var fcm_token: String
    var userType: UserType
    var firstName: String
    var lastName: String
    var email: String
}

enum UserType: String {
    case customer = "Customer"
    case dogsitter = "Dog Sitter"
}
