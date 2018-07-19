#!/usr/bin/env bash



#[使用设置]

#主目录，相当于/usr/local
#install_dir=

#服务目录名
pcre_dir=pcre



script_get() {
    test_package https://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/pcre-8.42.tar.gz fc18afa0f14a25475cf097ee102a3e4f
}

script_install() {
    yum -y remove pcre

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

    test_install gcc make expat-devel gcc-c++
    test_dir $pcre_dir

    script_get
    tar -xf package/pcre-8.42.tar.gz
    cd  pcre-8.42
    ./configure -prefix=/usr/local/pcre
    [[ -f Makefile ]] || print_error "Makefile生成失败，请联系作者" "Makefile failed to generate, please contact the author"
    make && make install
    
    cd ..
    rm -rf pcre-8.42
    
    #环境变量
    sed -i '/^export PCRE_HOME=/d' /etc/profile
    sed -i '/^export PATH=${PCRE_HOME}/d' /etc/profile
    
    echo "export APR_HOME=${install_dir}/${pcre_dir}" >> /etc/profile
    echo 'export PATH=${PCRE_HOME}/bin:${PATH}' >> /etc/profile
    source /etc/profile
    
    apr-1-config --version
    [[ $? -eq 0 ]] || print_error "pcre-8安装失败，请联系作者" "pcre-8 installation failed, please check the script"

	print_massage "pcre-8安装完成" "The pcre-8 is installed"
	print_massage "安装目录：${install_dir}/${pcre_dir}" "Install Dir：${install_dir}/${pcre_dir}"
	print_massage "验证：pcre-config" "verification：pcre-config"
}

script_remove() {
	rm -rf ${install_dir}/${pcre_dir}
    
    sed -i '/^export PCRE_HOME=/d' /etc/profile
    sed -i '/^export PATH=${PCRE_HOME}/d' /etc/profile
    source /etc/profile
    
    pcre-config --version
    [[ $? -eq 0 ]] && print_error "pcre-8未成功删除，请联系作者" "pcre-8 was not successfully deleted, please contact the author" || print_massage "pcre-8卸载完成！" "pcre-8 Uninstall completed！"
}

script_info() {
	print_massage "名字：pcre-8" "Name：pcre-8"
	print_massage "版本：8.42" "Version：8.42"
	print_massage "介绍：pcre是一个c语言正规匹配库" "Introduce：Pcre is a c language regular matching library"
	print_massage "作者：日行一善" "do one good deed a day"
}
