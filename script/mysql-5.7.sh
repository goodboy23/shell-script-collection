#!/usr/bin/env bash



#[使用设置]

#主目录，相当于/usr/local
#install_dir=

#日志主目录，相当于/var/log
#log_dir=

#服务目录名
mysql_dir=mysql-5.7

#启动的端口
port=3306



script_get() {
     test_package "https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.21-linux-glibc2.12-x86_64.tar.gz" "69b1d94f33c05b73cf72d557e484e2dc"
}

script_install() {
    rpm -q mariadb
    if [[ $? -eq 0 ]];then
        print_massage "1.检测到当前系统已安装" "1.Detected that the current system is installed"
        exit
    fi

    rpm -q mysql
    if [[ $? -eq 0 ]];then
        print_massage "2.检测到当前系统已安装" "2.Detected that the current system is installed"
        exit
    fi
    
    mysql -V
    if [[ $? -eq 0 ]];then
        print_massage "3.检测到当前系统已安装" "3.Detected that the current system is installed"
        exit
    fi
    
    test_port 3306
    
    test_dir $mysql_dir
    
    #清理mariadb的东西
    for i in `rpm -qa | grep mariadb`; do rpm -e --nodeps $i; done

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
    mysql -V
    [[ $? -eq 0 ]] || print_error "4.mysql环境变量设置失败，请检查脚本" "4.Mysql environment variable setting failed, please check the script"

    #设置配置文件
    echo "[client]
port = ${port}
socket = ${install_dir}/${mysql_dir}/mysql.sock

[mysqld]
port = ${port}
bind-address = 0.0.0.0
character_set_server=utf8
init_connect='SET NAMES utf8'
basedir=${install_dir}/${mysql_dir}
datadir=${install_dir}/${mysql_dir}/data
socket=${install_dir}/${mysql_dir}/mysql.sock
log-error=${log_dir}/${mysql_dir}/mysqld.log
pid-file=${install_dir}/${mysql_dir}/mysqld.pid" > /etc/my.cnf #这里改需要的配置
    chown mysql:mysql /etc/my.cnf
    
    xianzai=`pwd`
    #初始化脚本
    cd ${install_dir}/${mysql_dir}
    ./bin/mysqld --initialize --user=mysql --basedir=${install_dir}/${mysql_dir} --datadir=${install_dir}/${mysql_dir}/data --lc_messages_dir=${install_dir}/${mysql_dir}/share --lc_messages=en_US

    cd ${xianzai}
    #设置脚本
    test_bin man-mysql
    sed -i "2a install_dir=${install_dir}" /usr/local/bin/man-mindoc
    sed -i "2a mysql_dir=${mysql_dir}" /usr/local/bin/man-mindoc

    
    tail -n 1 ${log_dir}/${mysql_dir}/mysql.log | grep "root@localhost"
    [[ $? -eq 0 ]] || print_error "5.初始化数据库失败，请检查脚本" "5. Failed to initialize the database, please check the script"
    
    mysql_passwd=`tail -n 1 /var/log/mysql/mysql.log |  awk -F'@' '{print $2}' | cut -b 12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30`

	print_massage "mysql-5.7安装完成" "The mysql-5.7 is installed"
	print_massage "安装目录：${install_dir}/${mysql_dir}" "Install Dir：${install_dir}/${mysql_dir}"
    print_massage "日志目录：${log_dir}/${mysql_dir}" "Log directory：${log_dir}/${mysql_dir}"
	print_massage "使用：man-mysql start" "Use：man-mysql start"
    print_massage "账号：root" "account number：root"
    print_massage "密码：${mysql_passwd}" "password：${mysql_passwd}"
}

script_remove() {
    man-mysql stop
    userdel -r mysql
    rm -rf /etc/my.cnf
    rm -rf ${install_dir}/${mysql_dir}
    rm -rf /usr/local/bin/man-mysql
    
    sed -i '/^export MYSQL_HOME=/d' /etc/profile
    sed -i '/^export PATH=$MYSQL_HOME/d' /etc/profile

    mysql -V
    [[ $? -eq 0 ]] && print_error "1.mysql-5.7未成功删除，请检查脚本" "1.mysql-5.7 unsuccessfully deleted, please check the script" || print_massage "mysql-5.6卸载完成！" "mysql-5.6 Uninstall completed！"
}

script_info() {
	print_massage "名字：mysql-5.7" "Name：mysql-5.7"
	print_massage "版本：5.7.21" "Version：5.7.21"
	print_massage "介绍：Mysql是一款好用的关系型数据库" "Introduce：Mysql is a good relational database"
    print_massage "作者：日行一善" "do one good deed a day"
}
