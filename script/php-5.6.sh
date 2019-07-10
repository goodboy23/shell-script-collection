#!/usr/bin/env bash



#[使用设置]
install_dir=/usr/local

log_dir=no

server_dir=php

server_yum="gcc bison bison-devel freetype-devel libpng libpng-devel libjpeg-devel zlib-devel libmcrypt-devel mcrypt mhash-devel openssl-devel libxml2-devel libcurl-devel bzip2-devel readline-devel libedit-devel sqlite-devel jemalloc jemalloc-devel"



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

    groupadd www
    useradd -g www -s /sbin/nologin www

  	#依赖
	test_detection ${1}

    script_get
    rm -rf php-5.6.36
    tar -xvf package/php-5.6.36.tar.gz
    
    #模块
    cd php-5.6.36
./configure --prefix=${install_dir}/${server_dir} \
--with-config-file-path=/etc \
--enable-inline-optimization --disable-debug \
--disable-rpath --enable-shared --enable-opcache \
--enable-fpm --with-fpm-user=www \
--with-fpm-group=www \
--with-mysql=mysqlnd \
--with-mysqli=mysqlnd \
--with-pdo-mysql=mysqlnd \
--with-gettext \
--enable-mbstring \
--with-iconv \
--with-mcrypt \
--with-gd \
--with-mhash \
--with-openssl \
--enable-bcmath \
--enable-soap \
--with-libxml-dir \
--enable-pcntl \
--enable-shmop \
--enable-sysvmsg \
--enable-sysvsem \
--enable-sysvshm \
--enable-sockets \
--with-curl --with-zlib \
--enable-zip \
--with-bz2 \
--with-readline \
--with-png-dir \
--with-freetype-dir \
--with-jpeg-dir \
--with-gd

	[[ -f Makefile ]] || print_error "Makefile生成失败" "Makefile failed to generate"
    make && make install || print_error "编译错误" "Compile Error"

    #配置文件
    rm -rf /etc/php.ini
    cp php.ini-development /etc/php.ini
    cp  ${install_dir}/${server_dir}/etc/php-fpm.conf.default ${install_dir}/${server_dir}/etc/php-fpm.conf
    rm -rf /usr/local/bin/php-fpm
    rm -rf ${ssc_dir}/php-5.6.36
    
    #启动脚本
    cp sapi/fpm/init.d.php-fpm /usr/local/bin/php-fpm
    chmod +x /usr/local/bin/php-fpm

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
	php -v | grep 5.6
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
    print_massage "名字：php-5.6" "Name：php-5.6"
    print_massage "版本：5.6.36" "Version：5.6.36"
    print_massage "介绍：一种创建动态交互性站点的强有力的服务器端脚本语言" "Introduction: A powerful server-side scripting language for creating dynamic interactive sites"
    print_massage "作者：日行一善" "do one good deed a day"
}
