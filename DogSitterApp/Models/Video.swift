//
//  Video.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/22/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import UIKit

struct Video: Equatable, Identifiable {
    var id = UUID()
    var clip_id: String
    var camera_id: String
    var startDate: Date
    var stopDate: Date
    var startDateString: String
    var dateComponents: [String]
    var formattedTimeInterval: String
    var thumbnail: UIImage
//    var url: URL
    var name: String?
    
}
