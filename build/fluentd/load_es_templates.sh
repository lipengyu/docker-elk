#!/bin/sh

# Automatically load Elasticsearch Templates that are contained in /data_estemplates/

RETRY=30
ES_TEMPLATE_DIR="/data_estemplates/"

while [ $RETRY -gt 0 ]
do
	RESULTS=`curl -s -XGET "http://elasticsearch:9200" | grep -i "build_timestamp"`
	if [[ -n "$RESULTS" ]]; then
		echo -e "ELASTICSEARCH IS UP, LOADING TEMPLATES"
		cd $ES_TEMPLATE_DIR
		for i in *
		do
			FILE=`echo $i | cut -f1 -d'.'`
			FULLPATH="`pwd`/$i"
			echo -e "LOADING TEMPLATE $FILE INTO ELASTICSEARCH\n"
			curl -s -XPUT "http://$ELASTICSEARCH_SERVER:9200/_template/$FILE" -d@$FULLPATH
			echo -e "\n"
		done
		break
	else
		echo "ELASTICSEARCH IS NOT UP YET, RETRYING IN 30SECS"
		let RETRY-=1
		sleep 30
	fi
done
