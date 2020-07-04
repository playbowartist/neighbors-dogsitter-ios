//
//  ContentView.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/1/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    @State private var loginVM = LoginViewModel()
    @State private var completeLogin: Bool = false
    
    let recordingListVM = RecordingListViewModel()
        
    var body: some View {
        
        return NavigationView {
            VStack {
                
                NavigationLink(destination: FirebaseAuthView(), isActive: .constant(true)) {
                    EmptyView()
                }
                
                NavigationLink(destination: RecordingListView(recordingListVM: recordingListVM), isActive: self.$completeLogin) { EmptyView() }
                
                TextField("Email", text: $loginVM.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                SecureField("Password", text: $loginVM.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                Button("Login") {
                    self.loginVM.login(networkingAPI: nil) {
                        if self.loginVM.user.auth_token != nil {
                            DispatchQueue.main.async {
                                self.completeLogin = true
                            }
                        }
                    }
                }.padding()
                
                Button("Register") {
                    self.loginVM.register {
                        if self.loginVM.user.firebaseID != nil {
                            DispatchQueue.main.async {
                                self.completeLogin = true
                            }
                        }
                    }
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

