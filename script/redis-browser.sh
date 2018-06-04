#!/usr/bin/env bash
#redis-browser，redis的可视化工具


#[使用设置]
#主目录，相当于/usr/local
#install_dir=

#日志主目录
#log_dir=

#服务目录名
redis_browser_dir=redis-browser

#填写redis的主机名节点，最少2个
redis_switch=no #填写ok将按如下填写执行脚本
cluster_name=(service1 service2 service3)
cluster_ip=(192.168.2.108:7000 192.168.2.108:7002 192.168.2.108:7004) 

#redis_browser的端口
port=1212

#redis_browser监听
listen=0.0.0.0



script_get() {
    test_package "http://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/redis-4.0.1.gem" "a4b74c19159531d0aa4c3bf4539b1743"
    test_package "http://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/redis-browser-0.5.1.gem" "dbe6a5e711dacbca46e68b10466d9da4"
}

script_install() {
    if [[ "$redis_switch" == "no" ]];then
        print_massage "此脚本需要填写，请./ssc.sh edit 服务名 来设置" "This script needs to be filled in. Set the ./ssc.sh edit service name"
    fi

    if [[ -f /usr/local/bin/man-redis-browser ]];then
        print_massage "检测到当前系统已安装" "Detected that the current system is installed"
        exit
    fi

    test_port ${port}
    test_dir $redis_browser_dir
    
    test_install gem
	test_rely nodejs-8.9 ruby-2.4
    
    script_get
    gem update —system
    gem sources —add https://gems.ruby-china.org/ —remove https://rubygems.org/
    gem sources -l
    gem install package/redis-4.0.1.gem
    gem install package/redis-browser-0.5.1.gem
    
    rm -rf ${install_dir}/${redis_browser_dir}/config.yml
    
    d=1 #名字，从第2个起
    echo "connections:" >> ${install_dir}/${redis_browser_dir}/config.yml
    
    for i in `echo ${cluster_ip[*]}`
    do
        if [ "$i" == "${cluster_ip[0]}" ];then #第一个跳过做默认
            continue
        fi
        
        b=`echo $i | awk -F':' '{print $1}'` 
        c=`echo $i | awk -F':' '{print $2}'`
        cp material/redis_browser.yuml ./one #复制一份格式文件做修改
        
        sed -i "1s/service3:/${cluster_name[$d]}" one
        sed -i "2s/host: 192.168.1.3/host: $b/g" one
        sed -i "3s/port: 7004/port: $c/g" one
        sed -i "5s,url_db_0: redis://192.168.1.3:7004/0,url_db_0: redis://${i}/0,g" one
        cat one >> ${install_dir}/${redis_browser_dir}/config.yml
        let d++
        rm -rf one
    done

    #启动脚本
    test_bin man-redis-browser
    
    sed -i "2a port=${port}" $command
    sed -i "3a listen=${listen}" $command
    sed -i "4a install_dir=$install_dir" $command
    sed -i "5a log_dir=$log_dir" $command
    sed -i "6a redis_browser_dir=$redis_browser_dir" $command
    sed -i "7a one=${cluster_ip}" $command

    #测试

    print_massage "redis-browser安装完成" "Theredis-browser is installed"
	print_massage "安装目录：${install_dir}/${redis_browser_dir}" "Install Dir：${install_dir}/${redis_browser_dir}"
    print_massage "日志目录：${log_dir}/${redis_browser_dir}" "Log directory：${log_dir}/${redis_browser_dir}"
	print_massage "使用：man-redis-browser start" "Use：man-redis-browser start"
	print_massage "访问：curl http://127.0.0.1:${port}" "Access：curl http://127.0.0.1:${port}"
}

script_remove() {
	rm -rf ${install_dir}/${redis_browser_dir}
	rm -rf /usr/local/bin/man-redis-browser

	[ -f /usr/local/bin/clocks ] && print_error "redis-browser卸载失败，请检查脚本" "Redis-browser uninstall failed, please check the script" || print_massage "redis-browser卸载完成！" "redis-browser Uninstall completed！"
}


script_info() {
    print_massage "名字：redis-browser" "Name：redis-browser"
	print_massage "版本：0.5.1" "Version：0.5.1"
	print_massage "介绍：redis的web端管理工具" "Introduce：redis的web端管理工具"
	print_massage "作者：速度与激情小组---Linux部" "Author：Speed and Passion Group --- Linux Department"
}
