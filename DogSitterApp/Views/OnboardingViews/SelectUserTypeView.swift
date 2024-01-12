//
//  SelectUserTypeView.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 9/28/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import SwiftUI

struct SelectUserTypeView: View {
    
    @EnvironmentObject var appState: AppState
    @ObservedObject var selectUserTypeVM = SelectUserTypeViewModel()
    
    @State var dogSitterButtonColor = ColorManager.babyBlue
    @State var customerButtonColor = ColorManager.cream
    @State var dogSitterTextColor = ColorManager.purpleText
    @State var customerTextColor = ColorManager.purpleText
    
    let authAPI = AuthenticationAPI()
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                Button(action: {
                    self.dogSitterButtonColor = ColorManager.selectedGreen
                    self.customerButtonColor = ColorManager.cream
                    self.dogSitterTextColor = Color(.systemGray6)
                    self.customerTextColor = ColorManager.purpleText
                    self.selectUserTypeVM.dogSitterIsSelected = true
                    self.selectUserTypeVM.customerIsSelected = false
                }, label: {
                    
                    UserCardView(
                        image: "clipart1-watermarked-removebg",
                        title: "Dog Sitter",
                        subtitle: "Offering top-notch canine services",
                        textColor: dogSitterTextColor,
                        background: dogSitterButtonColor,
                        selected: self.selectUserTypeVM.dogSitterIsSelected
                    )
                })
                
                Button(action: {
                    self.customerButtonColor = ColorManager.selectedGreen
                    self.dogSitterButtonColor = ColorManager.babyBlue
                    self.customerTextColor = Color(.systemGray6)
                    self.dogSitterTextColor = ColorManager.purpleText
                    self.selectUserTypeVM.customerIsSelected = true
                    self.selectUserTypeVM.dogSitterIsSelected = false
                    
                }, label: {

                    UserCardView(
                        image: "clipart2-watermarked-removebg",
                        title: "Client",
                        subtitle: "Looking for the best dog sitter",
                        textColor: customerTextColor,
                        background: customerButtonColor,
                        selected: self.selectUserTypeVM.customerIsSelected
                    )
                })
                
                Spacer()
            }
            .padding(.top, 10)
            .navigationBarTitle("Select user type")
            .navigationBarItems(
                leading:
                Button(action: {
                    let logoutError = self.authAPI.logout()
                    if logoutError == nil {
                        self.appState.userData = nil
                        self.appState.loginDestination = .firebaseAuthentication
                    } else {
                        // Display popup indicating logout unsuccessful
                    }
                }, label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                        .padding(10.0)
                }),
                trailing:
                Button(action: {
                    
                    if self.selectUserTypeVM.dogSitterIsSelected {
                        self.appState.userData?.userType = .dogsitter
                    }
                    
                    if self.selectUserTypeVM.customerIsSelected {
                        self.appState.userData?.userType = .customer
                    }
                    
                    if self.appState.userData?.userType != nil {
                        
                        self.selectUserTypeVM.saveUserType(appStateUserData: self.appState.userData!) { result in
                            switch result {
                            case .success(let userType):
                                self.appState.userData?.userType = userType
                                self.appState.loginDestination = .userOnboarding
                            case .failure(let validationError):
                                // TODO: Notify user that user_type selection not successful
                                print("validationError:", validationError)
                            }
                        }
                    }
                }, label: {
                    // TODO: Create a separate view for this Save button
                    Text("Next")
                        .underline()
                        .bold()
                        .foregroundColor(.primary)
                })
            )
            
        }
        
    }
}

struct SelectUserTypeView_Previews: PreviewProvider {
    static var previews: some View {
        SelectUserTypeView()
    }
}
