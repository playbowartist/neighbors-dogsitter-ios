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
import FirebaseUI
import FirebaseAuth

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
    
    @EnvironmentObject var userSettings: UserSettings
    @ObservedObject var firebaseAuthViewModel: FirebaseAuthViewModel
    var firebaseAuthController: FirebaseAuthController!
    
    init() {
        let tempVM = FirebaseAuthViewModel()
        self.firebaseAuthViewModel = tempVM
        self.firebaseAuthController = FirebaseAuthController(firebaseAuthViewModel: tempVM)
    }
    
    var body: some View {
        
        VStack {
            if userSettings.isLoggedIn {
                CameraControlView()
            } else {
                ZStack {
                    firebaseAuthController
                }
                .background(Image("neighborhood"), alignment: .trailing)
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
    
    func handleOpen(url: URL, sourceApplication: String?) {
        firebaseAuthController.handleOpen(url: url, sourceApplication: sourceApplication)
    }
}

struct FirebaseAuthController: UIViewControllerRepresentable {
    
    @EnvironmentObject var userSettings: UserSettings
    var firebaseAuthViewModel: FirebaseAuthViewModel
    
    let authUI = FUIAuth.defaultAuthUI()!
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UINavigationController {
        print("\ninside makeUIViewController\n")
//        FirebaseApp.configure()
        
//        let authUI = FUIAuth.defaultAuthUI()!
        authUI.delegate = context.coordinator
        
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://dogsitterapp.page.link/Tbeh")
        
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        actionCodeSettings.setAndroidPackageName("com.firebase.example", installIfNotAvailable: false, minimumVersion: "12")
        
        
        
        let providers: [FUIAuthProvider] = [
            FUIEmailAuth(authAuthUI: FUIAuth.defaultAuthUI()!,
                         signInMethod: EmailLinkAuthSignInMethod,
                         forceSameDevice: false,
                         allowNewEmailAccounts: true,
                         actionCodeSetting: actionCodeSettings),
            FUIPhoneAuth(authUI: authUI),
            FUIOAuth.microsoftAuthProvider(),
            FUIGoogleAuth(),
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
        
//        self.view.addBackground(image: UIImage(named: "neighborhood")!)
//        UIApplication.shared.statusBarUIView?.backgroundColor = UIColor.lightGray
        
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
        print("\nFinished auth process -- returned user.email:", authDataResult?.user.email)
        
        if authDataResult != nil {
            withAnimation(.linear(duration: 1.0)) {
                self.parent.userSettings.isLoggedIn = true
            }
        }
    }
}

extension UIView {
    func addBackground(image: UIImage) {
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewBackground.image = image
        imageViewBackground.contentMode = UIView.ContentMode.left
        
        self.addSubview(imageViewBackground)
        self.sendSubviewToBack(imageViewBackground)
    }
}

// Allows accessing top status bar to change its background color
//extension UIApplication {
//    var statusBarUIView: UIView? {
//        
//        if #available(iOS 13.0, *) {
//            let tag = 3848245
//            
//            let keyWindow = UIApplication.shared.connectedScenes
//                .map({$0 as? UIWindowScene})
//                .compactMap({$0})
//                .first?.windows.first
//            
//            if let statusBar = keyWindow?.viewWithTag(tag) {
//                return statusBar
//            } else {
//                let height = keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
//                let statusBarView = UIView(frame: height)
//                statusBarView.tag = tag
//                statusBarView.layer.zPosition = 999999
//                
//                keyWindow?.addSubview(statusBarView)
//                return statusBarView
//            }
//            
//        }
//        return nil
//    }
//}


