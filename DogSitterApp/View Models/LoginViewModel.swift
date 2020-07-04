//
//  LoginViewModel.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/7/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import Foundation

class LoginViewModel {
    
    var user: User
    var email: String = ""
    var password: String = ""
    
    init() {
        self.user = User(email: self.email, password: self.password)
    }
    
    func printCredentials() {
        print("loginViewModel credentials:")
        print(self.email)
        print(self.password)
    }
    
    func login(networkingAPI: NetworkingAPI?, completionHandler: (() -> Void)?) {
        
        var loginAPI: NetworkingAPI {
            if networkingAPI != nil {
                return networkingAPI!
            } else {
                let session = URLSession(configuration: .default)
                let httpService = HttpService(session: session)
                return NetworkingAPI(httpService: httpService)
            }
        }

        loginAPI.postLogin(email: self.email, password: self.password) { (auth_token) in
            guard let auth_token = auth_token else {
                self.user.auth_token = nil
                completionHandler?()
                return
            }
            self.user.auth_token = auth_token
            print("auth_token after login():\n", auth_token)
            
            completionHandler?()
        }
    }
    
    func register(completionHandler: (() -> Void)?) {
        
//        let firebaseAuth = FirebaseAuthentication()
//        
//        firebaseAuth.register(withEmail: self.email, password: self.password) { (result) in
//            
//            switch result {
//            case .success(let user):
//                self.user = user
//                print("user: ", user)
//                
//            case .failure(let error):
//                print("error: ", error)
//            }
//            
//            completionHandler?()
//        }
        
    }
}
