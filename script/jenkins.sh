#!/usr/bin/env bash
#jenkins基本环境


#[使用设置]
#主目录，相当于/usr/local
#install_dir=

#日志主目录，相当于/var/log
#log_dir=

#服务目录名
jenkins_dir=jenkins

#开启的端口号
port=8080

#默认监听所有
listen=0.0.0.0



script_get() {
    test_package http://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/jenkins.war 08386ff41dbf7dd069c750f3484cc140
}

script_install() {
    if [[ -f /usr/local/bin/man-jenkins ]];then
        print_massage "检测到当前系统已安装" "Detected that the current system is installed"
        exit
    fi
    
    test_port 8080
    test_dir $jenkins_dir
    
    #安装依赖和包
    test_rely jdk-1.8 maven-3.5 ant-1.9
    get_jenkins
    mkdir ${install_dir}/${jenkins_dir}
    cp package/jenkins.war ${install_dir}/${jenkins_dir}/
    
    #配置启动脚本
    test_bin man-jenkins

    sed -i "2a port=$port" $command
    sed -i "3a listen=$listen" $command
    sed -i "4a install_dir=$install_dir" $command
    sed -i "5a log_dir=$log_dir" $command
    sed -i "6a jenkins_dir=$jenkins_dir" $command

    print_massage "jenkins安装完成" "The jenkins is installed"
	print_massage "安装目录：${install_dir}/${jenkins_dir}" "Install Dir：${install_dir}/${jenkins_dir}"
    print_massage "日志目录：${log_dir}/${jenkins_dir}" "Log directory：${log_dir}/${jenkins_dir}"
	print_massage "使用：man-jenkins start" "Use：man-jenkins start"
	print_massage "访问：curl http://127.0.0.1:${port}" "Access：curl http://127.0.0.1:${port}"
    print_massage "java maven ant环境配置完毕" "Java maven ant environment is configured"
}

script_remove() {
	rm -rf /usr/local/bin/man-jenkins
	rm -rf ${install_dir}/${jenkins_dir}

	print_massage "jenkins卸载完成！" "jenkins Uninstall completed！"
}

script_info() {
    print_massage "名字：jenkins" "Name：jenkins"
	print_massage "版本：2.104" "Version：2.104"
	print_massage "介绍：Jenkins是持续与集成服务" "Introduce：Jenkins is a continuous and integrated service"
	print_massage "作者：速度与激情小组---Linux部" "Author：Speed and Passion Group --- Linux Department"
}