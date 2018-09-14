#!/usr/bin/env bash
#此脚本将创建集群，需要设置端口


#[使用设置]

#填写ok将按如下填写执行脚本
switch=no

redis_dir=/usr/local/redis

#所有要加入集群的节点，前一半节点皆为主
cluster_ip="127.0.0.1:7000 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005"

#默认1主1从，设置2就是1主2从，最前头的均为主
node=1

server_rely="ruby-2.4"

server_yum="telnet"



script_get() {
    test_package "http://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/redis-4.0.1.gem" "a4b74c19159531d0aa4c3bf4539b1743"
}

script_install() {
    if [[ "$switch" == "no" ]];then
        print_error "此脚本需要填写，请./ssc.sh edit 服务名 来设置" "This script needs to be filled in. Set the ./ssc.sh edit service name"
    fi

    which redis-server
    if [[ $? -ne 0 ]];then
        print_massage "当前查找不到redis-server命令，请先安装redis" "Currently, the redis-server command cannot be found. Please install redis first."
        exit
    fi

    [[ -d ${redis_dir} ]] || print_error "${redis_dir}目录不存在" "${redis_dir} directory does not exist"
    
	test_detection ${1}
    
    #检测端口是否可以连接成功
    for i in `echo $cluster_ip`
    do
        local cl_ip=`echo ${i} | awk -F':' '{print $1}'`
        local cl_port=`echo ${i} | awk -F':' '{print $2}'`
        local cl_lian=`(echo info; sleep 1) | telnet $cl_ip $cl_port  2>&1 |grep used_memory|cut -d : -f2 | head -1`
        [ ! $cl_lian ] && print_error "地址${i}，测试连接失败，请检查填写地址或联系作者" "Address ${i}, test connection failed, please check the address or contact the author"
        
        local cl_lian=`(echo cluster info; sleep 1) | telnet $cl_ip $cl_port  2>&1 |grep cluster_state|cut -d : -f2 | head -1`
        if [[ ! $cl_lian ]];then
            print_massage "${i}通过测试，连接正常" "${I} passed the test and the connection is normal"
        elif [[ "$cl_lian" == "ok" ]];then
            print_error "${i}已经在集群中，请勿重复添加。" "${i} is already in the cluster and should not be added repeatedly."
        fi
   done

   
    script_get
    gem install package/redis-4.0.1.gem
    
    #启动
    ${redis_dir}/src/redis-trib.rb create --replicas ${node} ${cluster_ip}
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