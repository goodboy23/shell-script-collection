#!/usr/bin/env bash



#[使用设置]
#install_dir=/usr/local

log_dir=no

server_dir=php

server_yum="gcc make gcc-c++ cmake libxml2  m4 autoconf libxml2-devel openssl openssl-devel curl-devel libjpeg-devel libpng-devel freetype-devel libmcrypt-devel libxslt libxslt-devel"



script_get() {
    test_package "http://cn2.php.net/distributions/php-7.1.1.tar.gz" "7c565ddf31d69dbc19027e51b6968b79"
}

script_install() {
    php -v | grep 7.*
    if [[ $? -eq 0 ]];then
        print_massage "检测到已安装" "Detected installed"
        exit
    else
        which php
        if [[ $? -eq 0 ]];then
            print_error "当前已有其它版本php，请手动卸载" "There are other versions of php currently, please uninstall manually"
        fi
    fi

    groupadd www
    useradd -g www -s /sbin/nologin www

  	#依赖
	test_detection ${1}
    script_get
    rm -rf php-7.1.1
    tar -xvf package/php-7.1.1.tar.gz
    
    #模块
    cd php-7.1.1
./configure --prefix=${install_dir}/${server_dir} \
--with-curl \
--with-freetype-dir \
--with-gd \
--with-gettext \
--with-iconv-dir \
--with-kerberos \
--with-libdir=lib64 \
--with-libxml-dir \
--with-mysqli \
--with-openssl \
--with-pcre-regex \
--with-pdo-mysql \
--with-pdo-sqlite \
--with-pear \
--with-png-dir \
--with-xmlrpc \
--with-xsl \
--with-zlib \
--enable-fpm \
--with-fpm-user=www \
--with-fpm-group=www \
--enable-bcmath \
--enable-libxml \
--enable-inline-optimization \
--enable-gd-native-ttf \
--enable-mbregex \
--enable-mbstring \
--enable-opcache \
--enable-pcntl \
--enable-shmop \
--enable-soap \
--enable-sockets \
--enable-sysvsem \
--enable-xml \
--enable-zip
	[[ -f Makefile ]] || print_error "Makefile生成失败" "Makefile failed to generate"
    make && make install || print_error "编译错误" "Compile Error"
	
	cd ..
	rm -rf ${ssc_dir}/php-7.1.1
	
    #配置文件
    cp php.ini-production  ${install_dir}/${server_dir}/lib/php.ini
    cp  ${install_dir}/${server_dir}/etc/php-fpm.conf.default ${install_dir}/${server_dir}/etc/php-fpm.conf
	cp ${install_dir}/${server_dir}/etc/php-fpm.d/www.conf.default ${install_dir}/${server_dir}/etc/php-fpm.d/www.conf

   #环境变量
    sed -i '/^PHP_HOME=/d' /etc/profile
    sed -i '/^FPM_HOME=/d' /etc/profile
    sed -i '/^PATH=$PHP_HOME/d' /etc/profile
    sed -i '/^PATH=$FPM_HOME/d' /etc/profile
    
    echo "PHP_HOME=${install_dir}/${server_dir}/bin"  >> /etc/profile
    echo 'PATH=$PHP_HOME:$PATH' >> /etc/profile
    echo "FPM_HOME=${install_dir}/${server_dir}/sbin"  >> /etc/profile
    echo 'PATH=$FPM_HOME:$PATH' >> /etc/profile
    source /etc/profile

	#测试
	php -v | grep 7.*
	[ $? -eq 0 ] || print_error "${1}安装失败" "${1} installation failed"

    print_install_ok $1
    print_log "启动：php-fpm" "Start：php-fpm"
	print_log "########################" "########################"
}

script_remove() {
    rm -rf ${install_dir}/${server_dir}
    rm -rf /etc/php.ini
    sed -i '/^PHP_HOME=/d' /etc/profile
    sed -i '/^FPM_HOME=/d' /etc/profile
    sed -i '/^PATH=$PHP_HOME/d' /etc/profile
    sed -i '/^PATH=$FPM_HOME/d' /etc/profile

    print_remove_ok $1
}

script_info() {
    print_massage "名字：php-7.1" "Name：php-7.1"
    print_massage "版本：7.1.1" "Version：7.1.1"
    print_massage "介绍：一种创建动态交互性站点的强有力的服务器端脚本语言" "Introduction: A powerful server-side scripting language for creating dynamic interactive sites"
    print_massage "作者：日行一善" "do one good deed a day"
}
