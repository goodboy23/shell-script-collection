#!/usr/bin/env bash



#[使用设置]
install_dir=/usr/local

log_dir=no

server_dir=sqlite

server_yum="gcc make"



script_get() {
    test_package http://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/sqlite-snapshot-201803072139.tar.gz b2447f8009fba42eabaeef6fcf208e2c
}

script_install() {
    sqlite3 -version | grep ^3
    if [[ $? -eq 0 ]];then
        print_massage "检测到已安装" "Detected installed"
        exit
    else
        sqlite3 -version
        if [[ $? -eq 0 ]];then
            print_error "当前已有其它版本sqlite，请手动卸载" "There are other versions of sqlite currently, please uninstall manually"
        fi
    fi

	#依赖
	test_detection ${1}

    #安装服务
    script_get
	rm -rf sqlite-snapshot-201803072139
    tar -xf package/sqlite-snapshot-201803072139.tar.gz
    cd sqlite-snapshot-201803072139
    ./configure --prefix=${install_dir}/${server_dir}
	[[ -f Makefile ]] || print_error "Makefile生成失败" "Makefile failed to generate"
	make && make altinstall || print_error "make操作失败" "make operation failed"
	
    cd ${ssc_dir}
    rm -rf sqlite-snapshot-201803072139
    
    #环境变量
    sed -i '/^export SQLITE=/d' /etc/profile
    sed -i '/^export PATH=$SQLITE_HOME/d'  /etc/profile
    
    echo "export SQLITE_HOME=${install_dir}/${server_dir}/bin" >> /etc/profile
    echo 'export PATH=$SQLITE_HOME:$PATH' >> /etc/profile
    source /etc/profile
    
    #测试
    sqlite3 -version
    [ $? -eq 0 ] || print_error "安装错误" "Installation error"

    print_install_ok $1
	print_log "使用：sqlite3 -version" "Use：sqlite3 -version"
	print_log "########################" "########################"
}

script_remove() {
    rm -rf ${install_dir}/${server_dir}
    sed -i '/^export SQLITE=/d' /etc/profile
    sed -i '/^export PATH=$SQLITE_HOME/d'  /etc/profile
    
    print_remove_ok $1
}

script_info() {
    print_massage "名字：sqlite-3.23" "Name：sqlite-3.23"
	print_massage "版本：3.23.0" "Version：3.23.0"
	print_massage "介绍：SQLite是一款轻型的关系型数据库管理系统" "Introduce：SQLite is a lightweight relational database management system"
    print_massage "作者：日行一善" "do one good deed a day"
}
