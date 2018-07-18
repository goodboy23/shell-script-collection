#!/usr/bin/env bash



#[使用设置]

#主目录，相当于/usr/local
#install_dir=

#日志主目录，相当于/var/log
#log_dir=

#服务目录名
mysql_dir=mysql-5.6

#启动的端口
port=3306



script_get() {
     test_package "https://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.39-linux-glibc2.12-x86_64.tar.gz" "1bc406d2fe18dd877182a0bd603e7bd4"
}

script_install() {
    rpm -q mariadb-server 
    if [[ $? -eq 0 ]];then
        print_error "当前已有其它版本mariadb-server，请手动卸载" "There are other versions of mariadb-server currently, please uninstall manually"
        exit
    fi

    rpm -q mysql-server
    if [[ $? -eq 0 ]];then
        print_error "当前已有其它版本mysql-server，请手动卸载" "There are other versions of mysql-server currently, please uninstall manually"
        exit
    fi
   
    test_port 3306
    
    test_dir $mysql_dir

    #安装
    test_install autoconf libaio bison ncurses-devel
    groupadd mysql
    useradd -g mysql -s /sbin/nologin mysql
    
    #下载解压包
    script_get
    tar -xf package/mysql-5.6.39-linux-glibc2.12-x86_64.tar.gz
    mv mysql-5.6.39-linux-glibc2.12-x86_64 ${install_dir}/${mysql_dir}
    chown -R mysql:mysql ${install_dir}/${mysql_dir}
    chown -R mysql:mysql ${log_dir}/${mysql_dir}

    sed -i '/^export MYSQL_HOME=/d' /etc/profile
    sed -i '/^export PATH=$MYSQL_HOME/d' /etc/profile
    
    echo "export MYSQL_HOME=${install_dir}/${mysql_dir}/bin" >> /etc/profile
    echo 'export PATH=$MYSQL_HOME:$PATH' >> /etc/profile  
    source /etc/profile


    #设置配置文件
    echo "[mysql]
default-character-set=utf8
socket=${install_dir}/${mysql_dir}/mysql.sock
[mysqld]
skip-name-resolve
port = ${port}
socket=${install_dir}/${mysql_dir}/mysql.sock
basedir=${install_dir}/${mysql_dir}
datadir=${install_dir}/${mysql_dir}/data
max_connection=200
character-set-server=utf8
default-storage-engine=INNODB
lower_case_table_name=1
max_allowed_packet=16M
log-error=${log_dir}/${mysql_dir}/mysql.log
pid-file=${log_dir}/${mysql_dir}/mysql.pid
bind-address = 0.0.0.0" > /etc/my.cnf #这里改需要的配置
    chown mysql:mysql /etc/my.cnf
    
    #初始化脚本
    dangqian=`pwd`
    cd ${install_dir}/${mysql_dir}
    ./scripts/mysql_install_db --user=mysql --basedir=${install_dir}/${mysql_dir} --datadir=${install_dir}/${mysql_dir}/data
    [[ $? -eq 0 ]] || print_error "数据库初始化失败，请联系作者" "Database initialization failed, please contact the author"
    
    cd ${dangqian}
    #设置脚本
    test_bin man-mysql
    sed -i "2a install_dir=${install_dir}" /usr/local/bin/man-mysql
    sed -i "2a mysql_dir=${mysql_dir}" /usr/local/bin/man-mysql

	print_massage "mysql-5.6安装完成" "The mysql-5.6 is installed"
	print_massage "安装目录：${install_dir}/${mysql_dir}" "Install Dir：${install_dir}/${mysql_dir}"
    print_massage "日志目录：${log_dir}/${mysql_dir}" "Log directory：${log_dir}/${mysql_dir}"
	print_massage "使用：man-mysql start" "Use：man-mysql start"
}


script_remove() {
    man-mysql stop
    userdel -r mysql
    rm -rf /etc/my.cnf
    rm -rf ${install_dir}/${mysql_dir}
    rm -rf /usr/local/bin/man-mysql
    
    sed -i '/^export MYSQL_HOME=/d' /etc/profile
    sed -i '/^export PATH=$MYSQL_HOME/d' /etc/profile

    print_massage "mysql-5.6卸载完成！" "mysql-5.6 Uninstall completed！"
}

script_info() {
	print_massage "名字：mysql-5.6" "Name：mysql-5.6"
	print_massage "版本：5.6.39" "Version：5.6.39"
	print_massage "介绍：Mysql是一款好用的关系型数据库" "Introduce：Mysql is a good relational database"
    print_massage "作者：日行一善" "do one good deed a day"
}
