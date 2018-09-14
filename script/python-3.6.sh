#!/usr/bin/env bash


#[使用设置]
#install_dir=

log_dir=no

server_dir=python-3.6

server_yum="gcc make cmake openssl-devel bzip2-devel expat-devel gdbm-devel readline-devel sqlite-devel"



script_get() {
	test_package https://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/Python-3.6.0.tgz 3f7062ccf8be76491884d0e47ac8b251
}

script_install() {
    python3.6 --version
    if [[ $? -eq 0 ]];then
        print_massage "检测到当前系统已安装" "Detected that the current system is installed"
        exit
    fi
    
	#依赖
	test_detection ${1}
    
    #编译安装
    script_get
	rm -rf Python-3.6.0
	tar -xf package/Python-3.6.0.tgz
	cd Python-3.6.0
	./configure --prefix=${install_dir}/${server_dir}
	[[ -f Makefile ]] || print_error "Makefile生成失败" "Makefile failed to generate"
	make && make altinstall || print_error "make操作失败" "make operation failed"
	
	cd ${ssc_dir}
	rm -rf Python-3.6.0
	
	ln -s ${install_dir}/${server_dir}/bin/python3.6 /usr/bin/python3.6
    ln -s ${install_dir}/${server_dir}/bin/python3.6 /usr/bin/python3
	
	#测试
	python3.6 --version
	[ $? -eq 0 ] || print_error "安装失败" "2.Installation failed"
    
    print_install_ok $1
	print_log "使用：python3.6" "Use：python3.6"
	print_log "########################" "########################"
}

script_remove() {
	rm -rf ${install_dir}/${server_dir}
    rm -rf /usr/bin/python3.6
    rm -rf /usr/bin/python3
	
    print_remove_ok $1
}

script_info() {
	print_massage "名字：python-3.6" "Name：python-3.6"
	print_massage "版本：3.6" "Version：3.6"
	print_massage "介绍：Python是一种解释型、面向对象、动态数据类型的高级程序设计语言" "Introduce：Python is an interpretive, object-oriented, dynamic data type high-level programming language"
    print_massage "作者：日行一善" "do one good deed a day"
}
