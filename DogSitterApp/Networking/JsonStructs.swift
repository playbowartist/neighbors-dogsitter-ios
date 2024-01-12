//
//  JsonStructs.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/16/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import Foundation

// postLogin
struct LoginResponse: Decodable {
    var data: AuthToken
}

struct AuthToken: Decodable {
    var auth_token: String?
}

// getCameras
struct GetCameraResponse: Decodable {
    var results: [GetCameraResults]
}

struct GetCameraResults: Decodable {
    var streams: [Streams]
}

struct Streams: Decodable {
    var format: String?
    var url: String?
}

// getRecordingList
struct GetRecordingListResponse: Decodable {
    var results: [GetRecordingListResults]
}

struct GetRecordingListResults: Decodable {
    var download_url: String?
    var name: String?
    var start: String?
    var end: String?
}

struct GetRecordedClipResponse: Decodable {
    var download_url: String?
}

// getAcuityAppointments
struct Appointment: Decodable {
    var email: String
    var date: String        // Human readable "July 2, 2013"
    var datetime: String    // ISO format "2013-07-02T10:15:00-0700"
    var calendarID: Int
}

struct AcuityClient: Decodable {
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
}

struct AcuityCalendar: Decodable {
    var id: Int
    var name: String
    var email: String
}
