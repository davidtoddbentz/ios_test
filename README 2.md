## Synopsis

BJSS Base Project (iOS) is the recommended starting project for all BJSS base projects.  It incldues the ability to easily configure the project using xcconfig files for different enviroments, and contains base code for common services.

## Installation
Download the project, and use a a base project.
Run **fastlane downloadDevProfiles** to download development profiles (Requires Encryption Password)
Run **fastlane downloadLiveProfiles** to download QA profiles (Requires Encryption Password)

Develpment Profile Certificate Encryption password is **BJSSCertsDev**
Live Profile Certificate Encryption password is **BJSSCertsLive**

## Local Build & Test (Including for Jenkins)
Ensure the following are installed

Application | Installation
----------- | ------------
**xCode** | Latest Version from Apple App Store
**xCode Command lint Tools** | **Terminal:** xcode-select --install
**Node** | brew install node
**Maven** | brew install maven
**Appium** | npm install -g appium@1.5.3
**Appium Doctor** | npm install -g appium-doctor
**Fastlane** | sudo gem install fastlane 
**Selenium Web Driver** | npm install wd 
**AWS SDK** | gem install aws-sdk
**AWS Command Line** | brew install awscli
**Cocoapods** | gem install cocoapods

* Download the appropriate Assurance Project
* Set Environment Variable **QA_BASE**, or set in **.env** file in projects root folder.  (Defaults to ../QA)* 
* Run Testing Locally using Fastlane

Command | Description
----------- | -------------- 
	fastlane | Shows all possible Lanes
    fastlane **downloadDevProfiles** | Download Development profiles  
    fastlane **updateDevProfiles** | Update Development profiles  
    fastlane **downloadLiveProfiles** | Download Enterprise (QA & Live) profiles 
    fastlane **updateLiveProfiles** | Update Enterprise (QA & Live) profiles 
    fastlane **documentation** | Generate Apple Style Documentation  
	fastlane **jenkins** |	Jenkins Unit Test, Appium Test and Run Sonar Report (Non-Swift Projects)
	fastlane **jenkins_swift** | Jenkins Unit Test, Appium Test and Run Sonar Report (Swift Projects) 
	faslane **test_unit** | Build Application and Run Unit Tests 
fastlane **test_build_appium**  | Build then run Appium Tests    
fastlane  **test_appium_simulator** | Run Appium Tests using previous build
fastlane **test_api** | Run API Tests
fastlane **code_analysis_swift_fastlane** | Run Static Code Analysis on Swift Codebase using fastlane actions
fastlane **code_analysis_swift** | Run Static Code Analysis on Swift Codebase 
fastlane **code_analysis** | Run Static Code Analysis  
fastlane **test_appium_aws_device** | Build ipa and run tests on AWS Device Farm (PAID SERVICE)
fastlane **build_dev_qa** | Build and Distribute DEV-QA  (via Crashlytics)
fastlane **build_live_qa** | Build and Distribute LIVE-QA  (via Crashlytics)
   

 **Crash Reporting Upload**
    
Variable | Details
-------- | ------
	**Crashlytics_API** |  Crashlytics API Key
	**Crashlytics_SECRET** |  Crashlytics Secret
	**Crashlytics_DIST_DEV_QA** | Crashlytics Beta Distrubition Group (Dev QA)
	**Crashlytics_DIST_LIVE_QA** | Crashlytics Beta Distribution Group (Live QA)
	
 **AWS Environment Variables**
 
 Variable | Detail
 -------- | ------
	**AWS_ACCESS_KEY_ID** | AWS_ACCESS_KEY
    **AWS_SECRET_ACCESS_KEY** | AWS_SECRET_ACCESS_KEY
    **FL_AWS_DEVICE_FARM_NAME** | Name of Device Farm Project
    **FL_AWS_DEVICE_FARM_POOL** | Device Pool to Test Against


## Build in the cloud (BuddyBuild)
    
Buddybuild files (buddybuild_postbuild.sh) included in the project to carry out the following tasks

* Distribute Build to Crashlytics
* Execute Appium QA Tests (Simulator) 
* Execute Appium QA Tests on AWS Device Farm (Real Device)

	**Environment Variables required**
    
	Variable | Detail
	-------- | ------
	QA_BASE | Relative directory to QA Project (Defaults to ../QA)
	MATCH_PASSWORD_DEV | Encryption Password for Development Certificates
	MATCH_PASSWORD_LIVE | Encryption Password for Live Certificates
	
    **Crash Reporting Upload**
    
    Variable | Detail
	-------- | ------
	**Crashlytics_API** |  Crashlytics API Key
	**Crashlytics_SECRET** |  Crashlytics Secret
	**Crashlytics_DIST_DEV_QA** | Crashlytics Beta Distrubition Group 
    
    **APPIUM QA Tests (Simulator)**
    
    Variable | Detail
	-------- | ------
	**QA_APPIUM_BRANCH** | Repo for the Appium QA Tests 
	|**eg** -b develop git@github.com:bjss/BJSS_MobileBase_Project_QA.git)
        
    **AWS**
    
	Variable | Detail
	-------- | ------
	**AWS_ACCESS_KEY_ID** | AWS_ACCESS_KEY
    **AWS_SECRET_ACCESS_KEY** | AWS_SECRET_ACCESS_KEY
    **FL_AWS_DEVICE_FARM_NAME** | Name of Device Farm Project
    **FL_AWS_DEVICE_FARM_POOL** | Device Pool to Test Against
    **AWS_S3_BUCKET** | AWS S3 Bucket for QA Test Results (Simulator)

## API 

Amazon AWS Links.

## Tests

Unit Tests Included for both BDD Style (Quick & Nimble) and XCTest.

## Contributors

BJSS




