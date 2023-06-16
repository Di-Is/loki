RESULT_DIR="/tests/series_curl/results"
LOG_FILE="series_result.log"
LOG_PATH="$RESULT_DIR/$LOG_FILE"

if [ ! -d $RESULT_DIR ]; then
	mkdir $RESULT_DIR
fi

echo "" > $LOG_PATH
echo "elapsed_time[m],Now-5mAgo,10mAgo-15mAgo,45mAgo-50mAgo" >> $LOG_PATH

sleep 15

ExeStartTime=`date +%s`
while true
do
	T50mAgo=`date +%s%N -d "50 minute ago"`
	T45mAgo=`date +%s%N -d "45 minute ago"`
	T15mAgo=`date +%s%N -d "15 minute ago"`
	T10mAgo=`date +%s%N -d "10 minute ago"`
	T5mAgo=`date +%s%N -d "5 minute ago"`
	TNow=`date +%s%N`

	ResNowTo5mAgo=`curl -s "http://test-loki-1:3100/loki/api/v1/series?end=$TNow&start=$T5mAgo" --data-urlencode 'match[]={container="test-flog-1",method="GET"}' | jq -r .data[].protocol | jq -csR 'split("\n")[:-1]'`
	Res10mAgoTo15mAgo=`curl -s "http://test-loki-1:3100/loki/api/v1/series?end=$T10mAgo&start=$T15mmAgo" --data-urlencode 'match[]={container="test-flog-1",method="GET"}' | jq -r .data[].protocol | jq -csR 'split("\n")[:-1]'`
	Res45mAgoTo50mAgo=`curl -s "http://test-loki-1:3100/loki/api/v1/series?end=$T45mAgo&start=$T50mAgo" --data-urlencode 'match[]={container="test-flog-1",method="GET"}' | jq -r .data[].protocol | jq -csR 'split("\n")[:-1]'`
	ExeEndTime=`date +%s`
	RunTime=$((ExeEndTime - ExeStartTime))
	RunTime=$((RunTime / 60))
	echo "$RunTime,$ResNowTo5mAgo,$Res10mAgoTo15mAgo,$Res45mAgoTo50mAgo" >> $LOG_PATH
	sleep 60
done
