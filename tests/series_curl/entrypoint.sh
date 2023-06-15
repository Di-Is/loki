ExeStartTime=`date +%s`
while true
do
	Start10m=`date +%s%N -d "10 minute ago"`
	End0m=`date +%s%N`
	End5m=`date +%s%N`
	RESP0mTo10m=`curl -s "http://test-loki-1:3100/loki/api/v1/series?end=$End0m&start=$Start10m" --data-urlencode 'match[]={container="test-log-generator-1",status="200"}'`
	ExeEndTime=`date +%s`
	RunTime=$((ExeEndTime - ExeStartTime))
	echo $RunTime $RESP0mTo10m >> exe0m_to_10m.log
	RESP5mTo10m=`curl -s "http://test-loki-1:3100/loki/api/v1/series?end=$End5m&start=$Start10m" --data-urlencode 'match[]={container="test-log-generator-1",status="200"}'`
	echo $RunTime $RESP5mTo10m >> exe5m_to_10m.log
	sleep 10
done
