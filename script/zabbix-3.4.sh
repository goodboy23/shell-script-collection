#!/usr/bin/env bash



#[使用设置]

#主目录，相当于/usr/local
#install_dir=

#日志主目录，相当于/var/log
#log_dir=

#服务目录名
server_dir=zabbix

port="80 3306 10050 10051"

server_yum="net-tools httpd php php-mysql php-fpm mariadb-devel gcc gcc-c++ libcurl-devel libevent-devel net-snmp-devel php-bcmath php-mbstring php-gd php-xml  mariadb mariadb-server"




script_get() {
    test_package https://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/simhei.ttf 5b4ceb24c33f4fbfecce7bd024007876
    test_package "https://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/zabbix-3.4.1.tar.gz" "cfa5cf5c72723b617352fd049a766ee6"
}

script_install() {
    #检查
    if [[ -f /etc/init.d/zabbix_server ]];then
        print_massage "检测到当前系统已安装" "Detected that the current system is installed"
        exit
    fi

    cat /etc/redhat-release | awk '{print $4}' |grep ^7
    [[ $? -eq 0 ]] || print_error "当前只支持7版本系统" "Currently only supports 7 version systems"
    
    #安装依赖
	test_detection ${1}
	
    systemctl stop httpd
	systemctl stop php-fpm
	systemctl stop mariadb
	test_start httpd php-fpm mariadb

	useradd zabbix
	script_get
	tar -xf package/zabbix-3.4.1.tar.gz
	cd zabbix-3.4.1
	./configure --prefix=${install_dir}/${server_dir}  --enable-server --enable-agent --with-mysql && make install || print_error "zabbix安装失败" "Zabbix installation failed"

    rm -rf /var/www/html/*
	cp -rf frontends/php/*    /var/www/html/
	chmod -R 777  /var/www/html/*
    
    mysql -e "show databases;" | grep test
    [[ $? -eq 0 ]] || print_error "数据库无法登录进去" "Database cannot be logged in"

    #删除旧的
    mysql -e "drop database zabbixdb;"
    mysql -e "drop user zabbixuser@'localhost';"

    #创建新的
	mysql -e "create database zabbixdb character set utf8;"
	mysql -e 'grant all on  zabbixdb.*  to  zabbixuser@"localhost" identified by "123456"'
    
    mysql -uzabbixuser -p123456 -e "show databases;" | grep test
    [[ $? -eq 0 ]] || print_error "zabbix用户无法登录数据库" "Zabbix users cannot log in to the database"

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
	systemctl restart httpd
    systemctl restart php-fpm
	
    rm -rf /etc/init.d/zabbix_server
	cp misc/init.d/fedora/core/zabbix_server /etc/init.d/
	chmod +x /etc/init.d/zabbix_server
	
	sed -i "s,BASEDIR=/usr/local,BASEDIR=/usr/local/zabbix,g" /etc/init.d/zabbix_server

	sed -i "s/DBName=zabbix/DBName=zabbixdb/g" /usr/local/zabbix/etc/zabbix_server.conf
	sed -i "s/DBUser=zabbix/DBUser=zabbixuser/g" /usr/local/zabbix/etc/zabbix_server.conf
	sed -i "s/# DBPassword=/DBPassword=123456/g" /usr/local/zabbix/etc/zabbix_server.conf
    
	/etc/init.d/zabbix_server start
	netstat -unltp |grep :10051
	[ $? -eq 0 ] || print_error "zabbix服务端安装错误，请联系作者" "Zabbix server installation error,please contact the author"
	
	#安装客户端
    rm -rf /etc/init.d/zabbix_agentd
	cp misc/init.d/fedora/core/zabbix_agentd  /etc/init.d/
	chmod  +x /etc/init.d/
	sed -i "s,BASEDIR=/usr/local,BASEDIR=/usr/local/zabbix,g" /etc/init.d/zabbix_agentd
	sed -i "s/ServerActive=127.0.0.1/ServerActive=127.0.0.1:10051/g" /usr/local/zabbix/etc/zabbix_agentd.conf
	
	/etc/init.d/zabbix_agentd start
	netstat -unltp |grep :10050
    [ $? -eq 0 ] || print_error "zabbix客户端安装错误，请联系作者" "Zabbix client installation error, please contact the author"
	
	cd ..
	rm -rf zabbix-3.4.1 #清理
    
    #环境变量
    sed -i '/^export ZABBIX_HOME=/d' /etc/profile
    sed -i '/^export PATH=${ZABBIX_HOME}/d' /etc/profile
    
    echo "export ZABBIX_HOME=${install_dir}/${server_dir}/bin" >> /etc/profile
    echo 'export PATH=${ZABBIX_HOME}:${PATH}' >> /etc/profile
    source /etc/profile
    
    which zabbix_get
    [[ $? -eq 0 ]] || print_error "环境变量生成失败" "Environment variable generation failed"
    
    
    
    
    #应添加防火墙配置
    
    print_install_ok $1
    print_log "使用：/etc/init.d/zabbix_server start" "Use：/etc/init.d/zabbix_server start"
    print_log "浏览器访问：http://127.0.0.1，请登录填写如下信息" "Browser access: http://127.0.0.1，, Please log in and fill in the following information"
    print_log "账号：admin" "Account: admin"
    print_log "密码：zabbix" "Password: zabbix"
    print_log "zabbix数据库名：zabbixdb" "Zabbix database name: zabbixdb"
    print_log "zabbix数据库用户名：zabbixuser" "Zabbix database user name: zabbixuser"
    print_log "zabbix数据吗密码：123456" "Zabbix data password: 123456"
	print_log "########################" "########################"
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
