#/bin/bash

WORKDIR=/opt/monitor_practice/redis_exporter_root
IP=`(sed -n "2p" ${WORKDIR}/all_instances/192.168.152.60/auth.txt | cut -d= -f2)`
REDIS_PORT=`(sed -n "3p" ${WORKDIR}/all_instances/192.168.152.60/auth.txt | cut -d= -f2)`
EXPORTER_PORT=`(sed -n "4p" ${WORKDIR}/all_instances/192.168.152.60/auth.txt | cut -d= -f2)`
SERVICE=`(sed -n "6p" ${WORKDIR}/all_instances/192.168.152.60/auth.txt | cut -d= -f2)`

echo "正在停止 redis-exporter 进程..."
pkill -9 -f "redis_exporter --redis.addr=redis://${IP}:${REDIS_PORT}"

sleep 1


echo "正在从 Consul 注销 redis-exporter 服务..."
curl -X PUT http://127.0.0.1:8500/v1/agent/service/deregister/${SERVICE}-192.168.152.110-${EXPORTER_PORT}

echo "redis-exporter 停止 + Consul 注销完成！"
