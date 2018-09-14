#!/usr/bin/env bash



#[使用设置]
#主目录，相当于/usr/local
#install_dir=

log_dir=no

#服务目录名
server_dir=gradle

server_rely="jdk-1.8"



script_get() {
    test_package https://downloads.gradle.org/distributions/gradle-4.10-all.zip e62bdabcfa5d286ae8b8f693711ce83e
}

script_install() {
    which gradle
    if [[ $? -eq 0 ]];then
        print_massage "检测到已安装" "Detected installed"
        exit
    fi
    
    #依赖
	test_detection ${1}
	
    script_get
	rm -rf gradle-4.10
    unzip package/gradle-4.10-all.zip
	mv gradle-4.10  ${install_dir}/${server_dir}

    #清理环境变量
    sed -i '/^export GRADLE_HOME=/d' /etc/profile
    sed -i '/^export PATH=${GRADLE_HOME}/d' /etc/profile
    
    echo "export GRADLE_HOME=${install_dir}/${server_dir}" >> /etc/profile
    echo 'export PATH=${GRADLE_HOME}/bin:${PATH}' >> /etc/profile
    source /etc/profile
    
    which gradle
    [[ $? -eq 0 ]] || print_error "${1}安装失败" "${1} installation failed"
    
    print_install_ok $1
	print_log "使用：gradle -version" "Use：gradle -version"
	print_log "########################" "########################"
}

script_remove() {
    rm -rf ${install_dir}/${server_dir}
    sed -i '/^export GRADLE_HOME=/d' /etc/profile
    sed -i '/^export PATH=${GRADLE_HOME}/d' /etc/profile
    
    print_remove_ok $1
}

script_info() {
	print_massage "名字：gradle" "Name：gradle"
	print_massage "版本：4.10" "Version：4.10"
	print_massage "介绍：基于DSL语法的自动化构建工具" "Introduction: Automated build tool based on DSL syntax"
    print_massage "作者：日行一善" "do one good deed a day"
}
