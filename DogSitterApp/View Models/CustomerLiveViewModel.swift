//
//  CustomerLiveViewModel.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 10/15/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFunctions
import FirebaseFirestore
import AVFoundation
import Combine

class CustomerLiveViewModel: NSObject, ObservableObject {
    
    @Published var cameraUrl: URL?
    @Published var nowRecording: Bool = false
    @Published var isPlaying: Bool = false
    @Published var showSpinner: Bool = true
    @Published var dogSitterProfile: UserData?
    @Published var dogSitterImage: UIImage?
    @Published var videoPlayer: AVPlayer?
    
    var appState: AppState?
    private var observer: Any?
    private var cancellable: AnyCancellable?
    
    override init() {
        super.init()
        
        if let firebaseUser = Auth.auth().currentUser {
            getAcuityAppointments(user: firebaseUser, optionalNetworkingAPI: nil, completionHandler: nil)
        }
    }
    
    func loadImage(url: URL) {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.dogSitterImage = $0 }
    }
    
    func cancelImage() {
        cancellable?.cancel()
    }
    
    private func registerObservers() {
        self.videoPlayer?.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "timeControlStatus",
            let change = change,
            let newValue = change[NSKeyValueChangeKey.newKey] as? Int,
            let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
            let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
            let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
            if newStatus != oldStatus {
                DispatchQueue.main.async { [weak self] in
                    if newStatus == .playing {
                        self?.isPlaying = true
                        self?.showSpinner = false
                    } else if newStatus == .waitingToPlayAtSpecifiedRate || newStatus == .paused {
                        self?.isPlaying = false
                        self?.showSpinner = true
                    }
                }
            }
        }
    }
    
    func getLiveCameraUrl(authHeader: String, networkingAPI: [NetworkingAPIProtocol]?, completionHandler: (() -> Void)?) {
        
        // Determine whether networkingAPI is passed as a parameter
        var getCameraAPI: NetworkingAPIProtocol {
            if let networkingAPI = networkingAPI {
                return networkingAPI[0]
            } else {
                return NetworkingAPIFactory.networkingAPI()
            }
        }
            
        getCameraAPI.getCameraUrl(authHeader: authHeader) { (url) in
            guard let url = url else {
                DispatchQueue.main.async {
                    self.cameraUrl = nil
                    self.showSpinner = false
                    completionHandler?()
                }
                return
            }
            
            DispatchQueue.main.async {
                self.cameraUrl = url
                self.videoPlayer = AVPlayer(url: url)
                self.videoPlayer?.play()
                self.videoPlayer?.isMuted = true
                self.registerObservers()
                
                completionHandler?()
            }
        }
    }
    
    func observeNowRecording(firebaseID: String) {
        let db = Firestore.firestore()
        db.document("\(DataBaseStrings.angelcamUsers)/\(firebaseID)")
            .addSnapshotListener { (documentSnapshot, error) in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(String(describing: error))")
                    return
                }
                guard let data = document.data() else {
                    print("Angelcam data was empty")
                    return
                }
                DispatchQueue.main.async {
                    self.nowRecording = data[DataBaseStrings.nowRecording] as? Bool ?? false
                    if self.nowRecording == false {
                        self.appState?.showLiveViewFullscreen = false
                        self.appState?.videoURL = nil
                    }
                }
        }
    }
    
    func getAcuityAppointments(user: User, optionalNetworkingAPI: NetworkingAPIProtocol?, completionHandler: (() -> Void)?) {
        
        // Start by getting Acuity appointments currently booked
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US")
        let today = dateFormatter.string(from: Date())
        
        guard let phoneNumber = user.phoneNumber,
            let acuityPhoneNumber = InputValidation.acuityFormat(phoneNumber: phoneNumber) else {
            print("Error, no phone number to filter getAcuityAppointments")
            return
        }
                
        // Determine whether networkingAPI is passed as a parameter
        var networkingAPI: NetworkingAPIProtocol {
            if let networkingAPI = optionalNetworkingAPI {
                return networkingAPI
            } else {
                return NetworkingAPIFactory.networkingAPI()
            }
        }
        
        networkingAPI.getAcuityAppointments(minDate: today, maxDate: today, email: nil, phoneNumber: acuityPhoneNumber, calendarID: nil) { (appointmentList) in
            guard let appointmentList = appointmentList else { return }
                        
            networkingAPI.getAcuityCalendars { calendarList in
                guard let calendarList = calendarList else { return }
                
                var emailList = [String]()
                
                for appointment in appointmentList {
                    for calendar in calendarList {
                        if appointment.calendarID == calendar.id {
                            emailList.append(calendar.email)
                        }
                    }
                }
                
                guard let firstEmail = emailList.first else {
                    DispatchQueue.main.async {
                        self.cameraUrl = nil
                        self.videoPlayer = nil
                        self.dogSitterProfile = nil
                    }
                    return
                }
                
                FirestoreAPI.emailToFirebaseID(email: firstEmail) { (firebaseID) in
                    guard let firebaseID = firebaseID else { return }
                    
                    self.observeNowRecording(firebaseID: firebaseID)
                    
                    FirestoreAPI.getUserType(firebaseID: firebaseID) { (userData) in
                        guard let userTypeData = userData,
                            let userType = userTypeData.userType,
                            let city = userTypeData.city else { return }
                        
                        FirestoreAPI.getProfile(firebaseID: firebaseID, userType: userType, city: city) { (userData) in
                            self.dogSitterProfile = userData
                            if let profilePhoto = userData?.profile_photo,
                                let url = URL(string: profilePhoto) {
                                self.loadImage(url: url)
                            }
                        }
                    }
                    
                    FirestoreAPI.getAngelcamToken(firebaseID: firebaseID) { (angelcamToken) in
                        guard let angelcamToken = angelcamToken else { return }
                        self.getLiveCameraUrl(authHeader: angelcamToken, networkingAPI: nil, completionHandler: nil)
                    }
                }
            }
            completionHandler?()
        }
    }
}
