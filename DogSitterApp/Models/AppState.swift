//
//  AppState.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 6/25/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import Foundation
import FirebaseAuth
import SwiftUI
import Combine

class AppState: ObservableObject {

//    @Published var firebaseUser: User?
    var userData: UserData?
//    @Published var presentOnboarding: Bool = false
    
    let objectWillChange = PassthroughSubject<AppState, Never>()
    
    var isLoggedIn: Bool = false {
        didSet {
            withAnimation(.linear(duration: 1.0)) {
                objectWillChange.send(self)
            }
        }
    }
    
    var loginDestination: LoginDestination = .firebaseAuthentication {
        didSet {
            withAnimation(.linear(duration: 1.0)) {
                objectWillChange.send(self)
            }
        }
    }

    
    var presentOnboarding: Bool = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    var firebaseUser: User? {
        didSet {
            withAnimation(.linear(duration: 1.0)) {
                objectWillChange.send(self)
            }
        }
    }
    
    // Data needed to exit tabview and show video fullscreen
    var showLiveViewFullscreen: Bool = false {
        didSet {
            withAnimation(.linear(duration: 0.5)) {
                objectWillChange.send(self)
            }
        }
    }
    
    var showRecordedClipFullscreen: Bool = false {
        didSet {
            withAnimation(.linear(duration: 0.5)) {
                objectWillChange.send(self)
            }
        }
    }
    
    var tabSelection: TabSelection = .calendarView {
        didSet {
            withAnimation(.linear(duration: 0.5)) {
                objectWillChange.send(self)
            }
        }
    }
    
    var videoURL: URL?
}

enum LoginDestination {
    case firebaseAuthentication
    case selectUserType
    case userOnboarding
    case mainTabView
}

enum TabSelection: Hashable {
    case calendarView
    case reserveDatesView
    case liveVideoView
    case recordedClipsView
    case settingsView
}
