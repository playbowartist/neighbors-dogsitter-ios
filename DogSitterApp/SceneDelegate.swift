//
//  SceneDelegate.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/1/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import UIKit
import SwiftUI
import FirebaseAuthUI
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate, FUIAuthDelegate {

    var window: UIWindow?
    let authUI = FUIAuth.defaultAuthUI()!
    
    var appState: AppState = AppState()
    var recordingListVM = RecordingListViewModel()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        // If appState already set by AppDelegate via incoming notification, then assign to SceneDelegate
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            self.appState = appDelegate.appState
        }
        
        if let currentUser = Auth.auth().currentUser {
            // TODO: Check that db profile exists AND completed_onboarding flag is true
            // Write db code in new FirestoreAPI file, like getProfile, depending on client or dogsitter
            
            let firebaseID = currentUser.uid
            
            FirestoreAPI.getUserType(firebaseID: firebaseID) { (userData) in
                guard let userTypeData = userData,
                    let userType = userTypeData.userType,
                    let city = userTypeData.city else { return }
                
                // TODO: Move the userData assignments into FirestoreAPI.getProfile, to remove 4 lines from below
                FirestoreAPI.getProfile(firebaseID: firebaseID, userType: userType, city: city) { (userData) in
                    guard var userData = userData else { return }
                    
                    userData.userType = userType
                    userData.city = city
                    userData.user_id = firebaseID
                    userData.phone_number = currentUser.phoneNumber
                    self.appState.userData = userData
                    
                    if let completedOnboarding = userData.completed_onboarding,
                        completedOnboarding == true {
                        DispatchQueue.main.async {
                            self.appState.loginDestination = .mainTabView
                        }
                    }
                }
            }
        }

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: RootView(recordingListVM: self.recordingListVM).environmentObject(self.appState))
            self.window = window
            window.makeKeyAndVisible()
        }
        
        // Storing firebaseUser in appState
        Auth.auth().addStateDidChangeListener { (auth, user) in
            self.appState.firebaseUser = user
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
//        print("SceneDidEnterBackground -- about to schedule background task")
        // Schedule a new refresh task
//        (UIApplication.shared.delegate as! AppDelegate).scheduleBackgroundFetch()
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        print("inside scene openUrlContexts")
        
        for context in URLContexts {
          print("url: \(context.url.absoluteURL)")
          print("scheme: \(context.url.scheme)")
          print("host: \(context.url.host)")
          print("path: \(context.url.path)")
          print("components: \(context.url.pathComponents)")
        }
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        print("\ninside scene continue userActivity\n")
        
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
          let urlToOpen = userActivity.webpageURL else {
            return
        }

        
        let urlString = urlToOpen.absoluteString
        let cleanString = urlString.removingPercentEncoding!
        let cleanUrl = URL(string: cleanString)!
        print("cleanUrl inside continue userActivity: ", cleanUrl)
        
        myhandleOpenUrl(url: cleanUrl, sourceApplication: Bundle.main.bundleIdentifier)
    }
    
    func myhandleOpenUrl(url: URL, sourceApplication: String?) {
        
        let emailLink = url.absoluteString
        
        var urlComponents = URLComponents(string: emailLink)!
        var continueUrlString: String?
        
        for queryItem in urlComponents.queryItems! {
            if queryItem.name == "continueUrl" {
                continueUrlString = queryItem.value
            }
        }
        print("\nfinal continueUrl: ", continueUrlString)

        var urlParamDict = [String: String]()
        var continueUrlComponents = URLComponents(string: continueUrlString!)!
        
        for queryItem in continueUrlComponents.queryItems! {
            urlParamDict[queryItem.name] = queryItem.value
            print("key: ", queryItem.name, " value: ", queryItem.value)
        }
        
        let savedEmail = UserDefaults.standard.string(forKey: "FIRAuthEmailLinkSignInEmail")
        let savedUI_sid = UserDefaults.standard.string(forKey: "ui_sid")
        print("\nsavedEmail: ", savedEmail)
        print("\nsavedui_sid: ", savedUI_sid)
        
        let credential = EmailAuthProvider.credential(withEmail: savedEmail!, link: emailLink)

        self.authUI.auth?.signIn(with: credential) { (authDataResult, error) in
            
            if let error = error {
                print("\nerror: ", error)
                DispatchQueue.main.async {
                    self.authUI.invokeResultCallback(with: authDataResult, url: nil, error: error)
                }
            }
            
            if let authDataResult = authDataResult {
                print("\nauthDataResult: ", authDataResult)
                DispatchQueue.main.async {
                    self.authUI.invokeResultCallback(with: authDataResult, url: nil, error: error)
                }
            }
        }
    }
    
}

