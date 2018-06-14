#!/usr/bin/env bash



script_get() {
    test_package http://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/sqlite-snapshot-201803072139.tar.gz b2447f8009fba42eabaeef6fcf208e2c
}

script_install() {
    sqlite3 -version
    if [[ $? -eq 0 ]];then
        print_massage "1.检测到当前系统已安装" "1.Detected that the current system is installed"
        exit
    fi
    #检测目录
    test_install gcc cmake

    #安装服务
    script_get
    tar -xf package/sqlite-snapshot-201803072139.tar.gz
    cd sqlite-snapshot-201803072139
    ./configure
    make && make install
    
    #测试
    sqlite3 -version
    [ $? -eq 0 ] || print_error "2.安装错误，请检查脚本" "2.Installation error, please check the script"

    print_massage "sqlite-3.23安装完成" "The sqlite-3.23 is installed"
	print_massage "使用：sqlite3 -version" "Use：sqlite3 -version"
}

script_remove() {
    print_massage "当前不支持卸载" "Does not currently support uninstallation"
}

script_info() {
    print_massage "名字：sqlite-3.23" "Name：sqlite-3.23"
	print_massage "版本：3.23.0" "Version：3.23.0"
	print_massage "介绍：SQLite是一款轻型的关系型数据库管理系统" "Introduce：SQLite is a lightweight relational database management system"
    print_massage "作者：日行一善" "do one good deed a day"
}
