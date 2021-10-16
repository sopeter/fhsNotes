source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target 'fhsNotes' do
pod 'JTAppleCalendar', '~> 7.0'
pod 'Kanna', '~> 4.0.0'
pod 'Alamofire', '~> 5.0.0-beta.3'
pod 'GoogleSignIn', '~> 4.4.0'
pod 'Firebase/Core'
pod 'Firebase/Auth'
pod 'GoogleSignIn'
pod 'Firebase/Database'
pod 'Firebase/Firestore'
pod 'Firebase/Analytics'
pod 'FirebaseFirestoreSwift'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end

end
