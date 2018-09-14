#!/usr/bin/env bash



#[使用设置]
#install_dir=

log_dir=no

server_dir=ant

server_rely="jdk-1.8"



script_get() {
    test_package https://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/apache-ant-1.9.11-bin.tar.gz 07946e9d2d342f3ddfc7cb41c9896401
}

script_install() {
    ant -version | grep 1.9
    if [[ $? -eq 0 ]];then
        print_massage "检测到已安装" "Detected installed"
        exit
    else
        ant -version
        if [[ $? -eq 0 ]];then
            print_error "当前已有其它版本ant" "There are other versions of ant currently"
        fi
    fi

	#依赖
	test_detection ${1}

	#部署
    script_get
	rm -rf apache-ant-1.9.11
    tar -xf package/apache-ant-1.9.11-bin.tar.gz
    mv apache-ant-1.9.11 ${install_dir}/${server_dir}

    
    #环境变量
    sed -i '/^export ANT_HOME=/d' /etc/profile
    sed -i '/^export PATH=${ANT_HOME}/d' /etc/profile
    
    echo "export ANT_HOME=${install_dir}/${server_dir}" >> /etc/profile
    echo 'export PATH=${ANT_HOME}/bin:${PATH}' >> /etc/profile
    source /etc/profile
    
    ant -version
    [[ $? -eq 0 ]] || print_error "${1}安装失败" "${1} installation failed"

	print_install_ok $1
	print_log "验证：ant -version" "verification：ant -version"
	print_log "########################" "########################"
}

script_remove() {
	rm -rf ${install_dir}/${server_dir}
    
    sed -i '/^export ANT_HOME=/d' /etc/profile
    sed -i '/^export PATH=${ANT_HOME}/d' /etc/profile
    
    print_remove_ok $1
}

script_info() {
	print_massage "名字：ant-1.9" "Name：ant-1.9"
	print_massage "版本：1.9" "Version：1.9"
	print_massage "介绍：Ant是Java的生成工具,是Apache的核心项目" "Introduce：Ant is a Java generation tool and a core Apache project"
	print_massage "作者：日行一善" "do one good deed a day"
}