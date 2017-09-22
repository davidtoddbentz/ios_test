#!/usr/bin/env bash

# Get QA Dir
QA_DIR=$1

echo "=== QA LOCATION ${QA_LOCATION}"

echo '=== Navigate to tests folder'
cd ${QA_DIR}

./run_tests.sh . "" APIAcceptanceTestSuite webapi 
status=$?
if [ $status -ne 0 ] 
then
	echo "=== TESTS FAILED"
	exit 1
fi

