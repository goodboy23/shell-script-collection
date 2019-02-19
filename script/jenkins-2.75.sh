#!/usr/bin/env bash


#[使用设置]
#主目录，相当于/usr/local
#install_dir=

#日志主目录，相当于/var/log
#log_dir=

#服务目录名
server_dir=jenkins

#开启的端口号
port=8080

#默认监听所有
listen=0.0.0.0

#内部依赖
server_rely="jdk-1.8 maven-3.5 ant-1.9 gradle sbt"



script_get() {
    test_package https://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/jenkins-2.75.war f1f95109a5dec0131ff070cb64a31d63
}

script_install() {
    if [[ -f /usr/local/bin/man-jenkins ]];then
        print_massage "检测到当前系统已安装" "Detected that the current system is installed"
        exit
    fi
    
	test_detection ${1}

    script_get
    mkdir ${install_dir}/${server_dir}
    cp -p package/jenkins.war ${install_dir}/${server_dir}/
    
    #配置启动脚本
    test_bin man-jenkins
    sed -i "2a port=$port" $command
    sed -i "3a listen=$listen" $command
    
    #验证
    [[ -f ${install_dir}/${server_dir}/jenkins.war ]] || print_error "安装失败" "Installation failed"
    
    print_install_ok $1
	print_log "使用：man-jenkins start" "Use：man-jenkins start"
	print_log "访问：http://xx.xx.xx.xx:${port}" "Access：http://xx.xx.xx.xx:${port}"
	print_log "########################" "########################"
}

script_remove() {
    man-jenkins stop
	rm -rf /usr/local/bin/man-jenkins
	rm -rf ${install_dir}/${server_dir}

	print_remove_ok $1
}

script_info() {
    print_massage "名字：jenkins-2.75" "Name：jenkins-2.75"
	print_massage "版本：2.75" "Version：2.75"
	print_massage "介绍：Jenkins是持续与集成服务" "Introduce：Jenkins is a continuous and integrated service"
    print_massage "作者：日行一善" "do one good deed a day"
}
