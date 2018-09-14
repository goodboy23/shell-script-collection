#!/usr/bin/env bash



#[使用设置]

#安装和日志主目录
#install_dir=
#log_dir=

#服务目录名
server_dir=mindoc

#内部安装的依赖，不知道效果勿动
server_rely="glibc-2.14 sqlite-3.23 calibre"

#可yum安装的依赖
server_yum="unzip"

#端口
port=8181



script_get() {
    test_package https://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/mindoc_linux_amd64.zip a49655660c982026d96eae36c9eb5366
}

script_install() {
    #检测
    if [[ -d /usr/local/bin/man-mindoc ]];then
        print_massage "检测到当前系统已安装" "Detected that the current system is installed"
        exit
    fi
 
	#依赖
	test_detection ${1}
    
    #下载和安装安装服务
    script_get
	rm -rf mindoc
    mkdir mindoc
    cp -p package/mindoc_linux_amd64.zip mindoc/
	
    cd mindoc
    unzip mindoc_linux_amd64.zip
    rm -rf mindoc_linux_amd64.zip
    cd ..
    mv mindoc ${install_dir}/${server_dir}
    
    #修改文件
    conf=${install_dir}/${server_dir}/conf/app.conf
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

    #安装
	chmod +x ${install_dir}/${server_dir}/mindoc_linux_amd64
	${install_dir}/${server_dir}/mindoc_linux_amd64 install

    #测试
    [[ -d ${install_dir}/${server_dir}/database ]] || print_error "${1}安装失败" "${1} installation failed"

    #自定义脚本
    test_bin man-mindoc

    print_install_ok $1
	print_log "使用：man-mindoc start" "Use：man-mindoc start"
    print_log "浏览器访问：http://xx.xx.xx.xx:${port}" "Browser access: http://xx.xx.xx.xx:${port}"
    print_log "管理员账号：admin" "Administrator account: admin"
    print_log "管理员密码：123456" "Administrator password: 123456"
	print_log "########################" "########################"
}

script_remove() {
    man-mindoc stop
	rm -rf /usr/local/bin/man-mindoc
	rm -rf ${install_dir}/${server_dir}
    
    print_remove_ok $1
}

script_info() {
    print_massage "名字：mindoc" "Name：mindoc"
	print_massage "版本：0.11" "Version：0.11"
	print_massage "介绍：开源wiki" "Introduce：Open source wiki"
    print_massage "作者：日行一善" "do one good deed a day"

    print_massage "说明：当前使用sqlite3数据库" "Description: Currently using sqlite3 database"
}
