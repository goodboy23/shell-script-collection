#!/usr/bin/env bash



#[使用设置]
#主目录，相当于/usr/local
#install_dir=

log_dir=no

#服务目录名
server_dir=kafka

#kafka端口
port=9092

#填写ok将按如下填写执行脚本
redis_switch=no

#配置：zookeeper的地址
zk_ip=192.168.2.108:2181

server_rely="jdk-1.8"



script_get() {
    test_package http://mirror.bit.edu.cn/apache/kafka/0.10.2.1/kafka_2.12-0.10.2.1.tgz fab4b35ba536938144489105cb0091e0
}

script_install() {
    if [[ "$redis_switch" == "no" ]];then
        print_error "此脚本需要填写，请./ssc.sh edit 服务名 来设置" "This script needs to be filled in. Set the ./ssc.sh edit service name"
    fi

    if [[ -f ${install_dir}/${server_dir}/config/server.properties ]];then
        print_massage "检测到当前系统已安装" "Detected that the current system is installed"
        exit
    fi

	test_detection ${1}
    
    script_get
	rm -rf afka_2.12-0.10.2.1
    tar -xf package/kafka_2.12-0.10.2.1.tgz
    mv kafka_2.12-0.10.2.1 ${install_dir}/${server_dir}
    
    test_bin man-kafka
    sed -i "2a port=${port}" $command

    print_install_ok $1
	print_log "使用：man-kafka start" "Use：man-kafka start"
	print_log "########################" "########################"
}

script_remove() {
    man-kafka stop
	rm -rf /usr/local/bin/man-kafka
    rm -rf ${install_dir}/${server_dir}
    
    print_remove_ok $1
}

script_info() {
	print_massage "名字：kafka-2.12" "Name：kafka-2.12"
	print_massage "版本：2.12" "Version：2.12"
	print_massage "介绍：一个分布式消息系统" "Introduce：The A distributed messaging system"
	print_massage "作者：日行一善" "do one good deed a day"
}
