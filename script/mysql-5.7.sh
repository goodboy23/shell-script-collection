#!/usr/bin/env bash



#[使用设置]

#主目录，相当于/usr/local
#install_dir=

#日志主目录，相当于/var/log
#log_dir=

#服务目录名
server_dir=mysql

#启动的端口，可更改
port=3306

server_yum="autoconf libaio bison ncurses-devel"



script_get() {
     test_package "https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.21-linux-glibc2.12-x86_64.tar.gz" "69b1d94f33c05b73cf72d557e484e2dc"
}

script_install() {
    rpm -q mariadb-server
    if [[ $? -eq 0 ]];then
        print_error "当前已有其它版本mariadb-server，请手动卸载" "There are other versions of mariadb-server currently, please uninstall manually"
    fi

    rpm -q mysql-server
    if [[ $? -eq 0 ]];then
        print_error "当前已有其它版本mysql-server，请手动卸载" "There are other versions of mysql-server currently, please uninstall manually"
    fi
    
    if [[ -f /usr/local/bin/man-mysql ]];then
        print_massage "检测到已安装" "检测到已安装"
        exit
    fi
    
	#依赖
	test_detection ${1}

    #权限
    groupadd mysql
    useradd -g mysql -s /sbin/nologin mysql
    
    #下载解压包
    script_get
	rm -rf mysql-5.7.21-linux-glibc2.12-x86_64
    tar -xf package/mysql-5.7.21-linux-glibc2.12-x86_64.tar.gz
    mv mysql-5.7.21-linux-glibc2.12-x86_64 ${install_dir}/${server_dir}
    chown -R mysql:mysql ${install_dir}/${server_dir}
    chown -R mysql:mysql ${log_dir}/${server_dir}

    sed -i '/^export MYSQL_HOME=/d' /etc/profile
    sed -i '/^export PATH=$MYSQL_HOME/d' /etc/profile
    
    echo "export MYSQL_HOME=${install_dir}/${server_dir}/bin" >> /etc/profile
    echo 'export PATH=$MYSQL_HOME:$PATH' >> /etc/profile
    source /etc/profile

    #设置配置文件
    echo "[client]
port = ${port}
socket = ${install_dir}/${server_dir}/mysql.sock

[mysqld]
port = ${port}
bind-address = 0.0.0.0
max_connections=5000
character_set_server= utf8mb4
lower_case_table_names=1
basedir=${install_dir}/${server_dir}
datadir=${install_dir}/${server_dir}/data
socket=${install_dir}/${server_dir}/mysql.sock
log-error=${log_dir}/${server_dir}/mysql.log
pid-file=${install_dir}/${server_dir}/mysql.pid" > /etc/my.cnf #这里改需要的配置
    chown mysql:mysql /etc/my.cnf
    
    xianzai=`pwd`
    #初始化脚本
    cd ${install_dir}/${server_dir}
    ./bin/mysqld --initialize --user=mysql --basedir=${install_dir}/${server_dir} --datadir=${install_dir}/${server_dir}/data --lc_messages_dir=${install_dir}/${server_dir}/share --lc_messages=en_US
    
    cd ${xianzai}
    #设置脚本
    test_bin man-mysql
    
    tail -n 1 ${log_dir}/${server_dir}/mysql.log | grep "root@localhost"
    [[ $? -eq 0 ]] || print_error "数据库初始化失败" "Database initialization failed"
    
    mysql_passwd=`tail -n 1  ${log_dir}/${server_dir}/mysql.log |  awk -F'@' '{print $2}' | cut -b 12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30`

    print_install_ok $1
	print_log "使用：man-mysql start" "Use：man-mysql start"
    print_log "账号：root" "account number：root"
    print_log "密码：${mysql_passwd}" "password：${mysql_passwd}"
	print_log "########################" "########################"
}

script_remove() {
    man-mysql stop
    userdel -r mysql
    rm -rf /etc/my.cnf
    rm -rf ${install_dir}/${server_dir}
    rm -rf /usr/local/bin/man-mysql
    
    sed -i '/^export MYSQL_HOME=/d' /etc/profile
    sed -i '/^export PATH=$MYSQL_HOME/d' /etc/profile

    print_remove_ok $1
}

script_info() {
	print_massage "名字：mysql-5.7" "Name：mysql-5.7"
	print_massage "版本：5.7.21" "Version：5.7.21"
	print_massage "介绍：Mysql是一款好用的关系型数据库" "Introduce：Mysql is a good relational database"
    print_massage "作者：日行一善" "do one good deed a day"
}
