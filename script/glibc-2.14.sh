#!/usr/bin/env bash



#[使用设置]
install_dir=/usr/local

log_dir=no

server_dir=glibc

server_yum="gcc cmake"



script_get() {
    test_package http://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/glibc-2.14.tar.gz 4657de6717293806442f4fdf72be821b
}

script_install() {
    #检测目录
    strings /lib64/libc.so.6 |grep ^GLIBC_2.14
    if [[ $? -eq 0 ]];then
        print_massage "检测到当前系统已安装" "Detected that the current system is installed"
        exit
    fi
    
	#依赖
	test_detection ${1}
	
    #安装服务
    script_get
	rm -rf glibc-2.14
    tar -xf package/glibc-2.14.tar.gz
    cd glibc-2.14
    mkdir build
    cd build
    ../configure --prefix=${install_dir}/${server_dir} --disable-profile --enable-add-ons --with-headers=/usr/include --with-binutils=/usr/bin
	[[ -f Makefile ]] || print_error "Makefile生成失败" "Makefile failed to generate"
	make && make altinstall || print_error "make操作失败" "make operation failed"

	cd ${ssc_dir}
    rm -rf glibc-2.14
    
    #测试
	strings /lib64/libc.so.6 |grep ^GLIBC_2.14 || print_error "glibc-2.14安装失败" "Glibc-2.14 installation failed"

    #完成
    print_install_ok $1
	print_log "########################" "########################"
}

script_remove() {
	print_massage "暂时无法卸载！" "Unable to uninstall now!"
}

script_info() {
    print_massage "名字：glibc-2.14" "Name：glibc-2.14"
    print_massage "版本：2.14" "Version：2.14"
    print_massage "介绍：glibc是GNU发布的libc库，即c运行库" "Introduction: Glibc is the libc library released by GNU, ie the c runtime library"
    print_massage "作者：日行一善" "do one good deed a day"
}