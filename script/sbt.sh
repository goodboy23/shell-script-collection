#!/usr/bin/env bash



#[使用设置]
#主目录，相当于/usr/local
#install_dir=

log_dir=no

#服务目录名
server_dir=sbt

server_rely="jdk-1.8"



script_get() {
    test_package https://piccolo.link/sbt-1.1.5.tgz b771480feb07f98fa8cd6d787c8d4485
}

script_install() {
    which sbt
    if [[ $? -eq 0 ]];then
        print_massage "检测到已安装" "Detected installed"
        exit
    fi
    
    #依赖
	test_detection ${1}
    
    script_get
	rm -rf sbt
	tar -xf package/sbt-1.1.5.tgz
	mv sbt ${install_dir}/${server_dir}
	
	cd ${install_dir}/${server_dir}
	echo '#!/bin/bash' >> sbt
	echo 'SBT_OPTS="-Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M"' >> sbt
	echo 'Java $SBT_OPTS -jar /usr/local/sbt/bin/sbt-launch.jar "$@"' >> sbt
	chmod +x sbt
    
    #清理环境变量
    sed -i '/^export SBT_HOME=/d' /etc/profile
    sed -i '/^export PATH=${SBT_HOME}/d' /etc/profile
    
    echo "export SBT_HOME=${install_dir}/${server_dir}" >> /etc/profile
    echo 'export PATH=${SBT_HOME}/bin:${PATH}' >> /etc/profile
    source /etc/profile
    
    which sbt
    [[ $? -eq 0 ]] || print_error "${1}安装失败" "${1} installation failed"
    
    print_install_ok $1
	print_log "使用：sbt sbt-version" "Use：sbt sbt-version"
	print_log "########################" "########################"
}

script_remove() {
    rm -rf ${install_dir}/${server_dir}
    sed -i '/^export SBT_HOME=/d' /etc/profile
    sed -i '/^export PATH=${SBT_HOME}/d' /etc/profile
    
    print_remove_ok $1
}

script_info() {
	print_massage "名字：sbt" "Name：sbt"
	print_massage "版本：1.1.5" "Version：1.1.5"
	print_massage "介绍：SBT是SCALA 平台上标准的项目构建工具" "Introduction: SBT is a standard project build tool on the SCALA platform"
    print_massage "作者：日行一善" "do one good deed a day"
}
