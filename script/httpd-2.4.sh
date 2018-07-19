#!/usr/bin/env bash



#[使用设置]

#主目录，相当于/usr/local
#install_dir=

#服务目录名
httpd_dir=httpd2



script_get() {
    test_package https://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/httpd-2.4.33.tar.gz e983c251062872e5caf87372776c04c0
}

script_install() {
    yum -y remove httpd

    httpd -v | grep 2.4
    if [[ $? -eq 0 ]];then
        print_massage "检测到已安装" "Detected installed"
        exit
    else
        httpd -v
        if [[ $? -eq 0 ]];then
            print_error "当前已有其它版本httpd，请手动卸载" "There are other versions of httpd currently, please uninstall manually"
        fi
    fi

    test_install gcc make expat-devel gcc-c++
    test_dir $httpd_dir
    test_rely apr-1.6 apr-util-1.6 pcre-8
    
    script_get
    tar -xf package/httpd-2.4.33.tar.gz
    cd  httpd-2.4.33
    ./configure -prefix=${install_dir}/${httpd_dir} -enable-so -enable-rewrite -with-apr=/usr/local/apr -with-apr-util=/usr/local/apr-util -with-pcre=/usr/local/pcre
    [[ -f Makefile ]] || print_error "Makefile生成失败，请联系作者" "Makefile failed to generate, please contact the author"
    make && make install
    
    cd ..
    rm -rf httpd-2.4.33
    
    #环境变量
    sed -i '/^export HTTPD_HOME=/d' /etc/profile
    sed -i '/^export PATH=${HTTPD_HOME}/d' /etc/profile
    
    echo "export HTTPD_HOME=${install_dir}/${httpd_dir}" >> /etc/profile
    echo 'export PATH=${HTTPD_HOME}/bin:${PATH}' >> /etc/profile
    source /etc/profile
    
    httpd -v
    [[ $? -eq 0 ]] || print_error "httpd-2.4安装失败，请联系作者" "httpd-2.4 installation failed, please check the script"

	print_massage "httpd-2.4安装完成" "The httpd-2.4 is installed"
	print_massage "安装目录：${install_dir}/${httpd_dir}" "Install Dir：${install_dir}/${httpd_dir}"
	print_massage "验证：httpd -v" "verification：httpd -v"
}

script_remove() {
	rm -rf ${install_dir}/${httpd_dir}
    
    sed -i '/^export HTTPD_HOME=/d' /etc/profile
    sed -i '/^export PATH=${HTTPD_HOME}/d' /etc/profile
    source /etc/profile
    
    httpd -v
    [[ $? -eq 0 ]] && print_error "httpd-2.4未成功删除，请联系作者" "httpd-2.4 was not successfully deleted, please contact the author" || print_massage "httpd-2.4卸载完成！" "httpd-2.4 Uninstall completed！"
}

script_info() {
	print_massage "名字：httpd-2.4" "Name：httpd-2.4"
	print_massage "版本：2.4.33" "Version：2.4.33"
	print_massage "介绍：Apache的web服务器" "Introduce：Apache web server"
	print_massage "作者：日行一善" "do one good deed a day"
}
