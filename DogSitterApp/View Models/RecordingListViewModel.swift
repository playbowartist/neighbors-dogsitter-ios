//
//  RecordingListViewModel.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/22/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import UIKit

class RecordingListViewModel: ObservableObject {
    
    @Published var videoList: [Video]?
    @Published var videoUrl: URL?
    @Published var isPortrait: Bool?
    
    private var observer: NSObjectProtocol?
    
    init() {
        // initial orientation
        if UIDevice.current.orientation != .unknown {
            self.isPortrait = UIDevice.current.orientation.isPortrait
            print("initial orientation: ", UIDevice.current.orientation.rawValue)
        }
        // update orientation when device is rotated
        self.observer = NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: nil) { [weak self] (notification) in
            guard let device = notification.object as? UIDevice,
                device.orientation != .unknown else { return }
            self?.isPortrait = device.orientation.isPortrait
            print("isPortrait inside addObserver: ", self?.isPortrait)
        }
        print("isPortrait at end of VM init: ", self.isPortrait)
    }
    
    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
