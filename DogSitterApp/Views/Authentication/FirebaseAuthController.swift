//
//  FirebaseAuthController.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 6/19/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import UIKit
import SwiftUI
import Firebase
import FirebaseAuthUI
import FirebaseAuth
//import FirebaseInstanceID
//import FirebaseFirestoreSwift
import FirebaseMessaging
import FirebaseInstallations
import FirebasePhoneAuthUI

protocol AuthenticationProtocol {
    
    func logout() -> Error?
}

class AuthenticationAPI: AuthenticationProtocol {
    
    let authUI = FUIAuth.defaultAuthUI()!
    
    func logout() -> Error? {
        
        do {
            try authUI.signOut()
        } catch {
            print("signOut error:", error)
            return error
        }
        return nil
    }
    
}

class FirebaseAuthViewModel: ObservableObject {
    @Published var loginComplete: Bool = false
}

struct FirebaseAuthView: View {
    
    @EnvironmentObject var appState: AppState
    @ObservedObject var firebaseAuthViewModel: FirebaseAuthViewModel
    var firebaseAuthController: FirebaseAuthController!

    init() {
        let tempVM = FirebaseAuthViewModel()
        self.firebaseAuthViewModel = tempVM
        self.firebaseAuthController = FirebaseAuthController(firebaseAuthViewModel: tempVM)
    }
    
    var body: some View {
        
        VStack {
            firebaseAuthController
        }
        .background(Image("neighborhood"), alignment: .trailing)
        .edgesIgnoringSafeArea(.all)
    }
    
    func handleOpen(url: URL, sourceApplication: String?) {
        firebaseAuthController.handleOpen(url: url, sourceApplication: sourceApplication)
    }
}

struct FirebaseAuthController: UIViewControllerRepresentable {
    
    @EnvironmentObject var appState: AppState
    var firebaseAuthViewModel: FirebaseAuthViewModel
    
    let authUI = FUIAuth.defaultAuthUI()!
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UINavigationController {
        
        print("\ninside makeUIViewController\n")
        authUI.delegate = context.coordinator
        
        // Don't forget to set Associated Domains
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://playbowdogs.page.link")
        
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        actionCodeSettings.setAndroidPackageName("com.playbowdogs.neighbors.android", installIfNotAvailable: true, minimumVersion: "12")
        
        let whiteListedCountries: Set = ["US"]
        let providers: [FUIAuthProvider] = [
//            FUIEmailAuth(authAuthUI: FUIAuth.defaultAuthUI()!,
//                         signInMethod: EmailLinkAuthSignInMethod,
//                         forceSameDevice: false,
//                         allowNewEmailAccounts: true,
//                         actionCodeSetting: actionCodeSettings),
            FUIPhoneAuth(authUI: authUI, whitelistedCountries: whiteListedCountries),
//            FUIPhoneAuth(authUI: authUI),
//            FUIOAuth.microsoftAuthProvider(),
//            FUIGoogleAuth(),
        ]
        authUI.providers = providers
        authUI.shouldHideCancelButton = true
        
        let authViewController = authUI.authViewController()
        return authViewController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) { }
    
    
    func handleOpen(url: URL, sourceApplication: String?) {
        self.authUI.handleOpen(url, sourceApplication: sourceApplication)
    }
}

class FUICustomAuthPickerViewController: FUIAuthPickerViewController {
    
    // viewWillAppear works better than viewDidLoad for changing navigationBar components
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.tintColor = UIColor.label
    }
}

class Coordinator: NSObject, FUIAuthDelegate {
    
    var parent: FirebaseAuthController
    
    init(_ firebaseAuthController: FirebaseAuthController) {
        self.parent = firebaseAuthController
    }
    
    // Provide custom auth picker controller with UI changes
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        return FUICustomAuthPickerViewController(nibName: nil, bundle: Bundle.main, authUI: self.parent.authUI)
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        print("inside didSignInWith authDataResult")
        self.parent.appState.userData = UserData()
        
        // Retrieve fcm_token and save in userData
        Messaging.messaging().token { (result, error) in
            if let error = error {
                print("\nError fetching fcmToken inside didSignInWith: \(error)\n")
            }
            else if let result = result {
                print("FCM registration token: \(result)\n")
                self.parent.appState.userData?.fcm_token = result
            }
        }
        
        guard let firebaseID = authDataResult?.user.uid else { return }
        guard let phoneNumber = authDataResult?.user.phoneNumber else { return }
        print("phoneNumber from Firebase auth:", phoneNumber)
        print("\nFinished auth process -- returned user UID: \(firebaseID)")
        
        self.parent.appState.userData?.user_id = firebaseID
        self.parent.appState.userData?.phone_number = phoneNumber
        
        // Check whether userType is stored in Firestore first
        FirestoreAPI.getUserType(firebaseID: firebaseID) { (userData) in
            // If no userType returned, then take to onboarding, else check for Profile
            guard let userTypeData = userData,
                let userType = userTypeData.userType,
                let city = userTypeData.city else {
                    print("\nUserType not found, so send to selectUserType / onboarding")
                    self.parent.appState.loginDestination = .selectUserType
                    return
            }
            
            // Retrieve fcm_token and save in Firestore profile
            Messaging.messaging().token { (result, error) in
                guard let result = result else { return }
                print("FCM registration token to save in Firestore profile: \(result)\n")
                self.parent.appState.userData?.fcm_token = result
                
                // TODO: Check that saveFcmToken is successful before getProfile
                FirestoreAPI.saveFcmToken(fcmToken: result, firebaseID: firebaseID, userType: userType, city: city) {
                    
                    FirestoreAPI.getProfile(firebaseID: firebaseID, userType: userType, city: city) { (userData) in
                        guard var userData = userData else {
                            print("\nProfile does not exist, so send to selectUserType / onboarding")
                            self.parent.appState.loginDestination = .selectUserType
                            return
                        }
                        
                        userData.userType = userType
                        userData.city = city
                        userData.user_id = firebaseID
                        userData.phone_number = phoneNumber
                        self.parent.appState.userData = userData
                        
                        // Check completed_onboarding flag is true
                        if let completedOnboarding = userData.completed_onboarding,
                            completedOnboarding == true {
                            self.parent.appState.loginDestination = .mainTabView
                        } else {
                            print("\nUser document exists, but onboarding not complete, so send user to selectUserType / complete onboarding")
                            self.parent.appState.loginDestination = .selectUserType
                        }
                    }
                }
            }
        }
    }
}

