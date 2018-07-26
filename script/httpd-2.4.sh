#!/usr/bin/env bash



#[使用设置]

#主目录，相当于/usr/local
#install_dir=

#服务目录名
server_dir=httpd2

server_rely="apr-1.6 apr-util-1.6 pcre-8"

server_yum="gcc make expat-devel gcc-c++"




script_get() {
    test_package https://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/httpd-2.4.33.tar.gz e983c251062872e5caf87372776c04c0
}

script_install() {
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

    test_detection
    
    script_get
    tar -xf package/httpd-2.4.33.tar.gz
    cd  httpd-2.4.33
    ./configure -prefix=${install_dir}/${server_dir} -enable-so -enable-rewrite -with-apr=/usr/local/apr -with-apr-util=/usr/local/apr-util -with-pcre=/usr/local/pcre
    [[ -f Makefile ]] || print_error "Makefile生成失败" "Makefile failed to generate"
    make && make install
    
    cd ..
    rm -rf httpd-2.4.33
    
    #环境变量
    sed -i '/^export HTTPD_HOME=/d' /etc/profile
    sed -i '/^export PATH=${HTTPD_HOME}/d' /etc/profile

    echo "export HTTPD_HOME=${install_dir}/${server_dir}" >> /etc/profile
    echo 'export PATH=${HTTPD_HOME}/bin:${PATH}' >> /etc/profile
    source /etc/profile
    
    httpd -v
    [[ $? -eq 0 ]] || print_error "${1}安装失败" "${1} installation failed"

    print_install_ok $1
	print_massage "验证：apachectl start" "verification：apachectl start"
}

script_remove() {
    apachectl stop
	rm -rf ${install_dir}/${server_dir}
    
    sed -i '/^export HTTPD_HOME=/d' /etc/profile
    sed -i '/^export PATH=${HTTPD_HOME}/d' /etc/profile
    source /etc/profile
    
    print_remove_ok $1
}

script_info() {
	print_massage "名字：httpd-2.4" "Name：httpd-2.4"
	print_massage "版本：2.4.33" "Version：2.4.33"
	print_massage "介绍：Apache的web服务器" "Introduce：Apache web server"
	print_massage "作者：日行一善" "do one good deed a day"
}
