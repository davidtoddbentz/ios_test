ENV["COCOAPODS_DISABLE_STATS"] = "1"

# Targets
testUITargetName                                                                = 'MyMappUITests'
testTargetName                                                                  = 'MyMappTests'
mainTargetName                                                                  = 'MyMapp'
watchTargetName                                                                 = 'MyMappWatch'
watchExtensionTargetName                                                        = 'MyMappWatch Extension'

use_frameworks!

# Define Shared Pods Here
def shared_pods

end

target "#{mainTargetName}" do
  platform :ios, '9.0'
  
  pod 'ApiAI'
  pod 'NMessenger'
  pod 'SDWebImage', '~>3.8'
  pod 'Cartography'
  pod 'ZLSwipeableViewSwift', git: 'https://github.com/zhxnlai/ZLSwipeableViewSwift.git', branch: 'swift3'
  pod 'ImagePicker'
  pod 'IQKeyboardManagerSwift'
  pod 'JSQMessagesViewController'
  
  # Networking - AlamoFire
  pod 'Alamofire', '~> 4.0'
  
  # Twitter
  pod 'TwitterKit'
  
  # Facebook
  pod 'Bolts'
  pod 'FacebookCore', '~> 0.2'
  pod 'FacebookLogin', '~> 0.2'
  pod 'FacebookShare', '~> 0.2'
  pod 'FBSDKCoreKit', '~> 4.22.1'
  pod 'FBSDKLoginKit', '~> 4.22.1'
  pod 'FBSDKShareKit', '~> 4.22.1'
  
  # Firebase
  pod 'Firebase'
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Auth'
  pod 'Firebase/Storage'
  
  # Fabric
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'BuddyBuildSDK', :configurations => ['DEV-Developer', 'LIVE-Developer', 'DEV-QA', 'LIVE-QA']
  shared_pods
end

target "#{testTargetName}" do
  # Standard Swift Testing Frameworks
  pod 'Quick', :git => 'https://github.com/Quick/Quick.git', :branch => 'master'
  pod 'Nimble', :git => 'https://github.com/Quick/Nimble.git', :branch => 'master'
end

#target "#{testUITargetName}" do
#  pod 'Quick'
#  pod 'Nimble'
#end

#target "#{watchTargetName}" do
#  
#end

#target "#{watchExtensionTargetName}" do
#  platform :watchos, '2.0'
#  shared_pods
#end

# Post Install to Patch Files to Allow Merged Configuration Files
post_install do |installer|
  puts "Running post install hooks"
  puts "START Patching Pods xcconfig files"
  workDir = Dir.pwd
  
  # Note: Cocoapods generates its own {target.name}.{config.name}.xcconfig files whose settings need to be merged back in with
  # our own custom xcconfig files. Because Cocoapods doesn't currently support xcconfig merging, we work around this issue
  # by taking each pod-generated file and prefixing each setting within it with "PODS_CUSTOM_". We can then #include the pod-generated file
  # within our own custom xcconfig (and refer to any PODS_CUSTOM_<setting> values from there).
  
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
      config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
      config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
      config.build_settings['SWIFT_VERSION'] = '3.0'
      config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'NO'
      config.build_settings['EMBEDDED_CONTENT_CONTAINS_SWIFT'] = 'NO'
      
      if (target.name == "Pods-#{mainTargetName}" || target.name == "Pods-#{testTargetName}" || target.name == "Pods-#{testUITargetName}")
        puts "Patching settings in #{target.name}.#{config.name}.xcconfig"
        xcconfigFilename = "#{workDir}/Pods/Target Support Files/#{target.name}/#{target.name}.#{config.name.downcase}.xcconfig"
        xcconfig = File.read(xcconfigFilename)
        
        newXcconfig = xcconfig.gsub(/^FRAMEWORK_SEARCH_PATHS/, "PODS_CUSTOM_FRAMEWORK_SEARCH_PATHS")
        newXcconfig = newXcconfig.gsub(/^HEADER_SEARCH_PATHS/, "PODS_CUSTOM_HEADER_SEARCH_PATHS")
        newXcconfig = newXcconfig.gsub(/^LIBRARY_SEARCH_PATHS/, "PODS_CUSTOM_LIBRARY_SEARCH_PATHS")
        newXcconfig = newXcconfig.gsub(/^OTHER_LDFLAGS/, "PODS_CUSTOM_OTHER_LDFLAGS")
        newXcconfig = newXcconfig.gsub(/^OTHER_CFLAGS/, "PODS_CUSTOM_OTHER_CFLAGS")
        newXcconfig = newXcconfig.gsub(/^GCC_PREPROCESSOR_DEFINITIONS/, "PODS_CUSTOM_GCC_PREPROCESSOR_DEFINITIONS")
        File.open(xcconfigFilename, "w") { |file| file << newXcconfig }
      end
    end
  end
  
  puts "END Patching Pods xcconfig files"
  
  puts "\n\n*********************************************************************************************************************"
  puts "N.B. After running 'pod install', you may ignore any integration warnings you may see regarding TEST .xcconfig files"
  puts "*********************************************************************************************************************\n\n"
end


