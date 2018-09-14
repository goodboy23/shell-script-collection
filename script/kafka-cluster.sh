#!/usr/bin/env bash




#[使用设置]
#填写ok将按如下填写执行脚本
redis_switch=no

#配置：kafka的目录
kafka_dir=/usr/local/kafka

kafka_log_dir=/var/log/kafka

#zookeeper集群的ip，包括他自己
cluster_ip=(192.168.2.108:2181 192.168.2.109:2181)

#端口
port=9092

#监听地址，如果填写localhost，则监听本地，否则随意填
listen=localhost



script_get() {
    print_massage "不用下载" "Do not download"
}

script_install() {
    if [[ "$redis_switch" == "no" ]];then
        print_error "此脚本需要填写，请./ssc.sh edit 服务名 来设置" "1.This script needs to be filled in. Set the ./ssc.sh edit service name"
    fi

    if [[ ! -d ${kafka_dir} ]];then
        print_error "未安装kafka，请./ssc.sh install kafka-2.12" "kafka is not installed, please./ssc.sh install kafka-2.12"
    fi

    grep "zookeeper.connect=${cluster_dizhi}" ${kafka_dir}/config/server.properties
    if [[ $? -eq 0 ]];then
        print_error "当前已配置集群，请修改脚本cluster_dizhi" "to configure the cluster, please modify the script cluster_dizhi"
    fi
    
    test_port ${port}
    test_dir ${server_dir}
    test_rely ${server_rely}
    test_install ${server_yum}
	
    #修改配置
    conf=${kafka_dir}/config/server.properties
    rm -rf $conf
    cp material/server.properties $conf
    
    id=`process_id`
    ip=`process_ip`
    
    #算出地址字符串
    for i in `echo ${cluster_ip[*]}` 
    do
        if [ "$i" == "${cluster_ip[0]}" ];then #刨去第一个，不然最前面会多个,
            cluster_dizhi=`echo $i`
        else
            cluster_dizhi=`echo ${cluster_dizhi},$i`
        fi
    done

	mkdir ${kafka_log_dir}
    sed -i "s/broker.id=1/broker.id=${id}/g" $conf
    sed -i "s/port=9092/port=${port}/g" $conf
    if [ "$listen" == "localhost" ];then
        sed -i "s/advertised.host.name=192.168.100.11/advertised.host.name=${ip}/g" $conf
    else
        sed -i "s/advertised.host.name=192.168.100.11/advertised.host.name=${listen}/g" $conf
    fi
    sed -i "s,log.dirs=/ops/log/kafka,log.dirs=${kafka_log_dir},g" $conf
    sed -i "s/zookeeper.connect=B-S-01:2181/zookeeper.connect=${cluster_dizhi}/g" $conf

    #创建脚本
    test_bin man-kafka
    sed -i "2a port=${port}" $command
	sed -i "2a kafka_dir=${kafka_dir}" $command
	
    print_install_ok $1
	print_log "使用：man-kafka start" "Use：man-kafka start"
	print_log "########################" "########################"
}

script_remove() {
    man-kafka start
    rm -rf ${server_dir}/config/server.properties
	rm -rf /usr/local/bin/man-kafka

    print_remove_ok $1
}

script_info() {
	print_massage "名字：kafka-cluster" "Name：kafka-cluster"
	print_massage "版本：1" "Version：1"
	print_massage "介绍：配置kafka集群" "Introduce：Configure kafka cluster"
	print_massage "作者：日行一善" "do one good deed a day"
    print_massage "使用说明：需要先在本地安装kafka" "Need to install kafka locally"
}
