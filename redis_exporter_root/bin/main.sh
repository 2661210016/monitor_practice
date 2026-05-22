#!/bin/bash

. start_all.sh
. stop_all.sh

WORKDIR=/opt/monitor_practice/redis_exporter_root
EXPORTER_PORT=$2
NUM=`cat ./all_auth.txt | wc -l`
deploy_all() {
    for i in $(seq 1 $NUM);do
        local IP=`sed -n "${i}p" ./all_auth.txt | awk '{print $1}'`
        local REDIS_PORT=`sed -n "${i}p" ./all_auth.txt | awk '{print $2}'`
        local SERVICE=`sed -n "${i}p" ./all_auth.txt | awk '{print $3}'`
        local REGION=`sed -n "${i}p" ./all_auth.txt | awk '{print $4}'`
        local CLUSTER=`sed -n "${i}p" ./all_auth.txt | awk '{print $5}'`

        ls "../all_instances/$IP" >/dev/null 2>&1 || cp -ra ../model ../all_instances/$IP

        sed -i "s/IP/$IP/" ../all_instances/$IP/auth.txt
        sed -i "s/REDIS_PORT/$REDIS_PORT/" ../all_instances/$IP/auth.txt
        sed -i "s/EXPORTER_PORT/$EXPORTER_PORT/" ../all_instances/$IP/auth.txt
        sed -i "s/SERVICE/$SERVICE/" ../all_instances/$IP/auth.txt

        sed -i "s/SERVICE/$SERVICE/" ../all_instances/$IP/redis-exporter-service.json
        sed -i "s/EXPORTER_PORT/$EXPORTER_PORT/" ../all_instances/$IP/redis-exporter-service.json
        sed -i "s/REGION/$REGION/" ../all_instances/$IP/redis-exporter-service.json
        sed -i "s/CLUSTER/$CLUSTER/" ../all_instances/$IP/redis-exporter-service.json

        sed -i "s#model#all_instances/$IP#g" ../all_instances/$IP/start.sh
        sed -i "s#model#all_instances/$IP#g" ../all_instances/$IP/stop.sh
	EXPORTER_PORT=$((EXPORTER_PORT+1))
    done
}

if [ "$1" == "start" ];then
	if [ "$2" -gt 0 ] && [ "$2" -lt 30000 ];then
		deploy_all
		start_all
		echo "over"
	else
		echo "第二个参数不对，请输入端口号"
		exit 1
	fi
elif [ "$1" == "stop_all" ];then
	stop_all
	echo "stop_all over"
elif [ "$1" == "stop_consul" ];then
	cat ./stop_consul.conf | while read line;do
	curl -X PUT http://127.0.0.1:8500/v1/agent/service/deregister/redis-exporter-192.168.152.110-${line}
	done
	echo "stop_consul over"
else
	echo "第一个参数不对，请输入start或者stop_all"
fi



