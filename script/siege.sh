#!/usr/bin/env bash



#安装目录
#install_dir=

log_dir=no

#服务目录
server_dir=siege

server_yum="gcc cmake"



script_get() {
    test_package "http://download.joedog.org/siege/siege-2.70.tar.gz" "835c7a0606851357ebf03084ff546310"
}

script_install() {
    siege -V
    if [[ $? -eq 0 ]];then
        print_massage "检测到已安装" "Detected installed"
        exit
    fi
	
	#依赖
	test_detection ${1}
    
    script_get
	rm -rf siege-2.70
	rm -rf /usr/local/man
	mkdir /usr/local/man
	
	tar -xf package/siege-2.70.tar.gz
	cd siege-2.70
	./configure --prefix=${install_dir}/${server_dir} || print_error "Makefile生成失败" "Makefile failed to generate"
	make || print_error "make操作失败" "make operation failed"
	make install || mkdir ${install_dir}/${server_dir}/etc
	make install || print_error "make install操作失败" "make install operation failed"

	#环境变量
    sed -i '/^export SIEGE_HOME=/d' /etc/profile
    sed -i '/^export PATH=${SIEGE_HOME}/d' /etc/profile
    
    echo "export SIEGE_HOME=${install_dir}/${server_dir}" >> /etc/profile
    echo 'export PATH=${SIEGE_HOME}/bin:${PATH}' >> /etc/profile
    source /etc/profile
	
	cd ..
	rm -rf siege-2.70

    #对结果进行测试
    siege -V
    [[ $? -eq 0 ]] || print_error "安装失败" "2.Installation failed"
    
    print_install_ok $1
	print_log "使用：siege -V" "Use：siege -V"
	print_log "########################" "########################"
}

script_remove() {
    rm -rf ${install_dir}/${server_dir}
	
	sed -i '/^export SIEGE_HOME=/d' /etc/profile
    sed -i '/^export PATH=${SIEGE_HOME}/d' /etc/profile

    print_remove_ok $1
}

script_info() {
	print_massage "名字：siege" "Name：siege"
	print_massage "版本：2.70" "Version：2.70"
	print_massage "介绍：Siege是一个多线程http负载测试和基准测试工具。" "Introduce：Siege是一个多线程http负载测试和基准测试工具。"
    print_massage "作者：日行一善" "do one good deed a day"
}