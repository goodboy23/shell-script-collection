#!/usr/bin/env bash



#[使用设置]

#主目录，相当于/usr/local
#install_dir=

#日志主目录，相当于/var/log
#log_dir=

#服务目录名
server_dir=redis

#仅用于检测，要修改启动端口，在安装后手动修改
port=6379



script_get() {
    test_package "http://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/redis-3.2.9.tar.gz" "0969f42d1675a44d137f0a2e05f9ebd2"
}

script_install() {
    if [[ -f /usr/local/bin/man-redis ]];then
        print_massage "检测到当前系统已安装" "Detected that the current system is installed"
        exit
    fi
	
	redis-server -v |grep v=3
    if [[ $? -eq 0 ]];then
        print_massage "检测到已安装" "Detected installed"
        exit
    else
        which redis-server
        if [[ $? -eq 0 ]];then
            print_error "当前已有其它版本redis，请手动卸载" "There are other versions of redis currently, please uninstall manually"
        fi
    fi
    
	#依赖
	test_detection ${1}
    
    script_get
	rm -rf redis
    tar -xf package/redis-3.2.9.tar.gz
    mv redis ${install_dir}/${server_dir}

    #启动脚本
    test_bin man-redis

    #环境变量
    sed -i '/^REDIS_HOME=/d' /etc/profile
    sed -i '/^PATH=$REDIS_HOME/d' /etc/profile

    echo "REDIS_HOME=${install_dir}/${server_dir}/bin"  >> /etc/profile
    echo 'PATH=$REDIS_HOME:$PATH' >> /etc/profile
    source /etc/profile

    #检测
    which redis-cli
    [[ $? -eq 0 ]] || print_error "${1}安装失败" "${1} installation failed"

    print_install_ok $1
	print_log "使用：man-redis start" "Use：man-redis start"
	print_log "########################" "########################"
}

script_remove() {
    man-redis stop
    rm -rf ${install_dir}/${server_dir}
    rm -rf /usr/local/bin/man-redis
    
    sed -i '/^REDIS_HOME=/d' /etc/profile
    sed -i '/^PATH=$REDIS_HOME/d' /etc/profile
    
    print_remove_ok $1
}

script_info() {
	print_massage "名字：redis-3.2" "Name：redis-3.2"
	print_massage "版本：3.2.9" "Version：3.2.9"
	print_massage "介绍：高性能key-value数据库" "Introduction: High-performance key-value database"
	print_massage "作者：日行一善" "do one good deed a day"
}
