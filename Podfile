# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'FASHION' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FASHION

  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  pod 'FirebaseUI/Storage'
  pod 'Alamofire', '~> 5.2'
  pod 'SwiftyJSON', '~> 4.0'
  pod 'Firebase/Auth'
  pod 'DropDown'

  target 'FASHIONTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'FASHIONUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end
