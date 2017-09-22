#!/usr/bin/env bash
brew install jq

# DEVICE SETTINGS
DEVICE="=iPhone 6s (9.3) ["
VERSION=9.3

# SET JAVA HOME TO BE JAVA 8
export JAVA_HOME=$JAVA8_HOME

WORKSPACE=`pwd`

# DETERMINE WHERE THE .app File is 
find /tmp/sandbox/${BUDDYBUILD_APP_ID} -name *.app -print
export APP=$(find /tmp/sandbox/${BUDDYBUILD_APP_ID} -name *.app | head -1)
echo "== APP LOCATION ${APP}"

# CARRY OUT APPIUM TESTS if We are in Test mode, and have a QA REPO Specified
if [ -d "${APP}" ] && [ "{QA_APPIUM_BRANCH}" != "" ]; then
	echo '=== TEST BUILD AVAILBALE - RUNNING ASSURANCE TESTS'

	echo '=== CHANGING DIRECTORY TO ROOT FOLDER'
	cd /Users/buddybuild/workspace

	echo '=== CLONE QA REPO'
	git clone ${QA_APPIUM_BRANCH} ../QA

	if [ ! -d "../QA" ]
	then
		echo "CLONE FAILED"
		exit 1
	fi

	echo '=== FOLDER LISTING POST BUILD'
	ls -1

	echo '=== Navigate to tests folder'
	cd ../QA

	echo '=== install maven'
	brew install maven

	#echo '=== Install latest appium'
	#npm install -g appium

	#echo '=== Install selenium-webdriver'
	#npm install wd

	#echo '=== Authorize simulator access'
	#echo password | sudo -S $(npm bin)/authorize_ios

	#echo '=== AVAILABLE SIMULATORS'
	#xcrun simctl list

	#sleep 15 && ./run_tests.sh . ${APP} MobileAcceptanceTestSuite iphone "${DEVICE}" ${VERSION}

	#status=$?
	#pkill -f appium
	#if [ $status -ne 0 ] 
	#then
	#	echo "=== APPIUM TESTS FAILED"
	#	exit 1
	#fi

	# ./run_tests.sh . "" APIAcceptanceTestSuite webapi
	#status=$?
	#if [ $status -ne 0 ] 
	#then
	#	echo "=== API TESTS FAILED"
	#	exit 1
	#fi

	#echo "=== TEST SUCCEEDED"

	echo '=== Build QA tests'
	mvn install -B -e

    IPA_NAME=MyMapp-$BUDDYBUILD_BRANCH-$BUDDYBUILD_SCHEME-$BUDDYBUILD_BUILD_NUMBER

	# UPLOAD RESULT TO AWS
	if [ "$AWS_S3_BUCKET" != "" ]
	then
		#echo '=== Upload results to s3'
		#aws s3 sync ./TestResults s3://$AWS_S3_BUCKET/iOS/AppiumResults/
		echo '== cp ipa to s3'    
        aws s3api put-object --bucket mymapp-appium-output-qa --key iOS/${BUDDYBUILD_BRANCH}/ipa/$IPA_NAME.ipa --body $BUDDYBUILD_IPA_PATH
		echo '== cp appium tests artifacts to s3'
		aws s3 sync ./target/ s3://$AWS_S3_BUCKET/iOS/${BUDDYBUILD_BRANCH}/appium_tests/
	else
		echo '=== NOT UPLOADED RESULTS TO AWS'
	fi
    
    # create the upload request
    #aws devicefarm create-upload –-project-arn $PROJECT_ARN -–name $APK_NAME -–type IOS_APP
    echo "===== Upload IPA"
    aws configure set default.region us-west-2
    APP_UPLOAD="$(aws devicefarm create-upload --project-arn $AWS_DEVICE_FARM_ARN --name $IPA_NAME.ipa --type IOS_APP | jq '.upload')"
    echo $APP_UPLOAD
    UPLOAD_URL="$(echo $APP_UPLOAD  | jq '.url')"
    UPLOAD_URL=${UPLOAD_URL//\"}

    echo $IPA_NAME
    echo $UPLOAD_URL

    curl -T $BUDDYBUILD_IPA_PATH $UPLOAD_URL --verbose --progress-bar


else 
        echo '=== TEST BUILD NOT AVAILABLE - NOT RUNNING ASSURANCE TESTS'
fi

# Upload to Crashlytics
if [ "$Crashlytics_API" != "" ]
then
	echo '=== Upload to Crashlytics'
	pwd
	cd $WORKSPACE
	git log -1 --pretty=%B > releaseNotes.txt
  	./Pods/Crashlytics/submit $Crashlytics_API $Crashlytics_SECRET -ipaPath $BUDDYBUILD_IPA_PATH -emails Tim.Walpole@bjss.com -groupAliases $Crashlytics_DIST_DEV_QA -notesPath ./releaseNotes.txt
fi

echo "=== SUCCEEDED"

# Uplad to AWS for Device Testin
#if [ "$FL_AWS_DEVICE_FARM_NAME" != "" ]
#then
#	echo '=== Uploading to AWS Device Farm for ON-DEVICE Testing'
#	cd QA
#	mvn clean package -DskipTests=true -B -e
#	cd ..
#	fastlane test_appium_aws_device
#else
#    echo '=== AWS Device Farm Name not set - Not Running ON-DEVICE Tests'
#fi

exit 0