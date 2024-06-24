#!/bin/bash
## This script is to run process_price_feed.sh job for different environments seperately
##/digital-batch/qa/scripts/process_price_feed.sh <qa1,qa2,qa3,prod> (this will load price in express_pay too)
##Data will be  there at /digital-batch-data/qa/incoming/sap/price
## /digital-batch-data/qa/incoming/sap/price/MASTER/QA1-6
## Ran for 10 mins cuz Qa4 took 9 mins
####################################################################################
# Send email Function 
# Function call  from setEnv.sh
# Arg_1 = Email Message Content
# Arg_2 = Email Subject
# Arg_3 = Email recepient
####################################################################################


 

FILE_PATH="/digital-batch-data/qa/incoming/sap"
SCRIPT_PATH="/digital-batch/qa/scripts"
LOG_PATH="/digital-batch-data/qa/logs/sap"
JOB_NAME="Price feed processing"


# source the environment variable and functions scripts
binDir=`dirname $0`
. $binDir/setEnv.sh

echo "Copying Feed Files to Respective Env Directories"

cd ${FILE_PATH}/price/

echo "MASTER/QA1/ MASTER/QA2/ MASTER/QA3/ MASTER/QA4/ MASTER/QA5/ MASTER/QA6/ BACK_UP/" | xargs -n 1 cp -v WCSPrice_*

rm WCSPrice_*

echo "Feed Files copied to Respective Env Directories."


echo "Starting Job run for all Qa Envs"


echo "Starting Job run in Qa1"
nohup ${SCRIPT_PATH}/process_price_feed.sh qa1> ${LOG_PATH}/price/process_price_feed_hourly_qa1.`date +%Y%m%d%H`.log &
QA1_JOB_PROCESS_ID=$!
echo "pricefeedloadjob QA1 Process Id is : ${QA1_JOB_PROCESS_ID}"

echo "Starting Job run in Qa2"
nohup ${SCRIPT_PATH}/process_price_feed.sh qa2> ${LOG_PATH}/price/process_price_feed_hourly_qa2.`date +%Y%m%d%H`.log &
QA2_JOB_PROCESS_ID=$!
echo "pricefeedloadjob QA2 Process Id is : ${QA2_JOB_PROCESS_ID}"

echo "Starting Job run in Qa3"
nohup ${SCRIPT_PATH}/process_price_feed.sh qa3> ${LOG_PATH}/price/process_price_feed_hourly_qa3.`date +%Y%m%d%H`.log &
QA3_JOB_PROCESS_ID=$!
echo "pricefeedloadjob QA3 Process Id is : ${QA3_JOB_PROCESS_ID}"

echo "Starting Job run in Qa4"
nohup ${SCRIPT_PATH}/process_price_feed.sh qa4> ${LOG_PATH}/price/process_price_feed_hourly_qa4.`date +%Y%m%d%H`.log &
QA4_JOB_PROCESS_ID=$!
echo "pricefeedloadjob QA4 Process Id is : ${QA4_JOB_PROCESS_ID}"

echo "Starting Job run in Qa5"
nohup ${SCRIPT_PATH}/process_price_feed.sh qa5> ${LOG_PATH}/price/process_price_feed_hourly_qa5.`date +%Y%m%d%H`.log &
QA5_JOB_PROCESS_ID=$!
echo "pricefeedloadjob QA5 Process Id is : ${QA5_JOB_PROCESS_ID}"

echo "Starting Job run in Qa6"
nohup ${SCRIPT_PATH}/process_price_feed.sh qa6> ${LOG_PATH}/price/process_price_feed_hourly_qa6.`date +%Y%m%d%H`.log & 
QA6_JOB_PROCESS_ID=$!
echo "pricefeedloadjob QA6 Process Id is : ${QA6_JOB_PROCESS_ID}"

#sleep 300s

wait ${QA1_JOB_PROCESS_ID}
grep -w "COMPLETED" ${LOG_PATH}/price/process_price_feed_hourly_qa1.`date +%Y%m%d%H`.log 
grep -w "FAILED" ${LOG_PATH}/price/process_price_feed_hourly_qa1.`date +%Y%m%d%H`.log
E1=$(grep -w "FAILED" ${LOG_PATH}/price/process_price_feed_hourly_qa1.`date +%Y%m%d%H`.log | wc -l) 
echo "Price Load job completed in Qa1"

