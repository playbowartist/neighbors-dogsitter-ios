//
//  RootView.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 7/5/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import SwiftUI

// TODO: Depending on wehther userSettings.firebaseUser is nil or not,
// display FirebaseAuthView or CameraControlView
// Right now bug -- if already logged in jump to CameraControlView, then Logout gets stuck there.


struct RootView: View {

    @EnvironmentObject private var appState: AppState
    @ObservedObject var recordingListVM: RecordingListViewModel

    var body: some View {

        VStack {

            if appState.loginDestination == .mainTabView {
                HomeTabView(recordingListVM: self.recordingListVM)
            } else if appState.loginDestination == .firebaseAuthentication {
                FirebaseAuthView()
            } else if appState.loginDestination == .selectUserType {
                SelectUserTypeView()
            } else if appState.loginDestination == .userOnboarding {
                OnboardingView()
            }
        }
    }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        RootView()
//    }
//}
