//
//  ContentView.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/1/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var loginVM = LoginViewModel()
        
    var body: some View {
        
        // Test code - okay to delete
//        let url = URL(string: "https://api.angelcam.com/v1/cameras/")!
//        let AUTHHEADER = "PersonalAccessToken afec708ac67fbccaa1a9b1c3ec3c31a34d740879"
//        let session = URLSession(configuration: .default)
//        let httpService = HttpService(session: session)
//        httpService.getData(url: url, authHeader: AUTHHEADER) { (data) in
//            print("inside getData closure of ContentView")
//            let json = try? JSONSerialization.jsonObject(with: data!)
//            print("json received:\n", json!)
//        }
//
//        let LOGIN_URL = "https://playbowtech.com/api/login/"
//        let LOGIN_EMAIL = "tripledog@gmail.com"
//        let LOGIN_PASSWORD = "123456"
//        let url_login = URL(string: LOGIN_URL)!
//        let requestJsonBody: [String: Any] = [
//            "email": LOGIN_EMAIL,
//            "password": LOGIN_PASSWORD
//        ]
//        httpService.postJsonData(url: url_login, requestJsonBody: requestJsonBody) { (data) in
//            print("inside postJsonData closure of ContentView")
//            let json = try? JSONSerialization.jsonObject(with: data!)
//            print("json received:\n", json!)
//        }
        
//        let networkingAPI = NetworkingAPI(httpService: httpService)
//        networkingAPI.getCameraUrl { (url) in
//            print("url inside ContentView: ", url)
//        }
        
        return NavigationView {
            VStack {
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
                NavigationLink(destination: CameraControlView()) {
                    Text("Login")
                }.padding()
                Button("Print credentials") {
                    self.loginVM.printCredentials()
                }.padding()
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

