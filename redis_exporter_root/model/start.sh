#/bin/bash

WORKDIR=/opt/monitor_practice/redis_exporter_root
IP=`(sed -n "2p" ${WORKDIR}/model/auth.txt | cut -d= -f2)`
REDIS_PORT=`(sed -n "3p" ${WORKDIR}/model/auth.txt | cut -d= -f2)`
EXPORTER_PORT=`(sed -n "4p" ${WORKDIR}/model/auth.txt | cut -d= -f2)`

nohup $WORKDIR/bin/redis_exporter   --redis.addr=redis://${IP}:${REDIS_PORT}   --web.listen-address=:${EXPORTER_PORT} > $WORKDIR/log/redis_exporter_${IP}_${REDIS_PORT}.log 2>&1 &

sleep 2

curl -X PUT   -H "Content-Type: application/json"   -d @$WORKDIR/model/redis-exporter-service.json   http://127.0.0.1:8500/v1/agent/service/register

