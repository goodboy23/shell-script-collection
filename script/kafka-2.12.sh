#!/usr/bin/env bash



#[使用设置]
#主目录，相当于/usr/local
#install_dir=

#服务目录名
kafka_dir=kafka

#kafka端口
port=9092

#填写ok将按如下填写执行脚本
redis_switch=no

#配置：zookeeper的地址
zk_ip=192.168.2.108:2181



script_get() {
    test_package http://mirror.bit.edu.cn/apache/kafka/0.10.2.1/kafka_2.12-0.10.2.1.tgz fab4b35ba536938144489105cb0091e0
}

script_install() {
    if [[ "$redis_switch" == "no" ]];then
        print_error "1.此脚本需要填写，请./ssc.sh edit 服务名 来设置" "1.This script needs to be filled in. Set the ./ssc.sh edit service name"
    fi

    if [[ -f ${install_dir}/${kafka_dir}/config/server.properties ]];then
        print_massage "2.检测到当前系统已安装" "2.Detected that the current system is installed"
        exit
    fi

    test_port ${port}
    test_rely jdk
    
    test_dir $kafka_dir
    script_get
    tar -xf package/kafka_2.12-0.10.2.1.tgz
    mv kafka_2.12-0.10.2.1 ${install_dir}/${kafka_dir}
    
    test_bin man-kafka

    sed -i "2a port=${port}" /usr/local/bin/man-kafka
    sed -i "3a dir=${install_dir}/${kafka_dir}" /usr/local/bin/man-kafka

	print_massage "kafka-2.12安装完成" "The kafka-2.12 is installed"
	print_massage "安装目录：${install_dir}/${kafka_dir}" "Install Dir：${install_dir}/${kafka_dir}"
	print_massage "使用：clocks" "Use：clocks"
}

script_remove() {
    man-kafka stop
	rm -rf /usr/local/bin/man-kafka
    rm -rf ${install_dir}/${kafka_dir}
    
    print_massage "kafka-2.12卸载完成！" "kafka-2.12 Uninstall completed！"
}

script_info() {
	print_massage "名字：kafka-2.12" "Name：kafka-2.12"
	print_massage "版本：2.12" "Version：2.12"
	print_massage "介绍：一个分布式消息系统" "Introduce：The A distributed messaging system"
	print_massage "作者：日行一善" "do one good deed a day"
}
