# 封装的函数：批量生成redis-exporter实例
deploy_all() {
    WORKDIR=/opt/monitor_practice/redis_exporter_root
   local NUM=`cat ./all_auth.txt | wc -l`
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
    done
}

# 调用函数执行（保留原脚本的执行效果）
#deploy_all
