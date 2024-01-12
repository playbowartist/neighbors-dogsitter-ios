//
//
//  SettingsView.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 10/12/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var appState: AppState
    let authAPI = AuthenticationAPI()
    
    var body: some View {
        
        Button(action: {
            let logoutError = self.authAPI.logout()
            if logoutError == nil {
                self.appState.userData = nil
                self.appState.tabSelection = .calendarView
                self.appState.loginDestination = .firebaseAuthentication
            } else {
                // Display popup indicating logout unsuccessful
            }
        }) {
            Text("Logout")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
