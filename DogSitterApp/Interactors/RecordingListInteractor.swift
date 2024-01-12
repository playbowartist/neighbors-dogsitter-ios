//
//  RecordingListInteractor.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/22/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//
/*
import Foundation

class RecordingListInteractor {
    
    let recordingListVM: RecordingListViewModel
    
    init(recordingListVM: RecordingListViewModel) {
        self.recordingListVM = recordingListVM
    }
    
    func getRecordingList(networkingAPI: NetworkingAPIProtocol?, completionHandler: (() -> Void)?) {
                
        var getRecordingListAPI: NetworkingAPIProtocol {
            if let networkingAPI = networkingAPI {
                return networkingAPI
            } else {
                let session = URLSession(configuration: .default)
                let httpService = HttpService(session: session)
                return NetworkingAPI(httpService: httpService)
            }
        }
        
        getRecordingListAPI.getRecordingList { (videoList) in
            if let videoList = videoList {
                DispatchQueue.main.async {
                    self.recordingListVM.videoList = videoList
                }
            }
            completionHandler?()
        }
    }
    
    func setRecordingSelected(videoUrl: URL) {
        self.recordingListVM.videoUrl = videoUrl
    }
}
*/
