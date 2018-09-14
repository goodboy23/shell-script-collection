#!/usr/bin/env bash


#[使用设置]

#填写ok将按如下填写执行脚本
switch=no

#zookeeper安装目录
server_dir=/usr/local/zookeeper

#配置：集群所有节点的ip
cluster_ip=(192.168.2.108 192.168.2.109)

#端口
port=2181



script_get() {
    print_massage "不用下载" "Do not download"
}

script_install() {
    if [[ "$switch" == "no" ]];then
        print_error "此脚本需要填写，请./ssc.sh edit 服务名 来设置" "This script needs to be filled in. Set the ./ssc.sh edit service name"
    fi

    if [[ ! -f ${server_dir}/bin/zkServer.sh ]];then
        print_error "未安装zookeeper，请./ssc.sh install zookeeper-3.5" "Zookeeper is not installed, please./ssc.sh install zookeeper-3.5"
    fi
    
    grep "2888:3888" ${server_dir}/conf/zoo.cfg.dynamic
    if [[ $? -eq 0 ]];then
        print_error "当前已将安装集群，请先卸载" "The cluster is currently installed. Please uninstall it first."
    fi
    
    #配置文件
    echo "clientPort=${port}
dataDir=${server_dir}/data
syncLimit=5
tickTime=2000
initLimit=10
dataLogDir=${server_dir}
dynamicConfigFile=${server_dir}/conf/zoo.cfg.dynamic" > ${server_dir}/conf/zoo.cfg

    #输出配置
    rm -rf  ${server_dir}/conf/zoo.cfg.dynamic
    d=1
    for i in `echo ${cluster_ip[*]}`
    do
        echo "server.${d}=${i}:2888:3888" >> ${server_dir}/conf/zoo.cfg.dynamic
        let d++
    done
    
    #id号
    rm -rf ${server_dir}/data
    mkdir ${server_dir}/data
    id=`process_id`
    echo "$id" > ${server_dir}/data/myid

    print_install_ok $1
    print_log "使用：zkServer.sh start" "Use：zkServer.sh start"
	print_log "########################" "########################"
}

script_remove() {
    zkServer stop
    rm -rf ${server_dir}/conf/zoo.cfg
    rm -rf ${server_dir}/data
    rm -rf ${server_dir}/conf/zoo.cfg.dynamic

    print_remove_ok $1
}

script_info() {
	print_massage "名字：zk-cluster" "Name：zk-cluster"
	print_massage "版本：1" "Version：1"
	print_massage "介绍：配置zookeeper集群" "Introduce：Configure the zookeeper cluster"
	print_massage "作者：日行一善" "do one good deed a day"
    
    print_massage "使用说明：需要先在本地安装zookeeper" "Need to install zookeeper locally"
}
