#!/usr/bin/env bash



#[使用设置]

#当前只支持使用sqlite3数据库安装，若使用mysql请手动安装

#主目录，相当于/usr/local
#install_dir=

#日志主目录，相当于/var/log
#log_dir=

#服务目录名
mindoc_dir=mindoc

#端口
port=8181



script_get() {
    test_package https://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/mindoc.tar.gz 3edf05c97977f71f8b052818fd5a5412
}

script_install() {
    if [[ -f /usr/local/bin/man-mindoc ]];then
        print_massage "检测到当前系统已安装" "Detected that the current system is installed"
        exit
    fi
    
    test_port 8181

    #检测目录
    test_rely glibc-2.14 sqlite3 calibre
    test_dir $mindoc_dir
    
    #安装服务
    script_get
    tar -xf package/mindoc.tar.gz
    mv mindoc ${install_dir}/${mindoc_dir}
    
    conf=${install_dir}/${mindoc_dir}/conf/app.conf
    sed -i "s/httpport = 8181/httpport = ${port}/g" $conf
	
	rm -rf ${install_dir}/${mindoc_dir}/database
	chmod +x ${install_dir}/${mindoc_dir}/mindoc_linux_amd64
	${install_dir}/${mindoc_dir}/mindoc_linux_amd64 install

    test_bin man-mindoc
    sed -i "2a install_dir=${install_dir}" /usr/local/bin/man-mindoc
    sed -i "3a log_dir=${log_dir}" /usr/local/bin/man-mindoc
    sed -i "4a mindoc_dir=${mindoc_dir}" /usr/local/bin/man-mindoc

    print_massage "mindoc-0.9安装完成" "The mindoc-0.9 is installed"
	print_massage "安装目录：${install_dir}/${mindoc_dir}" "Install Dir：${install_dir}/${mindoc_dir}"
    print_massage "日志目录：${log_dir}/${mindoc_dir}" "Log directory：${log_dir}/${mindoc_dir}"
	print_massage "使用：man-mindoc start" "Use：man-mindoc start"
    print_massage "管理员账号：admin" "Administrator account: admin"
    print_massage "管理员密码：123456" "Administrator password: 123456"
}

script_remove() {
	rm -rf /usr/local/bin/man-mindoc
	rm -rf ${install_dir}/${mindoc_dir}

    [[ -f /usr/local/bin/man-mindoc ]] && print_error "卸载失败，请检查脚本" "Uninstall failed, please check the script" || "mindoc卸载完成！" "mindoc Uninstall completed！"
}

script_info() {
    print_massage "名字：mindoc-0.9" "Name：mindoc-0.9"
	print_massage "版本：0.9" "Version：0.9"
	print_massage "介绍：开源wiki" "Introduce：Open source wiki"
	print_massage "作者：速度与激情小组---Linux部" "Author：Speed and Passion Group --- Linux Department"
}
