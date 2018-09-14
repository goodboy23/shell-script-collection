#!/usr/bin/env bash



#[使用设置]
#主目录，相当于/usr/local
#install_dir=

#日志主目录
#log_dir=

#服务目录名
server_dir=redis-browser

#填写ok将按如下填写执行脚本
redis_switch=no

#配置；填写redis的主机名节点，当前最少2个节点，如果是集群，只填写主节点即可
cluster_name=(service1 service2 service3)
cluster_ip=(192.168.2.108:7000 192.168.2.108:7002 192.168.2.108:7004) 

#redis_browser的端口
port=1212

#redis_browser监听
listen=0.0.0.0

server_yum="telnet"

server_rely="nodejs-8.9 ruby-2.4"




script_get() {
    test_package "http://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/redis-4.0.1.gem" "a4b74c19159531d0aa4c3bf4539b1743"
    test_package "http://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/redis-browser-0.5.1.gem" "dbe6a5e711dacbca46e68b10466d9da4"
}

script_install() {
    if [[ "$redis_switch" == "no" ]];then
        print_error "此脚本需要填写，请./ssc.sh edit 服务名 来设置" "This script needs to be filled in. Set the ./ssc.sh edit service name"
    fi

    if [[ -f /usr/local/bin/man-redis-browser ]];then
        print_massage "检测到当前系统已安装" "Detected that the current system is installed"
        exit
    fi

	test_detection ${1}
	
	
    for i in `echo $cluster_ip`
    do
        local cl_ip=`echo ${i} | awk -F':' '{print $1}'`
        local cl_port=`echo ${i} | awk -F':' '{print $2}'`
        local cl_lian=`(echo info; sleep 1) | telnet $cl_ip $cl_port  2>&1 |grep used_memory|cut -d : -f2 | head -1`
        [ ! $cl_lian ] && print_error "地址${i}，测试连接失败，请检查填写地址或联系作者" "Address ${i}, test connection failed, please check the address or contact the author"
   done
    
    
    #依赖
    script_get
    gem install package/redis-4.0.1.gem
	gem list | grep -w redis || print_error "gem安装redis失败" "gem failure to install Redis"
    gem install package/redis-browser-0.5.1.gem
	gem list | grep -w redis-browser || print_error "gem安装redis-browser失败" "gem failure to install redis-browser"

	mkdir ${install_dir}/${server_dir}
    rm -rf ${install_dir}/${server_dir}/config.yml

    d=1 #名字，从第2个起
    echo "connections:" >> ${install_dir}/${server_dir}/config.yml
    
    for i in `echo ${cluster_ip[*]}`
    do
        if [ "$i" == "${cluster_ip[0]}" ];then #第一个跳过做默认
            continue
        fi
        
		cd ${ssc_dir}
		rm -rf one
        b=`echo $i | awk -F':' '{print $1}'` 
        c=`echo $i | awk -F':' '{print $2}'`
        cp material/redis_browser.yml ./one #复制一份格式文件做修改
        
        sed -i "1s/service3:/${cluster_name[$d]}" one
        sed -i "2s/host: 192.168.1.3/host: $b/g" one
        sed -i "3s/port: 7004/port: $c/g" one
        sed -i "5s,url_db_0: redis://192.168.1.3:7004/0,url_db_0: redis://${i}/0,g" one
        cat one >> ${install_dir}/${server_dir}/config.yml
        let d++
        rm -rf one
    done

    #启动脚本
    test_bin man-redis-browser
    
    sed -i "2a port=${port}" $command
    sed -i "3a listen=${listen}" $command
    sed -i "7a one=${cluster_ip[0]}" $command
	
    #测试
    print_install_ok $1
	print_log "使用：man-redis-browser start" "Use：man-redis-browser start"
	print_log "访问：http://xx.xx.xx.xx:${port}" "Access：http://xx.xx.xx.xx:${port}"
	print_log "########################" "########################"
}

script_remove() {
    man-redis-browser stop
	rm -rf ${install_dir}/${server_dir}
	rm -rf /usr/local/bin/man-redis-browser

    test_remove_ok $1
}


script_info() {
    print_massage "名字：redis-browser" "Name：redis-browser"
	print_massage "版本：0.5.1" "Version：0.5.1"
	print_massage "介绍：redis的web端管理工具" "Introduce：redis的web端管理工具"
    print_massage "作者：日行一善" "do one good deed a day"
}
