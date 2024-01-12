# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'
# use_modular_headers!

#abstract_target 'App' do

# Shared pods between App and extensions
# pod '#1'
# pod '#2'

def google_utilites
  pod 'GoogleUtilities/AppDelegateSwizzler'
  pod 'GoogleUtilities/Environment'
  pod 'GoogleUtilities/ISASwizzler'
  pod 'GoogleUtilities/Logger'
  pod 'GoogleUtilities/MethodSwizzler'
  pod 'GoogleUtilities/NSData+zlib'
  pod 'GoogleUtilities/Network'
  pod 'GoogleUtilities/Reachability'
  pod 'GoogleUtilities/UserDefaults'
  pod 'GoogleUtilities'
  pod 'GTMSessionFetcher'
  pod 'FirebaseCore'
  pod 'FirebaseInstanceID'
  pod 'FirebaseMessaging'
end


target 'DogSitterApp' do
  # Comment the next line if you don't want to use dynamic frameworks
#  use_modular_headers!
#  use_frameworks!
  use_frameworks! :linkage => :static
#  google_utilites
  
  # Pods for DogSitterApp
  pod 'MobileVLCKit'
#  pod 'FirebaseAnalytics'
#  pod 'FirebaseAuth'
#  pod 'FirebaseUI'
#  pod 'FirebaseUI/Auth'
#  pod 'FirebaseUI/Email'
#  pod 'FirebaseUI/Google'
#  pod 'FirebaseUI/Phone'
#  pod 'FirebaseUI/OAuth'
#  pod 'FirebaseFirestore'
#  pod 'FirebaseFirestoreSwift'
#  pod 'FirebaseFunctions'
#  pod 'FirebaseStorage'
  pod 'HorizonCalendar'
end

target 'NotificationService' do
#  use_modular_headers!
#  use_frameworks!
  use_frameworks! :linkage => :static
#  google_utilites
  
end

target 'DogSitterAppTests' do
#  use_modular_headers!
#  inherit! :search_paths
  # Pods for testing
end

target 'DogSitterAppUITests' do
#  use_modular_headers!
  # Pods for testing
end

#end
