#!/usr/bin/env bash



#[使用设置]
#主目录，相当于/usr/local
#install_dir=

#服务目录名
server_dir=tomcat

server_rely="jdk-1.7"

port=8080



script_get() {
    test_package https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.8/src/apache-tomcat-7.0.8-src.tar.gz a2190918aa73c9b605c05812b523f405
}

script_install() {
    if [[ -f /usr/local/bin/man-tomcat ]];then
        print_massage "检测到当前系统已安装" "Detected that the current system is installed"
        exit
    fi

    test_detection

    script_get
    tar -xf package/apache-tomcat-7.0.8-src.tar.gz
    mv apache-tomcat-7.0.8-src ${install_dir}/${server_dir}
    chmod +x ${install_dir}/${server_dir}/bin/*
    
    #环境变量
    sed -i '/^TOMCAT_HOME=/d' /etc/profile
    sed -i '/^PATH=$TOMCAT_HOME/d' /etc/profile

    echo "TOMCAT_HOME=${install_dir}/${server_dir}/bin"  >> /etc/profile
    echo 'PATH=$TOMCAT_HOME:$PATH' >> /etc/profile
    source /etc/profile
    
    test_bin man-tomcat
    sed -i "2a prot=${port}" $command

    print_install_ok $1
	print_massage "使用：man-tomcat" "Use：man-tomcat"
	print_massage "访问：http://xx.xx.xx.xx:8080" "Visit: http://xx.xx.xx.xx:8080"
}

script_remove() {
    rm -rf /usr/local/bin/man-tomcat
    rm -rf ${install_dir}/${server_dir}
    print_remove_ok $1
}

script_info() {
	print_massage "名字：tomcat-7.0" "Name：tomcat-7.0"
	print_massage "版本：7.0.8" "Version：7.0.8"
	print_massage "介绍：Tomcat 是由 Apache 开发的一个 Servlet 容器" "Introduction: Tomcat is a Servlet container developed by Apache"
    print_massage "作者：日行一善" "do one good deed a day"
}