wait ${QA2_JOB_PROCESS_ID}
grep -w "COMPLETED" ${LOG_PATH}/price/process_price_feed_hourly_qa2.`date +%Y%m%d%H`.log 
grep -w "FAILED" ${LOG_PATH}/price/process_price_feed_hourly_qa2.`date +%Y%m%d%H`.log
E2=$(grep -w "FAILED" ${LOG_PATH}/price/process_price_feed_hourly_qa2.`date +%Y%m%d%H`.log | wc -l)
echo "Price Load job completed in Qa2"

wait ${QA3_JOB_PROCESS_ID}
grep -w "COMPLETED" ${LOG_PATH}/price/process_price_feed_hourly_qa3.`date +%Y%m%d%H`.log 
grep -w "FAILED" ${LOG_PATH}/price/process_price_feed_hourly_qa3.`date +%Y%m%d%H`.log
E3=$(grep -w "FAILED" ${LOG_PATH}/price/process_price_feed_hourly_qa3.`date +%Y%m%d%H`.log | wc -l)
echo "Price Load job completed in Qa3"

wait ${QA4_JOB_PROCESS_ID}
grep -w "COMPLETED" ${LOG_PATH}/price/process_price_feed_hourly_qa4.`date +%Y%m%d%H`.log 
grep -w "FAILED" ${LOG_PATH}/price/process_price_feed_hourly_qa4.`date +%Y%m%d%H`.log
E4=$(grep -w "FAILED" ${LOG_PATH}/price/process_price_feed_hourly_qa4.`date +%Y%m%d%H`.log | wc -l)
echo "Price Load job completed in Qa4"

wait ${QA5_JOB_PROCESS_ID}
grep -w "COMPLETED" ${LOG_PATH}/price/process_price_feed_hourly_qa5.`date +%Y%m%d%H`.log 
grep -w "FAILED" ${LOG_PATH}/price/process_price_feed_hourly_qa5.`date +%Y%m%d%H`.log
E5=$(grep -w "FAILED" ${LOG_PATH}/price/process_price_feed_hourly_qa5.`date +%Y%m%d%H`.log | wc -l)
echo "Price Load job completed in Qa5"

wait ${QA6_JOB_PROCESS_ID}
grep -w "COMPLETED" ${LOG_PATH}/price/process_price_feed_hourly_qa6.`date +%Y%m%d%H`.log 
grep -w "FAILED" ${LOG_PATH}/price/process_price_feed_hourly_qa6.`date +%Y%m%d%H`.log
E6=$(grep -w "FAILED" ${LOG_PATH}/price/process_price_feed_hourly_qa6.`date +%Y%m%d%H`.log | wc -l)
echo "Price Load job completed in Qa6"

echo "Job executed for all env"


Get_failed_env()
{
exit_codes=($E1 $E2 $E3 $E4 $E5 $E6)
qa_envs=("QA1" "QA2" "QA3" "Qa4" "Qa5" "QA6")
failed_env=()

for ((i=0;i<6; i++)); do
  if [ ${exit_codes[i]} -ne 0 ]; then
    failed_env=("${qa_envs[i]}")
    echo "${failed_env[@]}"
  fi
done
}

failed=$(Get_failed_env)
#echo ${failed}

ExitCode=$(( $E1 + $E2 + $E3 + $E4 + $E5 + $E6 ))

if [ ${ExitCode} -eq 0 ];then
        echo "The Exit Code is ${ExitCode}. Job ran successfully for all envs"
        exit 0

elif [ "${ExitCode}" -gt 3 ];then
        echo "The Exit Code is ${ExitCode}. The Job failed for  ${failed} environments"
        send_email " ==> Process_price_feed job failed for more than 3 environments namely ${failed} environments, while processing input files. Attention: Please check for log file at  following path ${LOG_PATH}/price/. " "Job ${JOB_NAME}/`basename $0` - Failed." "Digital-Environment@bjs.com" ;
        exit -1

else
        echo "The Exit Code is ${ExitCode}. The Job failed for  ${failed} environments"
        send_email " ==> Process_price_feed job failed for ${failed} environments while processing input files. Attention: Please check for log file at  following path ${LOG_PATH}/price/. " "Job ${JOB_NAME}/`basename $0` - Failed" "Digital-Environment@bjs.com" ;
        exit 0
fi