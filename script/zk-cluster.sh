#!/usr/bin/env bash



#!/usr/bin/env bash
#设置完毕后，再每个节点上安装此脚本


#[使用设置]

#填写ok将按如下填写执行脚本
redis_switch=no

#zookeeper安装目录
zookeeper_dir=/usr/local/zookeeper

#配置：集群所有节点的ip
cluster_ip=(192.168.2.108 192.168.2.109)

#端口
port=2181



script_get() {
    print_massage "不用下载" "Do not download"
}

script_install() {
    if [[ "$redis_switch" == "no" ]];then
        print_massage "1.此脚本需要填写，请./ssc.sh edit 服务名 来设置" "1.This script needs to be filled in. Set the ./ssc.sh edit service name"
    fi

    if [[ ! -f ${zookeeper_dir}/bin/zkServer.sh ]];then
        print_error "2.未安装zookeeper，请./ssc.sh install zookeeper-3.5" "2. Zookeeper is not installed, please./ssc.sh install zookeeper-3.5"
    fi
    
    grep "2888:3888" ${zookeeper_dir}/conf/zoo.cfg.dynamic
    if [[ $? -eq 0 ]];then
        print_error "3.当前已将安装集群，请先卸载" "3. The cluster is currently installed. Please uninstall it first."
    fi
    
    #配置文件
    echo "clientPort=${port}
dataDir=${zookeeper_dir}/data
syncLimit=5
tickTime=2000
initLimit=10
dataLogDir=${zookeeper_dir}
dynamicConfigFile=${install_dir}/${zookeeper_dir}/conf/zoo.cfg.dynamic" > ${zookeeper_dir}/conf/zoo.cfg

    #输出配置
    rm -rf  ${zookeeper_dir}/conf/zoo.cfg.dynamic
    d=1
    for i in `echo ${cluster_ip[*]}`
    do
        echo "server.${d}=${i}:2888:3888" >> ${zookeeper_dir}/conf/zoo.cfg.dynamic
        let d++
    done
    
    #id号
    rm -rf ${zookeeper_dir}/data
    mkdir ${zookeeper_dir}/data
    id=`process_id`
    echo "$id" > ${zookeeper_dir}/data/myid

	print_massage "zk-cluster配置完成" "zk-cluster configuration completed"
	print_massage "使用：zkServer start" "Use：zkServer start"
}

script_remove() {
    zkServer stop
	rm -rf ${zookeeper_dir}/conf/zoo.cfg
    rm -rf ${zookeeper_dir}/data

    print_massage "zk-cluster卸载完成！" "zk-cluster Uninstall completed！"
}

script_info() {
	print_massage "名字：zk-cluster" "Name：zk-cluster"
	print_massage "版本：1" "Version：1"
	print_massage "介绍：配置zookeeper集群" "Introduce：Configure the zookeeper cluster"
	print_massage "作者：日行一善" "do one good deed a day"
    print_massage "使用说明：需要先在本地安装zookeeper" "Need to install zookeeper locally"
}
