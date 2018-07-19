#!/usr/bin/env bash



#[使用设置]

#主目录，相当于/usr/local
#install_dir=

#服务目录名
apr_dir=apr



script_get() {
    test_package https://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/apr-1.6.3.tar.gz 57c6cc26a31fe420c546ad2234f22db4
}

script_install() {
    yum -y remove apr

    apr-1-config --version | grep 1.6
    if [[ $? -eq 0 ]];then
        print_massage "检测到已安装" "Detected installed"
        exit
    else
        apr-1-config --version
        if [[ $? -eq 0 ]];then
            print_error "当前已有其它版本apr，请手动卸载" "There are other versions of apr currently, please uninstall manually"
        fi
    fi

    test_install gcc make expat-devel
    test_dir $apr_dir

    script_get
    tar -xf package/apr-1.6.3.tar.gz
    cd  apr-1.6.3
    ./configure -prefix=/usr/local/apr
    [[ -f Makefile ]] || print_error "Makefile生成失败，请联系作者" "Makefile failed to generate, please contact the author"
    make && make install
    
    cd ..
    rm -rf apr-1.6.3
    
    #环境变量
    sed -i '/^export APR_HOME=/d' /etc/profile
    sed -i '/^export PATH=${APR_HOME}/d' /etc/profile
    
    echo "export APR_HOME=${install_dir}/${apr_dir}" >> /etc/profile
    echo 'export PATH=${APR_HOME}/bin:${PATH}' >> /etc/profile
    source /etc/profile
    
    apr-1-config --version
    [[ $? -eq 0 ]] || print_error "apr-1.6安装失败，请联系作者" "apr-1.6 installation failed, please check the script"

	print_massage "apr-1.6安装完成" "The apr-1.6 is installed"
	print_massage "安装目录：${install_dir}/${apr_dir}" "Install Dir：${install_dir}/${apr_dir}"
	print_massage "验证：apr-1-config" "verification：apr-1-config"
}

script_remove() {
	rm -rf ${install_dir}/${apr_dir}
    
    sed -i '/^export APR_HOME=/d' /etc/profile
    sed -i '/^export PATH=${APR_HOME}/d' /etc/profile
    source /etc/profile
    
    apr-1-config --version
    [[ $? -eq 0 ]] && print_error "apr-1.6未成功删除，请联系作者" "apr-1.6 was not successfully deleted, please contact the author" || print_massage "apr-1.6卸载完成！" "apr-1.6 Uninstall completed！"
}

script_info() {
	print_massage "名字：apr-1.6" "Name：apr-1.6"
	print_massage "版本：1.6.3" "Version：1.6.3"
	print_massage "介绍：Apache可移植运行" "Introduce：Apache portable operation"
	print_massage "作者：日行一善" "do one good deed a day"
}
