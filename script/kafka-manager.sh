#!/usr/bin/env bash
#kafka-manager，可以用来监控kafka



#[使用设置]

#主目录，相当于/usr/local
#install_dir=

#日志主目录，相当于/var/log
#log_dir=

#服务目录名
kafka_manager_dir=kafka-manager

#zookeeper集群地址用,分隔
kafka_switch=no #yes则根据配置执行脚本
cluster_ip="192.168.2.108:2181,192.168.2.109:2181"

#启动端口
port=9000



script_get() {
    test_package "http://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/kafka-manager-1.3.3.14.zip" "297da17fa75969bc66207e991118b35d"
}

script_install() {
    if [[ "$kafka_switch" == "no" ]];then
        print_massage "此脚本需要填写，请./ssc.sh edit 服务名 来设置" "This script needs to be filled in. Set the ./ssc.sh edit service name"
    fi
    
    if [[ -f /usr/local/bin/man-kafka-manager ]];then
        print_massage "检测到当前系统已安装" "Detected that the current system is installed"
        exit
    fi
    
    test_port ${port}
    
    test_install unzip
    test_dir ${kafka_manager_dir}
	
    #安装包
    script_get
    unzip package/kafka-manager-1.3.3.14.zip
    mv kafka-manager-1.3.3.14 ${install_dir}/${kafka_manager_dir}

    #修改配置文件
    conf=${install_dir}/${kafka_manager_dir}/conf/application.conf
    a=kafka-manager.zkhosts='"'${cluster_ip}'"'
    sed -i "23c $a" $conf

    #创建管理脚本
    test_bin man-kafka-manager

    sed -i "2a port=${port}" $command
    sed -i "3a dir=${install_dir}/${kafka_manager_dir}" $command
    sed -i "4a log=${log_dir}/${kafka_manager_dir}" $command
    
    print_massage "kafka-manager安装完成" "The kafka-manager is installed"
	print_massage "安装目录：${install_dir}/${kafka_manager_dir}" "Install Dir：${install_dir}/${kafka_manager_dir}"
    print_massage "日志目录：${log_dir}/${kafka_manager_dir}" "Log directory：${log_dir}/${kafka_manager_dir}"
	print_massage "使用：man-kafka-manager start" "Use：man-kafka-manager start"
	print_massage "访问：curl http://127.0.0.1:${port}" "Access：curl http://127.0.0.1:${port}"
}

script_remove() {
	rm -rf ${install_dir}/${kafka_manager_dir}
	rm -rf /usr/local/bin/man-kafka-manager
	test_remove kafka-manager
	[ "$language" == "cn" ] && echo "kafka_manager卸载完成！" || echo "kafka_manager Uninstall completed！"
}

script_info() {
    print_massage "名字：kafka_manager" "Name：kafka_manager"
	print_massage "版本：1.3.3.14" "Version：1.3.3.14"
	print_massage "介绍：kafka的web端管理工具" "Introduce：kafka的web端管理工具"
	print_massage "作者：速度与激情小组---Linux部" "Author：Speed and Passion Group --- Linux Department"
}
