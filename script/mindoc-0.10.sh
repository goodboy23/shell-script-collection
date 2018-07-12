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
    test_package https://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/mindoc_linux_amd64.zip a49655660c982026d96eae36c9eb5366
}

script_install() {
    if [[ -d /usr/local/bin/man-mindoc ]];then
        print_massage "1.检测到当前系统已安装" "1.Detected that the current system is installed"
        exit
    fi
    
    test_port 8181

    #检测目录和依赖
    test_rely glibc-2.14 sqlite-3.23 calibre
    test_install unzip
    test_dir $mindoc_dir
    
    #安装服务
    script_get
    mkdir mindoc
    cp -p package/mindoc_linux_amd64.zip mindoc/
    cd mindoc
    unzip mindoc_linux_amd64.zip
    rm -rf mindoc_linux_amd64.zip
    cd ..

    mv mindoc ${install_dir}/${mindoc_dir}
    
    conf=${install_dir}/${mindoc_dir}/conf/app.conf
    #禁止mysql
    sed -i "s/httpport = 8181/httpport = ${port}/g" $conf
    sed -i 's/db_adapter=mysql/#db_adapter=mysql/g' $conf
    sed -i 's/db_host=127.0.0.1/#db_host=127.0.0.1/g' $conf
    sed -i 's/db_port=3306/#db_port=3306/g' $conf
    sed -i 's/db_database=mindoc_db/#db_database=mindoc_db/g' $conf
    sed -i 's/db_username=root/#db_username=root/g' $conf
    sed -i 's/db_password=123456/#db_password=123456/g' $conf
    #用sqlite3
    sed -i 's/#db_adapter=sqlite3/db_adapter=sqlite3/g' $conf
    sed -i 's,#db_database=./database/mindoc.db,db_database=./database/mindoc.db,g' $conf

	chmod +x ${install_dir}/${mindoc_dir}/mindoc_linux_amd64
	${install_dir}/${mindoc_dir}/mindoc_linux_amd64 install

    #测试
    [[ -d ${install_dir}/${mindoc_dir}/database ]] || print_error "2.mindoc-0.10安装失败，请检查脚本" "2.mindoc-0.10 installation failed, please check the script"

    test_bin man-mindoc
    sed -i "2a install_dir=${install_dir}" /usr/local/bin/man-mindoc
    sed -i "3a log_dir=${log_dir}" /usr/local/bin/man-mindoc
    sed -i "4a mindoc_dir=${mindoc_dir}" /usr/local/bin/man-mindoc

    print_massage "mindoc-0.10安装完成" "The mindoc-0.10 is installed"
	print_massage "安装目录：${install_dir}/${mindoc_dir}" "Install Dir：${install_dir}/${mindoc_dir}"
    print_massage "日志目录：${log_dir}/${mindoc_dir}" "Log directory：${log_dir}/${mindoc_dir}"
	print_massage "使用：man-mindoc start" "Use：man-mindoc start"
    print_massage "浏览器访问：http://127.0.0.1:${port}" "Browser access: http://127.0.0.1:${port}"
    print_massage "管理员账号：admin" "Administrator account: admin"
    print_massage "管理员密码：123456" "Administrator password: 123456"
}

script_remove() {
	rm -rf /usr/local/bin/man-mindoc
	rm -rf ${install_dir}/${mindoc_dir}

    [[ -f /usr/local/bin/man-mindoc ]] && print_error "1.卸载失败，请检查脚本" "1.Uninstall failed, please check the script" || "mindoc卸载完成！" "mindoc Uninstall completed！"
}

script_info() {
    print_massage "名字：mindoc-0.11" "Name：mindoc-0.10"
	print_massage "版本：0.11" "Version：0.10.1"
	print_massage "介绍：开源wiki" "Introduce：Open source wiki"
    print_massage "作者：日行一善" "do one good deed a day"
}
