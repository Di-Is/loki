mkdir /tests/series_curl/results
ExeStartTime=`date +%s`
while true
do
	Start6m=`date +%s%N -d "6 minute ago"`
	End3m=`date +%s%N -d "3 minute ago"`
	Start3m=`date +%s%N -d "3 minute ago"`
	End0m=`date +%s%N`

	Resp0mTo3m=`curl -s "http://test-loki-1:3100/loki/api/v1/series?end=$End0m&start=$Start3m" --data-urlencode 'match[]={container="test-log-generator-1",status="200"}'`
	ExeEndTime=`date +%s`
	RunTime=$((ExeEndTime - ExeStartTime))
	echo $RunTime $Resp0mTo3m >> /tests/series_curl/results/exe0mto3m.log
	Resp3mTo6m=`curl -s "http://test-loki-1:3100/loki/api/v1/series?end=$End3m&start=$Start6m" --data-urlencode 'match[]={container="test-log-generator-1",status="200"}'`
	echo $RunTime $Resp3mTo6m >> /tests/series_curl/results/exe3mto6m.log
	sleep 10
done
