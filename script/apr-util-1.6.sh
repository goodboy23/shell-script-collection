#!/usr/bin/env bash



#[使用设置]

#主目录，相当于/usr/local
#install_dir=

#服务目录名
server_dir=apr-util

#yum依赖
server_yum="gcc make expat-devel"



script_get() {
    test_package https://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/apr-util-1.6.1.tar.gz  bd502b9a8670a8012c4d90c31a84955f
}

script_install() {
    apu-1-config --version | grep 1.6
    if [[ $? -eq 0 ]];then
        print_massage "检测到已安装" "Detected installed"
        exit
    else
        apu-1-config --version
        if [[ $? -eq 0 ]];then
            print_error "当前已有其它版本apr-util，请手动卸载" "There are other versions of apr-util currently, please uninstall manually"
        fi
    fi

    test_detection
    
    script_get
    tar -xf package/apr-util-1.6.1.tar.gz
    cd  apr-util-1.6.1
    ./configure -prefix=/usr/local/apr-util -with-apr=/usr/local/apr
    [[ -f Makefile ]] || print_error "Makefile生成失败" "Makefile failed to generate"
    make && make install
    
    cd ..
    rm -rf apr-util-1.6.1
    
    #环境变量
    sed -i '/^export UTIL_HOME=/d' /etc/profile
    sed -i '/^export PATH=${UTIL_HOME}/d' /etc/profile
    
    echo "export UTIL_HOME=${install_dir}/${server_dir}" >> /etc/profile
    echo 'export PATH=${UTIL_HOME}/bin:${PATH}' >> /etc/profile
    source /etc/profile
    
    apu-1-config --version
    [[ $? -eq 0 ]] || print_error "${1}安装失败" "${1} installation failed"

	print_install_ok $1
	print_massage "验证：apu-1-config" "verification：apu-1-config"
}

script_remove() {
	rm -rf ${install_dir}/${server_dir}
    
    sed -i '/^export UTIL_HOME=/d' /etc/profile
    sed -i '/^export PATH=${UTIL_HOME}/d' /etc/profile
    source /etc/profile

    print_remove_ok $1
}

script_info() {
	print_massage "名字：apr-util-1.6" "Name：apr-util-1.6"
	print_massage "版本：1.6.1" "Version：1.6.1"
	print_massage "介绍：Apr的开发组件" "Introduce：Apr's development components"
	print_massage "作者：日行一善" "do one good deed a day"
}
