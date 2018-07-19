#!/usr/bin/env bash



#[使用设置]
install_dir=/usr/local

php_dir=php



script_get() {
    test_package "http://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/php-5.6.36.tar.gz" "57b3b6f44f0d43b25538c85f9b3a32d0"
}

script_install() {
    php -v | grep 5.6
    if [[ $? -eq 0 ]];then
        print_massage "检测到已安装" "Detected installed"
        exit
    else
        php -v
        if [[ $? -eq 0 ]];then
            print_error "当前已有其它版本php，请手动卸载" "There are other versions of php currently, please uninstall manually"
        fi
    fi

    test_dir $php_dir
    test_install php-mcrypt libmcrypt libmcrypt-devel autoconf freetype gd jpegsrc libmcrypt libpng libpng-devel libjpeg libxml2 libxml2-devel zlib curl curl-devel
    script_get

    tar -xvf package/php-5.6.36.tar.gz
    cd php-5.6.36/
    #模块
    ./configure --prefix=${install_dir}/${php_dir} --enable-mbstring --with-curl --with-gd --enable-fpm --enable-mysqlnd --with-pdo-mysql
    make && make install

   #环境变量
    sed -i '/^PHP_HOME=/d' /etc/profile
    sed -i '/^FPM_HOME=/d' /etc/profile
    sed -i '/^PATH=$PHP_HOME/d' /etc/profile
    sed -i '/^PATH=$FPM_HOME/d' /etc/profile
    
    echo "PHP_HOME=${install_dir}/${php_dir}/bin"  >> /etc/profile
    echo 'PATH=$PHP_HOME:$PATH' >> /etc/profile
    echo "FPM_HOME=${install_dir}/${php_dir}/sbin"  >> /etc/profile
    echo 'PATH=$FPM_HOME:$PATH' >> /etc/profile
    source /etc/profile

	#测试
	php -v | grep 5.6
	[ $? -eq 0 ] || print_error "php-5.6安装失败，请联系作者" "Php-5.6 installation failed, please contact the author"
    
    
	print_massage "php-5.6安装完成" "php-5.6 installation is complete"
	print_massage "部署目录：${install_dir}/${php_dir}" "Deployment directory: ${install_dir}/${php_dir}"
    print_massage "启动：php-fpm" "Start：php-fpm"
}

script_remove() {
    rm -rf ${install_dir}/${php_dir}
    sed -i '/^PHP_HOME=/d' /etc/profile
    sed -i '/^FPM_HOME=/d' /etc/profile
    sed -i '/^PATH=$PHP_HOME/d' /etc/profile
    sed -i '/^PATH=$FPM_HOME/d' /etc/profile
    source /etc/profile
    
    php -v | grep 5.6
    [ $? -eq 0 ] && print_error "php-5.6卸载失败，请联系作者" "1.php-5.6 uninstall failed, please contact the author" || print_massage "rvm-2.4卸载成功" "rvm-2.4 uninstall successfully"
}

script_info() {
    print_massage "名字：php-5.6" "Name：php-5.6"
    print_massage "版本：5.6.36" "Version：5.6.36"
    print_massage "介绍：一种创建动态交互性站点的强有力的服务器端脚本语言" "Introduction: A powerful server-side scripting language for creating dynamic interactive sites"
    print_massage "作者：日行一善" "do one good deed a day"
}
