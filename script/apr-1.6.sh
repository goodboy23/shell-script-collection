#!/usr/bin/env bash



#[使用设置]

#主目录，相当于/usr/local
#install_dir=

log_dir=no

#服务目录名
server_dir=apr

#依赖
server_yum="gcc make expat-devel"



script_get() {
    test_package https://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/apr-1.6.3.tar.gz 57c6cc26a31fe420c546ad2234f22db4
}

script_install() {
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

	#依赖
    test_port ${port}
    test_dir ${server_dir}
    test_rely ${server_rely}
    test_install ${server_yum}

	#部署
    script_get
	rm -rf apr-1.6.3
    tar -xf package/apr-1.6.3.tar.gz
    cd  apr-1.6.3
    ./configure -prefix=${install_dir}/${server_dir} || print_error "Makefile生成失败" "Makefile failed to generate"
    make && make install || print_error "make操作失败" "make operation failed"
 
    cd $ssc_dir
    rm -rf apr-1.6.3
    
    #环境变量
    sed -i '/^export APR_HOME=/d' /etc/profile
    sed -i '/^export PATH=${APR_HOME}/d' /etc/profile
    
    echo "export APR_HOME=${install_dir}/${server_dir}" >> /etc/profile
    echo 'export PATH=${APR_HOME}/bin:${PATH}' >> /etc/profile
    source /etc/profile
    
    apr-1-config --version
    [[ $? -eq 0 ]] || print_error "${1}安装失败" "${1} installation failed"

	print_install_ok $1
	print_log "验证：apr-1-config" "verification：apr-1-config"
	print_log "########################" "########################"
}

script_remove() {
	rm -rf ${install_dir}/${server_dir}
    
    sed -i '/^export APR_HOME=/d' /etc/profile
    sed -i '/^export PATH=${APR_HOME}/d' /etc/profile
    source /etc/profile
    
    print_remove_ok $1
}

script_info() {
	print_massage "名字：apr-1.6" "Name：apr-1.6"
	print_massage "版本：1.6.3" "Version：1.6.3"
	print_massage "介绍：Apache可移植运行" "Introduce：Apache portable operation"
	print_massage "作者：日行一善" "do one good deed a day"
}
