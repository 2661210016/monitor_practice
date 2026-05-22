#/bin/bash
start_all() {
    WORKDIR=/opt/monitor_practice/redis_exporter_root
    
    # 遍历 all 目录下所有子目录中的 start.sh，逐个执行
    for sh_file in ${WORKDIR}/all_instances/*/start.sh; do
        # 跳过不存在的文件（避免 glob 匹配失败）
        [ -f "$sh_file" ] || continue
    
        echo "?? 正在执行: $sh_file"
        /bin/bash "$sh_file"
    done
    
    echo "?  所有 start.sh 执行完成！"
}
#start_all
