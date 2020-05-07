//
//  LoginViewModel.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/7/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

//import Combine
import SwiftUI

class LoginViewModel {
    
    var email: String = ""
    var password: String = ""
    
    func printCredentials() {
        print("loginViewModel credentials:")
        print(self.email)
        print(self.password)
    }
}
