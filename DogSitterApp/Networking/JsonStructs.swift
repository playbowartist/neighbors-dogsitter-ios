//
//  JsonStructs.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/16/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import Foundation

struct AngelcamCameraList: Decodable {
    var results: [Results]
}

struct Results: Decodable {
    var streams: [Streams]
}

struct Streams: Decodable {
    var format: String?
    var url: String?
}

struct LoginResponse: Decodable {
    var data: AuthToken
}

struct AuthToken: Decodable {
    var auth_token: String?
}
