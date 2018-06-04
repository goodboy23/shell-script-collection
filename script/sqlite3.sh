#!/usr/bin/env bash



script_get() {
    test_package http://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/sqlite-snapshot-201803072139.tar.gz b2447f8009fba42eabaeef6fcf208e2c
}

script_install() {
    sqlite3 -version
    if [[ $? -eq 0 ]];then
        print_massage "安装错误，请检查脚本" "Installation error, please check the script"
        exit
    fi

    #依赖
    test_install gcc cmake
    
    #安装服务
    script_get
    tar -xf package/sqlite-snapshot-201803072139.tar.gz
    cd sqlite-snapshot-201803072139
    ./configure
    make && make install
    
    #测试
    sqlite3 -version
    [[ $? -eq 0 ]] || print_error "安装错误，请检查脚本" "Installation error, please check the script"

    print_massage "sqlite3安装完成" "The sqlite3 is installed"
	print_massage "使用：sqlite3 -version" "Use：sqlite3 -version" 
}

script_remove() {
	print_massage "当前不支持卸载" "Does not currently support uninstallation"
}

script_info() {
    print_massage "名字：sqlite3" "Name：sqlite3"
	print_massage "版本：3.23.0" "Version：3.23.0"
	print_massage "介绍：sqlite是一款轻量的关系型数据库" "Introduction: Sqlite is a lightweight relational database"
	print_massage "作者：速度与激情小组---Linux部" "Author：Speed and Passion Group --- Linux Department"
}
