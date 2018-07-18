#!/usr/bin/env bash



#[使用设置]
#主目录，相当于/usr/local
#install_dir=

#服务目录名
tomcat_dir=tomcat



script_get() {
    test_package https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.8/src/apache-tomcat-7.0.8-src.tar.gz a2190918aa73c9b605c05812b523f405
}

script_install() {
    if [[ -f /usr/local/bin/man-tomcat ]];then
        print_massage "检测到当前系统已安装" "Detected that the current system is installed"
        exit
    fi
    
    test_port 8080
    test_rely jdk-1.7
    
    test_dir ${tomcat_dir}

    script_get
    tar -xf package/apache-tomcat-7.0.8-src.tar.gz
    mv apache-tomcat-7.0.8-src ${install_dir}/${tomcat_dir}

    test_bin man-tomcat
    sed "2a install_dir=${install_dir}" /usr/local/bin/man-tomcat
    sed "3a tomcat_dir=${tomcat_dir}" /usr/local/bin/man-tomcat
    
    
	print_massage "tomcat-7.0安装完成" "The tomcat-7.0 is installed"
	print_massage "安装目录：${install_dir}/${tomcat_dir}" "Install Dir：${install_dir}/${tomcat_dir}"
	print_massage "使用：man-tomcat" "Use：man-tomcat"
	print_massage "访问：curl http://127.0.0.1:8080" "Visit: curl http://127.0.0.1:8080"
}

script_remove() {
    rm -rf /usr/local/bin/man-tomcat
    rm -rf ${install_dir}/${tomcat_dir}
    print_massage "tomcat-7.0卸载完成！" "tomcat-7.0 Uninstall completed！"
}

script_info() {
	print_massage "名字：tomcat-7.0" "Name：tomcat-7.0"
	print_massage "版本：7.0.8" "Version：7.0.8"
	print_massage "介绍：Tomcat 是由 Apache 开发的一个 Servlet 容器" "Introduction: Tomcat is a Servlet container developed by Apache"
    print_massage "作者：日行一善" "do one good deed a day"
}
