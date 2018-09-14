#!/usr/bin/env bash



#[使用设置]

#主目录，相当于/usr/local
#install_dir=

log_dir=no

#服务目录名
server_dir=pcre

#yum依赖
server_yum="gcc make expat-devel gcc-c++"



script_get() {
    test_package https://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/pcre-8.42.tar.gz fc18afa0f14a25475cf097ee102a3e4f
}

script_install() {
    pcre-config --version | grep 8
    if [[ $? -eq 0 ]];then
        print_massage "检测到已安装" "Detected installed"
        exit
    else
        pcre-config --version
        if [[ $? -eq 0 ]];then
            print_error "当前已有其它版本pcre，请手动卸载" "There are other versions of pcre currently, please uninstall manually"
        fi
    fi
	
	#依赖
	test_detection ${1}
    
    script_get
	rm -rf pcre-8.42
    tar -xf package/pcre-8.42.tar.gz
    cd  pcre-8.42
    ./configure -prefix=${install_dir}/${server_dir}
    [[ -f Makefile ]] || print_error "Makefile生成失败" "Makefile failed to generate"
    make && make install || print_error "make操作失败" "make operation failed"
    
    cd ..
    rm -rf pcre-8.42
    
    #环境变量
    sed -i '/^export PCRE_HOME=/d' /etc/profile
    sed -i '/^export PATH=${PCRE_HOME}/d' /etc/profile
    
    echo "export APR_HOME=${install_dir}/${server_dir}" >> /etc/profile
    echo 'export PATH=${PCRE_HOME}/bin:${PATH}' >> /etc/profile
    source /etc/profile
    
    apr-1-config --version
    [[ $? -eq 0 ]] || print_error "${1}安装失败" "${1} installation failed"

    print_install_ok
	print_log "验证：pcre-config" "verification：pcre-config"
	print_log "########################" "########################"
}

script_remove() {
	rm -rf ${install_dir}/${server_dir}
    
    sed -i '/^export PCRE_HOME=/d' /etc/profile
    sed -i '/^export PATH=${PCRE_HOME}/d' /etc/profile

    print_remove_ok $1
}

script_info() {
	print_massage "名字：pcre-8" "Name：pcre-8"
	print_massage "版本：8.42" "Version：8.42"
	print_massage "介绍：pcre是一个c语言正规匹配库" "Introduce：Pcre is a c language regular matching library"
	print_massage "作者：日行一善" "do one good deed a day"
}