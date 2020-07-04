# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

abstract_target 'App' do
  
  # Shared pods between App and extensions
  # pod '#1'
  # pod '#2'
  
  target 'DogSitterApp' do
    # Comment the next line if you don't want to use dynamic frameworks
    use_frameworks!
    
    # Pods for DogSitterApp
    pod 'MobileVLCKit'
    pod 'Firebase/Analytics'
    pod 'Firebase/Auth'
    pod 'FirebaseUI/Auth'
    pod 'FirebaseUI/Email'
    pod 'FirebaseUI/Google'
    pod 'FirebaseUI/Phone'
    pod 'FirebaseUI/OAuth'
    pod 'FirebaseInstanceID'
#    pod 'Firebase/Messaging'
    pod 'Firebase/Firestore'
    pod 'FirebaseFirestoreSwift'
    pod 'Firebase/Functions'
  end
  
  target 'NotificationService' do
    use_frameworks!
    pod 'Firebase/Messaging'
  end
  
  target 'DogSitterAppTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  target 'DogSitterAppUITests' do
    # Pods for testing
  end
  
end
