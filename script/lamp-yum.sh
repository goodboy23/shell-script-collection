#!/usr/bin/env bash

#[使用设置]
server_yum="mariadb-server mariadb mariadb-devel gcc pcre-devel openssl-devel zlib-devel make php php-mysql php-fpm php-gd php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstringphp-snmp php-soap curl curl-devel"



script_get() {
    print_massage "不需要下载" "No need to download"
}

script_install() {
	#依赖
	test_detection ${1}

	print_install_ok $1
	print_log "启动数据库：systemctl start mariadb" "Start the database: systemctl start mariadb"
	print_log "启动WEB：systemctl start httpd" "Start WEB: systemctl start httpd"
	print_log "启动PHP：systemctl start php-fpm" "Start PHP: systemctl start php-fpm"
	print_log "########################" "########################"
}

script_remove() {
	print_massage "暂时无法卸载" "Unable to uninstall temporarily"
}

script_info() {
	print_massage "名字：ant-1.9" "Name：ant-1.9"
	print_massage "版本：1.9" "Version：1.9"
	print_massage "介绍：Ant是Java的生成工具,是Apache的核心项目" "Introduce：Ant is a Java generation tool and a core Apache project"
	print_massage "作者：日行一善" "do one good deed a day"
}