fastlane documentation
================
# Installation
```
sudo gem install fastlane
```
# Available Actions
### xcode
```
fastlane xcode
```
Setup xCode - Removes Fix Button
### downloadDevProfiles
```
fastlane downloadDevProfiles
```
Download Development profiles
### updateDevProfiles
```
fastlane updateDevProfiles
```
Update Development profiles (Requires Write Peremission to Apple Developer Account)
### downloadLiveProfiles
```
fastlane downloadLiveProfiles
```
Download Enterprise (QA & Live) profiles
### updateLiveProfiles
```
fastlane updateLiveProfiles
```
Update Enterprise (QA & Live) profiles (Requires Write Peremission to Apple Developer Account)
### createEntApplication
```
fastlane createEntApplication
```
Create Enterprise Application
### createStoreApplication
```
fastlane createStoreApplication
```
Create Store Application
### downloadStoreProfiles
```
fastlane downloadStoreProfiles
```
Download Store profiles
### updateStoreProfiles
```
fastlane updateStoreProfiles
```
Update Store profiles (Requires Write Peremission to Apple Developer Account)
### documentation
```
fastlane documentation
```
Generate Apple Style Documentation
### jenkins
```
fastlane jenkins
```
Jenkins Unit Test, Appium Test and Run Sonar Report (Non-Swift Projects)
### jenkins_swift
```
fastlane jenkins_swift
```
Jenkins Unit Test, Appium Test and Run Sonar Report (Swift Projects)
### test_unit
```
fastlane test_unit
```
Build Application and Run Unit Tests
### test_build_appium
```
fastlane test_build_appium
```
Build then run Appium Tests
### test_appium_simulator
```
fastlane test_appium_simulator
```
Run Appium Tests against previously built binary on simulator
### test_api
```
fastlane test_api
```
Run API Tests
### code_analysis_swift_fastlane
```
fastlane code_analysis_swift_fastlane
```
Run Static Code Analysis on Swift Codebase using fastlane actions
### code_analysis_swift
```
fastlane code_analysis_swift
```
Run Static Code Analysis on Swift Codebase
### code_analysis
```
fastlane code_analysis
```
Run Static Code Analysis
### test_appium_aws_device
```
fastlane test_appium_aws_device
```
Build ipa and run tests on AWS Device Farm (PAID SERVICE)
### build_dev_qa
```
fastlane build_dev_qa
```
Build and Distribute DEV-QA  (via Crashlytics) 
### build_live_qa
```
fastlane build_live_qa
```
Build and Distribute LIVE-QA  (via Crashlytics) 
### build_store
```
fastlane build_store
```
Build STORE and UPLOAD to TestFlight

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [https://fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [https://docs.fastlane.tools](https://docs.fastlane.tools).
