#!/bin/bash

./sample.sh

exitCode=$?
PID_sample=$!

if [ $exitCode=0 ]; then
	echo "Job was successfull"
else
	echo "Job failed with ExitCocde $exitCode"

fi
