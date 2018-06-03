#!/usr/bin/env bash



#[使用设置]

#主目录，相当于/usr/local
#install_dir=

#日志主目录，相当于/var/log
#log_dir=

#服务目录名
nginx_dir=nginx



script_get() {
    test_package https://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/nginx-1.8.0.tar.gz 3ca4a37931e9fa301964b8ce889da8cb
}

script_install() {
    nginx -v
    if [[ $? -eq 0 ]];then
        print_massage "检测到当前系统已安装" "Detected that the current system is installed"
        exit
    fi

    yum -y remove nginx
    test_port 80

    #检测目录
    test_dir $nginx_dir
	test_install gcc pcre-devel openssl-devel zlib-devel make

	useradd -s /sbin/nologin nginx
	script_get
    tar -xf package/nginx-1.8.0.tar.gz
	cd nginx-1.8.0
    
	#这里指定模块，请按需求添加
	./configure --prefix=${install_dir}/${nginx_dir} --user=nginx --group=nginx --with-http_ssl_module --error-log-path=${log_dir}/${nginx_dir}/error.log --http-log-path=${log_dir}/${nginx_dir}/access.log
	make && make install

	ln -s ${install_dir}/${nginx_dir}/sbin/nginx /usr/local/bin/nginx
	nginx -v
	[[ $? -eq 0 ]] || test_exit "安装失败，请检查脚本" "Installation failed, please check the script"

    print_massage "nginx-1.8安装完成" "The nginx-1.8 is installed"
	print_massage "安装目录：${install_dir}/${nginx_dir}" "Install Dir：${install_dir}/${nginx_dir}"
    print_massage "日志目录：${log_dir}/${nginx_dir}" "Log directory: ${log_dir}/${nginx_dir}"
	print_massage "使用：nginx" "Use：nginx"
	print_massage "访问：curl http://127.0.1.1:80" "Visit: curl http://127.0.1.1:80"
}

script_remove() {
	userdel -r nginx
	rm -rf ${install_dir}/${nginx_dir}
    rm -rf /usr/local/bin/nginx
    
    nginx -v
	[[ $? -eq 0 ]] && print_error "卸载失败，请检查脚本" "Uninstall failed, please check the script" || print_massage "nginx卸载完成！" "nginx Uninstall completed！"
}

script_info() {
	print_massage "名字：nginx-1.8" "Name：nginx-1.8"
	print_massage "版本：1.8" "Version：1.8"
	print_massage "介绍：Nginx是一个高性能的HTTP和反向代理服务器" "Introduce：Nginx is a high performance HTTP and reverse proxy server"
	print_massage "作者：速度与激情小组---Linux部" "Author：Speed and Passion Group --- Linux Department"
}
