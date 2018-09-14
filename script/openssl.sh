#!/usr/bin/env bash



#[使用设置]

#主目录，相当于/usr/local
#install_dir=

log_dir=no

#服务目录名
server_dir=openssl

server_yum="gcc make perl perl-devel"


script_get() {
    test_package https://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/openssl-1.0.2o.tar.gz 44279b8557c3247cbe324e2322ecd114
}

script_install() {
    openssl version -a | head -n 1 |grep 1.0
    if [[ $? -eq 0 ]];then
        print_massage "检测到已安装" "Detected installed"
        exit
    else
        which openssl
        if [[ $? -eq 0 ]];then
            print_error "当前已有其它版本openssl，请手动卸载" "There are other versions of openssl currently, please uninstall manually"
        fi
    fi

    #依赖
	test_detection ${1}
    
    script_get
	rm -rf openssl-1.0.2o
    tar -xf package/openssl-1.0.2o.tar.gz
    cd openssl-1.0.2o
    ./config -fPIC --prefix=${install_dir}/${server_dir} enable-shared 
	[[ -f Makefile ]] || print_error "Makefile生成失败" "Makefile failed to generate"
	make && make install || print_error "make操作失败" "make operation failed"

    cd ..
    rm -rf openssl-1.0.2o
 
    #环境变量
    sed -i '/^export OPENSSL_HOME=/d' /etc/profile
    sed -i '/^export PATH=${OPENSSL_HOME}/d' /etc/profile
    
    echo "export OPENSSL_HOME=${install_dir}/${server_dir}/bin" >> /etc/profile
    echo 'export PATH=${OPENSSL_HOME}:${PATH}' >> /etc/profile
    source /etc/profile
    
    openssl version -a
    [[ $? -eq 0 ]] || print_error "${1}安装失败" "${1} installation failed"

	print_install_ok $1
	print_log "验证：openssl" "verification：openssl"
	print_log "########################" "########################"
}

script_remove() {
	rm -rf ${install_dir}/${server_dir}
    
    sed -i '/^export OPENSSL_HOME=/d' /etc/profile
    sed -i '/^export PATH=${OPENSSL_HOME}/d' /etc/profile
    
    print_remove_ok $1
}

script_info() {
	print_massage "名字：openssl" "Name：openssl"
	print_massage "版本：1.0.2o" "Version：1.0.2o"
	print_massage "介绍：OpenSSL 是一个安全套接字层密码库" "Introduce：OpenSSL is a Secure Sockets Layer Password Library"
	print_massage "作者：日行一善" "do one good deed a day"
}
