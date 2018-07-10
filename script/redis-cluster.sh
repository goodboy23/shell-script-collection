#!/usr/bin/env bash
#此脚本将创建集群，需要设置端口


#[使用设置]

#填写ok将按如下填写执行脚本
switch=no

#安装主目录
install_dir=

#redis所在脚本
redis_dir=

#所有要加入集群的节点，前一半节点皆为主
cluster_ip="127.0.0.1:7000 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005"

#默认1主1从，设置2就是1主2从
node=1


script_get() {
    test_package "http://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/redis-4.0.1.gem" "a4b74c19159531d0aa4c3bf4539b1743"
}

script_install() {
    if [[ "$switch" == "no" ]];then
        print_error "1.此脚本需要填写，请./ssc.sh edit 服务名 来设置" "1.This script needs to be filled in. Set the ./ssc.sh edit service name"
    fi

    which redis-server
    if [[ $? -ne 0 ]];then
        print_massage "当前查找不到redis-server命令，请先安装redis" "Currently, the redis-server command cannot be found. Please install redis first."
        exit
    fi

    [[ -d ${install_dir}/${redis_dir} ]] || print_error "${install_dir}/${redis_dir}目录不存在" "${install_dir}/${redis_dir} directory does not exist"
    
    test_rely ruby-2.4
    gem install redis
    
    #启动
    ${install_dir}/${redis_dir}/src/redis-trib.rb create --replicas ${node} ${cluster_ip}
}

script_remove() {
	[ "$language" == "cn" ] && echo "redis-cluster无法卸载，需要每个节点删除存储文件再重新创建集群！" || echo "Redis-cluster cannot be unloaded. Each node needs to delete the storage file and re-create the cluster!"
}


script_info() {
	print_massage "名字：redis-cluster" "Name：redis-cluster"
	print_massage "版本：1" "Version：1"
	print_massage "介绍：配置redis集群" "Introduce：Configure the redis cluster"
	print_massage "作者：日行一善" "do one good deed a day"
}