#!/bin/bash
RESULT_DIR="/tests/series_curl/results"
LOG_FILE="series_result.csv"
LOG_PATH="$RESULT_DIR/$LOG_FILE"
MAX_TIME=50
STEP=5

if [ ! -d $RESULT_DIR ]; then
	mkdir $RESULT_DIR
fi

# make csv column
COL_ARR=("time[m]")
for ((i=0; i < $MAX_TIME; i+=$STEP)); do
	_I_START=$(( i + STEP ))
	COL_ARR+=("$i-$_I_START")
done
COL_JOIN=`(IFS=','; echo "${COL_ARR[*]}")`
echo $COL_JOIN > $LOG_PATH

ExeStartTime=`date +%s`
while true
do
	sleep 60

	# get series api result
	TNow=`date +%s%N`
	RES_ARR=()
	for ((i=0; i < $MAX_TIME; i+=$STEP)); do
		_I_START=$(( i + STEP ))
		_DIFF_S=$(( _I_START * 1000000000 * 60 ))
		_DIFF_E=$(( i * 1000000000 * 60  ))
		T_START=$(( TNow - _DIFF_S ))
		T_END=$(( TNow - _DIFF_E ))
		# request series api
		RES=`curl -s "http://test-loki-1:3100/loki/api/v1/series?start=$T_START&end=$T_END" \
		 --data-urlencode 'match[]={filename="/var/log/flog.log",method="GET"}' | \
		 jq -r .data[].protocol | \
		 jq -csR 'split("\n")[:-1]' | \
		 jq length` 
		RES_ARR+=($RES)
	done

	# Output result
	RES_JOIN=`(IFS=','; echo "${RES_ARR[*]}")`
	ExeEndTime=`date +%s`
	RunTime=$((ExeEndTime - ExeStartTime))
	RunTime=$((RunTime / 60))
	echo "$RunTime,$RES_JOIN" >> $LOG_PATH

done
