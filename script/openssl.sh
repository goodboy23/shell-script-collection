#!/usr/bin/env bash



#[使用设置]

#主目录，相当于/usr/local
#install_dir=

#服务目录名
openssl_dir=openssl



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

    test_dir $openssl_dir
    test_install gcc make perl perl-devel
    
    script_get
    tar -xf package/openssl-1.0.2o.tar.gz
    cd openssl-1.0.2o
    ./config -fPIC --prefix=${install_dir}/${openssl_dir} enable-shared && make && make install
    [[ -f ${install_dir}/${openssl_dir}/bin/openssl ]] || print_error "编译失败，请联系作者" "Compilation failed, please contact the author"
    cd ..
    rm -rf openssl-1.0.2o
 
    #环境变量
    sed -i '/^export OPENSSL_HOME=/d' /etc/profile
    sed -i '/^export PATH=${OPENSSL_HOME}/d' /etc/profile
    
    echo "export OPENSSL_HOME=${install_dir}/${openssl_dir}/bin" >> /etc/profile
    echo 'export PATH=${OPENSSL_HOME}:${PATH}' >> /etc/profile
    source /etc/profile
    
    openssl version -a
    [[ $? -eq 0 ]] || print_error "openssl安装失败，请联系作者" "openssl installation failed, please check the script"

	print_massage "openssl安装完成" "The openssl is installed"
	print_massage "安装目录：${install_dir}/${openssl_dir}" "Install Dir：${install_dir}/${openssl_dir}"
	print_massage "验证：openssl" "verification：openssl"
}

script_remove() {
	rm -rf ${install_dir}/${openssl_dir}
    
    sed -i '/^export OPENSSL_HOME=/d' /etc/profile
    sed -i '/^export PATH=${OPENSSL_HOME}/d' /etc/profile
    source /etc/profile
    
    ant -version
    [[ $? -eq 0 ]] && print_error "openssl未成功删除，请联系作者" "openssl was not successfully deleted, please contact the author" || print_massage "openssl卸载完成！" "openssl Uninstall completed！"
}

script_info() {
	print_massage "名字：openssl" "Name：openssl"
	print_massage "版本：1.0.2o" "Version：1.0.2o"
	print_massage "介绍：OpenSSL 是一个安全套接字层密码库" "Introduce：OpenSSL is a Secure Sockets Layer Password Library"
	print_massage "作者：日行一善" "do one good deed a day"
}
