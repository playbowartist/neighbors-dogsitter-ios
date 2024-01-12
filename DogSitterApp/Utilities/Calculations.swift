//
//  Calculations.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 11/17/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import Foundation

class Calculations {
    
    static func formatTimeInterval(timeInterval: TimeInterval) -> String {
        let interval = Int(timeInterval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        if hours > 0 {
            return String(format: "%01d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%01d:%02d", minutes, seconds)
        }
    }
}
