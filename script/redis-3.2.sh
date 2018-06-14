#!/usr/bin/env bash



#[使用设置]

#主目录，相当于/usr/local
#install_dir=

#日志主目录，相当于/var/log
#log_dir=

#服务目录名
redis_dir=redis



script_get() {
    test_package "http://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/redis-3.2.9.tar.gz" "0969f42d1675a44d137f0a2e05f9ebd2"
}

script_install() {
    if [[ -f /usr/local/bin/man-redis ]];then
        print_massage "1.检测到当前系统已安装" "1.Detected that the current system is installed"
        exit
    fi
    
    test_port 6379
    test_dir $redis_dir
    
    get_redis
    test_install net-tools
    tar -xf package/redis-3.2.9.tar.gz
    mv redis ${install_dir}/${redis_dir}

    #启动脚本
    test_bin man-redis
    sed "2a install_dir=${install_dir}" /usr/local/bin/man-redis
    sed "3a log_dir=${log_dir}" /usr/local/bin/man-redis
    sed "4a redis_dir=${redis_dir}" /usr/local/bin/man-redis

    #环境变量
    sed -i '/^REDIS_HOME=/d' /etc/profile
    sed -i '/^PATH=$REDIS_HOME/d' /etc/profile

    echo "REDIS_HOME=${install_dir}/${redis_dir}/bin"  >> /etc/profile
    echo 'PATH=$REDIS_HOME:$PATH' >> /etc/profile
    source /etc/profile

    #检测
    which redis-cli
    [[ $? -eq 0 ]] || print_error "2.redis-3.2安装失败，请检查脚本" "2.redis-3.2 installation failed, please check the script"
    
    
	print_massage "batch安装完成" "The batch is installed"
	print_massage "安装目录：${install_dir}/${redis_dir}" "Install Dir：${install_dir}/${redis_dir}"
    print_massage "日志目录：${log_dir}/${redis_dir}" "Log directory: ${log_dir}/${redis_dir}"
	print_massage "使用：man-redis start" "Use：man-redis start"
}

script_remove() {
    man-redis stop
    rm -rf ${install_dir}/${redis_dir}
    rm -rf /usr/local/bin/man-redis
    
    sed -i '/^REDIS_HOME=/d' /etc/profile
    sed -i '/^PATH=$REDIS_HOME/d' /etc/profile
    source /etc/profile
    
    which redis-cli
    [ $? -eq 0 ] && print_error "1.redis-3.2未成功删除，请检查脚本" "1.redis-3.2 unsuccessfully deleted, please check the script" || print_massage "redis-3.2卸载完成！" "redis-3.2 Uninstall completed！"
}

script_info() {
	print_massage "名字：redis-3.2" "Name：redis-3.2"
	print_massage "版本：3.2.9" "Version：3.2.9"
	print_massage "介绍：高性能key-value数据库" "Introduction: High-performance key-value database"
	print_massage "作者：日行一善" "do one good deed a day"
}
