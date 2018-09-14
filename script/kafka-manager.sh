#!/usr/bin/env bash
#kafka-manager，可以用来监控kafka



#[使用设置]

#主目录，相当于/usr/local
#install_dir=

#日志主目录，相当于/var/log
#log_dir=

#服务目录名
server_dir=kafka-manager

#yes则根据配置执行脚本
kafka_switch=no

#配置：zookeeper集群地址用,分隔
cluster_ip="192.168.2.108:2181,192.168.2.109:2181"

#启动端口
port=9000

server_rely="jdk-1.8"

server_yum="unzip"



script_get() {
    test_package "http://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/kafka-manager-1.3.3.14.zip" "297da17fa75969bc66207e991118b35d"
}

script_install() {
    if [[ "$kafka_switch" == "no" ]];then
        print_error "此脚本需要填写，请./ssc.sh edit 服务名 来设置" "This script needs to be filled in. Set the ./ssc.sh edit service name"
    fi
    
    if [[ -f /usr/local/bin/man-kafka-manager ]];then
        print_massage "检测到当前系统已安装" "Detected that the current system is installed"
        exit
    fi
    
    test_port ${port}
    test_dir ${server_dir}
    test_rely ${server_rely}
    test_install ${server_yum}

    #安装包
    script_get
    unzip package/kafka-manager-1.3.3.14.zip
    mv kafka-manager-1.3.3.14 ${install_dir}/${server_dir}

    #修改配置文件
    conf=${install_dir}/${server_dir}/conf/application.conf
    a=kafka-manager.zkhosts='"'${cluster_ip}'"'
    sed -i "23c $a" $conf

    #创建管理脚本
    test_bin man-kafka-manager

    sed -i "2a port=${port}" $command
    
    #无效验
    print_install_ok $1
	print_log "使用：man-kafka-manager start" "Use：man-kafka-manager start"
	print_log "访问：http://xx.xx.xx.xx:${port}" "Access：http://xx.xx.xx.xx:${port}"
	print_log "########################" "########################"
}

script_remove() {
    man-kafka-manager stop
	rm -rf ${install_dir}/${server_dir}
	rm -rf /usr/local/bin/man-kafka-manager
    print_remove_ok $1
}

script_info() {
    print_massage "名字：kafka_manager" "Name：kafka_manager"
	print_massage "版本：1.3.3.14" "Version：1.3.3.14"
	print_massage "介绍：kafka的web端管理工具" "Introduce：kafka的web端管理工具"
    print_massage "作者：日行一善" "do one good deed a day"
}
