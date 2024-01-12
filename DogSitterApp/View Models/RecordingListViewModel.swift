//
//  RecordingListViewModel.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/22/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import UIKit
import SwiftUI
import Combine
import FirebaseStorage
import FirebaseFirestore

class RecordingListViewModel: ObservableObject {
    
    
    @Published var videoUrl: URL?
    @Published var isPortrait: Bool?    
    @Published var videoList: [Video] = [Video]()

//    private var thumbnailList = [String?]()
//    private var cancellable: AnyCancellable?

    
//    func loadImage(url: URL, completionHandler: @escaping (UIImage?) -> Void) {
//        cancellable = URLSession.shared.dataTaskPublisher(for: url)
//            .map { UIImage(data: $0.data) }
//            .replaceError(with: nil)
//            .receive(on: DispatchQueue.main)
//            .assign { completionHandler($0) }
//    }
//
//    func cancelImage() {
//        cancellable?.cancel()
//    }
    
    func observeRecordedClips(userData: UserData?) {
        
        print("initial clearing videoList")
        self.videoList.removeAll()
        
        guard let userData = userData,
              let userType = userData.userType,
              let city = userData.city,
              let firebaseID = userData.user_id else {
            print("Unable to observe RecordedClips")
            return
        }
        
        let db = Firestore.firestore()
        let collectionRef = db.collection("/\(DataBaseStrings.users)/\(userType.rawValue)/\(city)/\(firebaseID)/\(DataBaseStrings.recordedClips)")
        collectionRef.addSnapshotListener { (querySnapshot, error) in
            
            if let error = error {
                print("Error observing RecordedClips collection: \(error)")
                //                completionHandler(nil)
                return
            }
            
            guard let documents = querySnapshot?.documents else { return }
            print("clearing videoList after observing DB")
            self.videoList.removeAll()
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateFormatter.timeStyle = .short
            
            for document in documents {
                guard let clip_id = document["id"] as? String else { continue }
                guard let camera_id = document["camera_id"] as? String else { continue }
                guard let start = document["start"] as? String else { continue }
                guard let end = document["end"] as? String else { continue }
                guard let startDate = ISO8601DateFormatter().date(from: start) else { continue }
                guard let stopDate = ISO8601DateFormatter().date(from: end) else { continue }
                let startDateString = dateFormatter.string(from: startDate)
                let dateComponents = startDateString.components(separatedBy: " at ")
                let timeInterval = stopDate.timeIntervalSince(startDate)
                let formattedTimeInterval = Calculations.formatTimeInterval(timeInterval: timeInterval)
                
                let thumbnail_url = document["thumbnail_url"] as? String
                let thumbnailPlaceholder: UIImage = UIImage(named: "profile-image-placeholder")!
                
                if let thumbnail_url = thumbnail_url,
                   let thumbnailURL = URL(string: thumbnail_url) {

                    DispatchQueue.global().async {
                        if let data = try? Data(contentsOf: thumbnailURL),
                           let thumbnailImage = UIImage(data: data) {
                            
                            DispatchQueue.main.async {
                                print("\nabout to append additional video to list")
                                self.videoList.append(
                                    Video(id: UUID(),
                                          clip_id: clip_id,
                                          camera_id: camera_id,
                                          startDate: startDate,
                                          stopDate: stopDate,
                                          startDateString: startDateString,
                                          dateComponents: dateComponents,
                                          formattedTimeInterval: formattedTimeInterval,
                                          thumbnail: thumbnailImage
                                    )
                                )
                                self.videoList.sort { (lhs, rhs) -> Bool in
                                    lhs.startDate < rhs.startDate
                                }
                                print("current videoList count:", self.videoList.count)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.videoList.append(
                                    Video(clip_id: clip_id,
                                          camera_id: camera_id,
                                          startDate: startDate,
                                          stopDate: stopDate,
                                          startDateString: startDateString,
                                          dateComponents: dateComponents,
                                          formattedTimeInterval: formattedTimeInterval,
                                          thumbnail: thumbnailPlaceholder)
                                )
                                self.videoList.sort { (lhs, rhs) -> Bool in
                                    lhs.startDate < rhs.startDate
                                }
                            }
                        }
                    }
                } else {
                    print("\nAbout to push download_url to db\n")
                    self.pushDownloadURL(clip_id: clip_id, userData: userData, networkingAPI: nil)
                    
                    DispatchQueue.main.async {
                        self.videoList.append(
                            Video(clip_id: clip_id,
                                  camera_id: camera_id,
                                  startDate: startDate,
                                  stopDate: stopDate,
                                  startDateString: startDateString,
                                  dateComponents: dateComponents,
                                  formattedTimeInterval: formattedTimeInterval,
                                  thumbnail: thumbnailPlaceholder)
                        )
                        self.videoList.sort { (lhs, rhs) -> Bool in
                            lhs.startDate < rhs.startDate
                        }
                    }
                }
            }
        }
    }
    
    func setRecordingSelected(clip_id: String, networkingAPI: NetworkingAPIProtocol?) {

        var getRecordedClipAPI: NetworkingAPIProtocol {
            if let networkingAPI = networkingAPI { return networkingAPI }
            else { return NetworkingAPIFactory.networkingAPI() }
        }

        getRecordedClipAPI.getRecordedClipUrl(clip_id: clip_id) { (url) in
            if let url = url {
                DispatchQueue.main.async {
                    self.videoUrl = url
                    //                    self.videoUrl = URL(string: "http://streams.videolan.org/streams/mp4/Mr_MrsSmith-h264_aac.mp4")!  // test video URL
                }
            }
        }
    }
    
    func pushDownloadURL(clip_id: String, userData: UserData, networkingAPI: NetworkingAPIProtocol?) {
        
        var getRecordedClipAPI: NetworkingAPIProtocol {
            if let networkingAPI = networkingAPI { return networkingAPI }
            else { return NetworkingAPIFactory.networkingAPI() }
        }
        
        getRecordedClipAPI.getRecordedClipUrl(clip_id: clip_id) { (url) in
            guard let url = url else { return }
            guard let userType = userData.userType,
                  let city = userData.city,
                  let firebaseID = userData.user_id else { return }
            
            let db = Firestore.firestore()
            let documentRef = db.document("/\(DataBaseStrings.users)/\(userType.rawValue)/\(city)/\(firebaseID)/\(DataBaseStrings.recordedClips)/\(clip_id)")
            
            documentRef.updateData([DataBaseStrings.downloadURL: url.absoluteString]) { error in
                if let error = error {
                    print("Error updating download_url in database: \(error)")
                }
            }
        }
    }
}
