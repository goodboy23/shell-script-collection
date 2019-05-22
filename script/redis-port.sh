#!/usr/bin/env bash
#启动多个端口


#[使用设置]

#填写ok将按如下填写执行脚本
switch=no

#redis主目录
install_dir=/usr/local

#redis日志目录
log_dir=/var/log

#redis目录名
server_dir=redis

#将安装如下端口实例
port=(6379 7000)

#监听ip
listen=0.0.0.0



script_get() {
    print_massage "不用下载" "Do not download"
}

script_install() {
    which redis-server
    if [[ $? -ne 0 ]];then
        print_massage "当前查找不到redis-server命令，请先安装redis" "Currently, the redis-server command cannot be found. Please install redis first."
        exit
    fi
    
    if [[ "$switch" == "no" ]];then
        print_error "此脚本需要填写，请./ssc.sh edit 服务名 来设置" "This script needs to be filled in. Set the ./ssc.sh edit service name"
    fi
    
    [[ -d ${install_dir}/${server_dir} ]] || print_error "${install_dir}/${server_dir}目录不存在" "${install_dir}/${server_dir} directory does not exist"

	for i in `echo ${port[*]}`
    do
        test_port $i
        
        command=/usr/local/bin/man-redis-${i} #创建单独管理脚本
        if [ ! -f $command ];then
            cp material/man-redis1 $command
        
            sed -i "2a port=${i}" $command
            sed -i "3a install_dir=${install_dir}" $command
            sed -i "4a log_dir=${log_dir}" $command
            sed -i "5a server_dir=${server_dir}" $command
        
            chmod +x $command
        else
            print_massage "redis端口${i}已经建立过" "Redis port ${i} has been created"
            continue #如果管理脚本存在，则跳过这个端口
        fi

        conf=${install_dir}/${server_dir}/cluster/${i}/${i}.conf
        
        mkdir -p ${install_dir}/${server_dir}/cluster/${i}
        cp material/redis_7000.conf $conf
        
        sed -i "s/^bind 127.0.0.1/bind ${listen}/g" $conf
        sed -i "/^port/cport ${i}" $conf
        sed -i "/^cluster-config-file/ccluster-config-file nodes_${i}.conf" $conf
        sed -i "/^pidfile/cpidfile redis_${i}.pid" $conf
        sed -i "/^dir/cdir ${install_dir}/${server_dir}/cluster/${i}" $conf 
    done

    #创建总管理脚本
    echo '#!/bin/bash

for i in `ls /usr/local/bin/man-redis-*`
do  
    [ "$i" == "/usr/local/bin/man-redis-cluster" ] && continue || $i $1
done' >> /usr/local/bin/man-redis-cluster
    chmod +x /usr/local/bin/man-redis-cluster
    
	print_install_ok $1
	print_log "redis-port配置完成，端口${port[*]}" "Redis-port configuration is complete, port ${port[*]}"
	print_log "安装目录：${install_dir}/${server_dir}/cluster" "Install Dir：${install_dir}/${server_dir}/cluster"
    print_log "日志目录：${install_dir}/${server_dir}/cluster" "Log directory: ${install_dir}/${server_dir}/cluster"
	print_log "使用：man-redis-cluster start" "Use：man-redis-cluster start"
	print_log "########################" "########################"
}

script_remove() {
    clear
	rm -rf /usr/local/bin/man-redis-cluster
	for i in `echo ${port[*]}`
    do
        man-redis-${i} stop
		rm -rf /usr/local/bin/man-redis-${i}
		rm -rf ${install_dir}/${server_dir}/cluster/${i}
		print_massage "节点${i}卸载完成！" "node${i} Uninstall completed！"
	done
}

script_info() {
	print_massage "名字：redis-port" "Name：redis-port"
	print_massage "版本：0" "Version：0"
	print_massage "介绍：配置redis多端口" "Introduction: Configuring Redis Multiport"
	print_massage "作者：日行一善" "do one good deed a day"
}
