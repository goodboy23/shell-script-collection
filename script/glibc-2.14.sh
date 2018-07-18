#!/usr/bin/env bash



#[使用设置]
install_dir=/usr/local

glibc_dir=glibc


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

    test_install gcc cmake
    test_dir $glibc_dir
    
    #安装服务
    script_get
    tar -xf package/glibc-2.14.tar.gz
    cd glibc-2.14
    mkdir build
    cd build
    ../configure --prefix=${install_dir}/${glibc_dir}
    make && make install
    cd ..
    cd ..
    rm -rf glibc-2.14
    
    #测试
    [[ -f ${install_dir}/${glibc_dir}/lib/libc-2.14.so ]] || print_error "glibc-2.14安装失败，请联系作者" "Glibc-2.14 installation failed, please contact the author"
    
    #清除软连接
    rm -rf /lib64/libc.so.6
    ln -s /usr/local/glibc-2.14/lib/libc-2.14.so /lib64/libc.so.6

    #完成
    print_massage "glibc-2.14安装完成" "The glibc-2.14 is installed"
    print_massage "安装目录：/usr/local/glibc-2.14" "Install Dir：/usr/local/glibc-2.14"
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