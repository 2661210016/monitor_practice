# practice
这是一个自动化运维的练习监控脚本，考虑到exporter多的场景（如有上百个exporter时），在prometheus.yaml一个一个配置会显得很乱，于是就写了这个使用consul注册exporter的脚本。
简要解释：脚本以model下的一个模型为例，init初始化操作后会批量生成监控的所有目录。
所用到的工具有
1.redis_exporter  (这里用redis只是为了测试)
2.redis 6节点
3.prometheus
4.consul
命令介绍
bin目录下的main.sh是主命令，使用如下
./main.sh   start   22000
开启exporter并注册到consul
./main.sh   stop_consul   stop_consul.conf
停止选择的exporter
./main.sh   stop_all
停止所有的exporte
