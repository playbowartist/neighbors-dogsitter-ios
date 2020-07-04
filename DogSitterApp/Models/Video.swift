//
//  Video.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/22/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import Foundation

struct Video: Equatable, Identifiable {
    var id = UUID()
    var url: URL
    var name: String?
    var startDate: Date?
    var stopDate: Date?
}
