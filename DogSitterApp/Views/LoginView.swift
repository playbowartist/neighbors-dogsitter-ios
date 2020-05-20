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
        
    var body: some View {
        
        return NavigationView {
            VStack {
                NavigationLink(destination: CameraControlView(), isActive: self.$completeLogin) { EmptyView() }
                
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
                            self.completeLogin = true
                        }
                    }
                    
                }.padding()
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

