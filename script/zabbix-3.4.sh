#!/usr/bin/env bash



#[使用设置]

#主目录，相当于/usr/local
#install_dir=

#日志主目录，相当于/var/log
#log_dir=

#服务目录名
zabbix_dir=zabbix-3.4



script_get() {
    test_package "https://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/zabbix-3.4.1.tar.gz" "cfa5cf5c72723b617352fd049a766ee6"
}

script_install() {
    #检查
    which zabbix_get
    if [[ $? -eq 0 ]];then
        print_massage "1.检测到当前系统已安装" "1.Detected that the current system is installed"
        exit
    fi

    cat /etc/redhat-release | awk '{print $4}' |grep ^7
    [[ $? -eq 0 ]] || print_error "2.当前只支持7版本系统" "2.Currently only supports 7 version systems"
    
    rpm -q httpd
    if [[ $? -eq 0 ]];then
        print_massage "3.检测到httpd已安装，请yum remove httpd mariadb mariadb-server" "Httpd installed detected, please yum remove httpd mariadb mariadb-server manually "
        exit
    fi
    
    rpm -q mariadb-server
    if [[ $? -eq 0 ]];then
        print_massage "4.检测到mariadb-server已安装，请yum remove httpd mariadb mariadb-server" "4.mariadb-server installed detected, please yum remove httpd mariadb mariadb-server manually"
        exit
    fi
    
    test_port 80
    test_port 3306
    test_port 10050
    test_port 10051
    
    #安装依赖
   
    
	test_install net-tools httpd mariadb mariadb-server php php-mysql php-fpm gcc gcc-c++ mariadb-devel libcurl-devel libevent-devel net-snmp-devel php-bcmath php-mbstring php-gd php-xml

    test_start httpd mariadb php-fpm
	test_dir $zabbix_dir
    
	useradd zabbix
	script_get
	tar -xf package/zabbix-3.4.1.tar.gz
	cd zabbix-3.4.1
	./configure --prefix=${install_dir}/${zabbix_dir}  --enable-server --enable-agent --with-mysql && make install || print_error "zabbix安装失败，请检查脚本" "Zabbix installation failed, please check the script"

    rm -rf /var/www/html/*
	cp -rf frontends/php/*    /var/www/html/
	chmod -R 777  /var/www/html/*
    
    mysql -e "show databases;" | grep test
    [[ $? -eq 0 ]] || print_error "5.数据库无法登录进去，请检查脚本" "5.Database cannot be logged in, please check the script"
    
    #删除旧的
    mysql -e "drop database zabbixdb;"
    mysql -e "drop user zabbixuser@'localhost';"

	mysql -e "create database zabbixdb character set utf8;"
	mysql -e 'grant all on  zabbixdb.*  to  zabbixuser@"localhost" identified by "123456"'
    
    mysql -uzabbixuser -p123456 -e "show databases;" | grep test
    [[ $? -eq 0 ]] || print_error "6.zabbix用户无法登录数据库，请检查脚本" "6.Zabbix users cannot log in to the database, please check the script"

	mysql -uzabbixuser -p123456 zabbixdb  < database/mysql/schema.sql
	mysql -uzabbixuser -p123456 zabbixdb  < database/mysql/images.sql
	mysql -uzabbixuser -p123456 zabbixdb  < database/mysql/data.sql
	
	#修改php文件
    if [[ -f /etc/php.ini.bak ]];then
        rm -rf /etc/php.ini
        mv  /etc/php.ini.bak /etc/php.ini
    else
        cp -r /etc/php.ini /etc/php.ini.bak
    fi

	sed -i "s/post_max_size = 8M/post_max_size = 16M/g" /etc/php.ini
	sed -i "s/max_execution_time = 30/max_execution_time = 300/g" /etc/php.ini
	sed -i "s/max_input_time = 60/max_input_time = 300/g" /etc/php.ini
	sed -i "s/max_input_time = 60/max_input_time = 300/g" /etc/php.ini
	sed -i "s,;date.timezone =,date.timezone = Asia/Shanghai,g" /etc/php.ini
	systemctl restart php-fpm httpd  #必须的，不然页面不刷新

    rm -rf /etc/init.d/zabbix_server
	cp misc/init.d/fedora/core/zabbix_server /etc/init.d/
	chmod +x /etc/init.d/zabbix_server
	
	sed -i "s,BASEDIR=/usr/local,BASEDIR=/usr/local/zabbix,g" /etc/init.d/zabbix_server

	sed -i "s/DBName=zabbix/DBName=zabbixdb/g" /usr/local/zabbix/etc/zabbix_server.conf
	sed -i "s/DBUser=zabbix/DBUser=zabbixuser/g" /usr/local/zabbix/etc/zabbix_server.conf
	sed -i "s/# DBPassword=/DBPassword=123456/g" /usr/local/zabbix/etc/zabbix_server.conf
    
	/etc/init.d/zabbix_server start
	netstat -unltp |grep :10051
	[ $? -eq 0 ] || test_exit "7.zabbix服务端安装错误，请检查脚本" "7.Zabbix server installation error, please check the script"
	
	#安装客户端
    rm -rf /etc/init.d/zabbix_agentd
	cp misc/init.d/fedora/core/zabbix_agentd  /etc/init.d/
	chmod  +x /etc/init.d/
	sed -i "s,BASEDIR=/usr/local,BASEDIR=/usr/local/zabbix,g" /etc/init.d/zabbix_agentd
	sed -i "s/ServerActive=127.0.0.1/ServerActive=127.0.0.1:10051/g" /usr/local/zabbix/etc/zabbix_agentd.conf
	
	/etc/init.d/zabbix_agentd start
	netstat -unltp |grep :10050
    [ $? -eq 0 ] || test_exit "8.zabbix客户端安装错误，请检查脚本" "8.Zabbix client installation error, please check the script"
	
	cd ..
	rm -rf zabbix-3.4.1 #清理
    
    #应添加防火墙配置
    
    print_massage "zabbix安装完成" "The zabbix is installed"
    print_massage "安装目录：${install_dir}/${zabbix_dir}" "Install Dir：${install_dir}/${zabbix_dir}"
    print_massage "使用：/etc/init.d/zabbix_server start" "Use：/etc/init.d/zabbix_server start"
    print_massage "浏览器访问：http://127.0.0.1，请登录填写如下信息" "Browser access: http://127.0.0.1，, Please log in and fill in the following information"
    print_massage "账号：admin" "Account: admin"
    print_massage "密码：zabbix" "Password: zabbix"
    print_massage "zabbix数据库名：zabbixdb" "Zabbix database name: zabbixdb"
    print_massage "zabbix数据库用户名：zabbixuser" "Zabbix database user name: zabbixuser"
    print_massage "zabbix数据吗密码：123456" "Zabbix data password: 123456"
}

script_remove() {
	print_massage "不支持卸载" "Does not support uninstall"
}

script_info() {
	print_massage "名字：zabbix-3.4" "Name：zabbix-3.4"
	print_massage "版本：3.4.1" "Version：3.4.1"
	print_massage "介绍：zabbix是一种图形监控软件" "Introduce：Zabbix is a graphics monitoring software"
    print_massage "作者：日行一善" "do one good deed a day"
    print_massage "使用说明：当前使用yum安装的http,mariadb,php-fpm等，纯净环境" "Instructions for use: Currently using yum to install http, mariadb, php-fpm, etc., pure environment"
}
