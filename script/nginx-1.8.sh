#!/usr/bin/env bash



#[使用设置]

#主目录，相当于/usr/local
#install_dir=

#日志主目录，相当于/var/log
#log_dir=

#服务目录名
server_dir=nginx

server_yum="gcc make pcre pcre-devel openssl openssl-devel zlib zlib-devel"



script_get() {
    test_package https://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/nginx-1.8.0.tar.gz 3ca4a37931e9fa301964b8ce889da8cb
}

script_install() {
    nginx -v &> conf/log.txt
    grep "nginx/1.8" conf/log.txt
    if [[ $? -eq 0 ]];then
        print_massage "检测到已安装" "Detected installed"
        exit
    else
        nginx -v
        if [[ $? -eq 0 ]];then
            print_error "当前已有其它版本nginx，请手动卸载" "There are other versions of nginx currently, please uninstall manually"
        fi
    fi
	
	#依赖
	test_detection ${1}
    
    #权限
	useradd -s /sbin/nologin nginx
	
	script_get
	rm -rf nginx-1.8.0
    tar -xf package/nginx-1.8.0.tar.gz
	cd nginx-1.8.0
    
	#这里指定模块，请按需求添加
	./configure --prefix=${install_dir}/${server_dir} \
	--user=nginx \
	--group=nginx \
	--with-http_spdy_module \
	--with-http_stub_status_module \
	--with-pcre \
	--with-http_ssl_module \
	--error-log-path=${log_dir}/${server_dir}/error.log \
	--http-log-path=${log_dir}/${server_dir}/access.log
	
	[[ -f Makefile ]] || print_error "Makefile生成失败" "Makefile failed to generate"
	make && make install || print_error "make操作失败" "make operation failed"

    cd ..
    rm -rf nginx-1.8.0

    rm -rf /usr/local/bin/nginx
	ln -s ${install_dir}/${server_dir}/sbin/nginx /usr/local/bin/nginx
	nginx -v
	[[ $? -eq 0 ]] || test_exit "安装失败" "2.Installation failed"

    print_install_ok $1
	print_log "使用：nginx" "Use：nginx"
	print_log "访问：http://xx.xx.xx.xx:80" "Visit: http://xx.xx.xx.xx:80"
	print_log "########################" "########################"
}

script_remove() {
    nginx -s stop
	userdel -r nginx
	rm -rf ${install_dir}/${server_dir}
    rm -rf /usr/local/bin/nginx
    
    print_remove_ok $1
}

script_info() {
	print_massage "名字：nginx-1.8" "Name：nginx-1.8"
	print_massage "版本：1.8" "Version：1.8"
	print_massage "介绍：Nginx是一个高性能的HTTP和反向代理服务器" "Introduce：Nginx is a high performance HTTP and reverse proxy server"
    print_massage "作者：日行一善" "do one good deed a day"
}
