#!/usr/bin/env bash



#[使用设置]
install_dir=no

log_dir=no

server_dir=no



script_get() {
    test_package https://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/glibc-2.14.1-rpm.tar.gz 1a68d013875737b9b9da1ff5f02c8581
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
    mkdir glibc-2.14
    cp -rf package/glibc-2.14.1-rpm.tar.gz glibc-2.14/
    cd glibc-2.14
    tar -xf glibc-2.14.1-rpm.tar.gz
    
    #必须这个顺序才行
    rpm -Uvh glibc-2.14.1-6.x86_64.rpm glibc-common-2.14.1-6.x86_64.rpm glibc-headers-2.14.1-6.x86_64.rpm glibc-devel-2.14.1-6.x86_64.rpm nscd-2.14.1-6.x86_64.rpm

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
