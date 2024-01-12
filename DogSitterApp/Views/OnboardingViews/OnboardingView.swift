//
//  OnboardingView.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 7/14/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import SwiftUI
import Combine
import FirebaseFirestore

// TODO:
// Add back button that brings back to Firebase Login screen
struct OnboardingView: View {
    
    @EnvironmentObject var appState: AppState
    @ObservedObject var onboardingVM = OnboardingViewModel()
    @State var phoneNumber = ""
    @State var showAlert = false
    @State var alertText = ""
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    
                    LabelTextField(inputText: $onboardingVM.first_name, label: "First name", placeholder: "Enter first name")
                        .padding(.top)
                    
                    LabelTextField(inputText: $onboardingVM.last_name, label: "Last name", placeholder: "Enter last name")

                    LabelTextField(inputText: $onboardingVM.email, label: "Email", placeholder: "Enter email")
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)

                    // Phone number must be pre-filled from Firebase auth, or else this screen will crash
                    LabelTextField(inputText: $phoneNumber, label: "Phone", placeholder: "")
                        .disabled(true)

//                    LabelTextField(inputText: $onboardingVM.email, label: "City", placeholder: "e.g. San Francisco")
//                    LabelTextField(inputText: $onboardingVM.email, label: "State", placeholder: "e.g. CA")
//                    LabelTextField(inputText: $onboardingVM.email, label: "Zip code", placeholder: "e.g. 94105")
//                        .keyboardType(.numberPad)
                    
                }
            }
            .keyboardAdaptive()
            .padding(.top)
            .navigationBarTitle("Complete profile")
            .navigationBarItems(
                leading:
                Button(action: {
                    self.appState.loginDestination = .selectUserType
                }, label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                        .padding(10.0)
                }),
                trailing:
                Button(action: {
                    if self.appState.userData != nil {
                        self.onboardingVM.saveUserInput(appStateUserData: self.appState.userData!) { result in
                            switch result {
                            case .success(_):
                                self.appState.loginDestination = .mainTabView
                            case .failure(let validationError):
                                switch validationError {
                                case .nameError:
                                    self.alertText = "Sorry, we cannot find your name in our records."
                                case .emailError:
                                    self.alertText = "Sorry, we cannot find your email in our records."
                                case .phoneError:
                                    self.alertText = "Sorry, we cannot find your phone number in our records"
                                default:
                                    self.alertText = "Sorry, we are unable to complete your sign in."
                                }
                                self.showAlert.toggle()
                                print("validationError:", validationError)
                            }
                        }
                    }
                    
                }, label: {
                    // TODO: Create a separate view for this Save button
                    Text("Save")
                        .underline()
                        .bold()
                        .foregroundColor(.primary)
                })
                    .alert(isPresented: $showAlert, content: { () -> Alert in
                        Alert(title: Text("Neighbors App"),
                              message: Text(self.alertText))
                        
                    })
            )
        }
        .onAppear() {
            if let phoneNumber = self.appState.userData?.phone_number,
                let formattedPhoneNumber = InputValidation.format(phoneNumber: phoneNumber) {
                self.phoneNumber = formattedPhoneNumber
            }
        }
    }
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
