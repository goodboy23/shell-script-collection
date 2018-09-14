#!/usr/bin/env bash



#[使用设置]

#主目录，相当于/usr/local
#install_dir=

log_dir=no

#服务目录名
server_dir=apr-util

#yum依赖
server_yum="gcc make expat-devel"

#填写ok将按如下填写执行脚本
switch=no

#apr目录位置
apr_dir=



script_get() {
    test_package https://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/apr-util-1.6.1.tar.gz  bd502b9a8670a8012c4d90c31a84955f
}

script_install() {
	if [[ "$switch" == "no" ]];then
        print_error "此脚本需要填写，请./ssc.sh edit 服务名 来设置" "This script needs to be filled in. Set the ./ssc.sh edit service name"
    fi

	#检测apr目录
	[[ -d $apr_dir ]] || print_error "apr目录${apr_dir} 不存在" "apr directory ${apr_dir} does not exist"

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

    #依赖
    test_port ${port}
    test_dir ${server_dir}
    test_rely ${server_rely}
    test_install ${server_yum}
    
	#部署
    script_get
	rm -rf apr-util-1.6.1
    tar -xf package/apr-util-1.6.1.tar.gz
    cd  apr-util-1.6.1
    ./configure -prefix=${install_dir}/${server_dir} -with-apr=${apr_dir} || print_error "Makefile生成失败" "Makefile failed to generate"
    make && make install || print_error "make操作失败" "make operation failed"
    
    cd $ssc_dir
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
	print_log "验证：apu-1-config" "verification：apu-1-config"
	print_log "########################" "########################"
}

script_remove() {
	rm -rf ${install_dir}/${server_dir}
    
    sed -i '/^export UTIL_HOME=/d' /etc/profile
    sed -i '/^export PATH=${UTIL_HOME}/d' /etc/profile

    print_remove_ok $1
}

script_info() {
	print_massage "名字：apr-util-1.6" "Name：apr-util-1.6"
	print_massage "版本：1.6.1" "Version：1.6.1"
	print_massage "介绍：Apr的开发组件" "Introduce：Apr's development components"
	print_massage "作者：日行一善" "do one good deed a day"
}
