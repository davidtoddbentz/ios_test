#!/usr/bin/env bash

# Get QA Dir
QA_DIR=$1
APP_LOCATION=$2

# DEVICE SETTINGS
DEVICE="=iPhone 6s (9.3) ["
VERSION=9.3

echo "=== APP LOCATION ${APP_LOCATION}"
echo "=== QA LOCATION ${QA_LOCATION}"
echo "=== DEVICE ${DEVICE}"
echo "=== VERSION ${VERSION}"

echo '=== Navigate to tests folder'
cd ${QA_DIR}

echo '=== AVAILABLE SIMULATORS'
xcrun simctl list

sleep 15 && ./run_tests.sh . ${APP_LOCATION} MobileAcceptanceTestSuite iphone "${DEVICE}" ${VERSION} -f all
status=$?
pkill -f appium
if [ $status -ne 0 ] 
then
	echo "=== TESTS FAILED"
	exit 1
fi

