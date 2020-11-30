#!/usr/bin/env bash



#安装目录
#install_dir=

log_dir=no

#服务目录
server_dir=nodejs



script_get() {
    test_package "wget https://cdn.npm.taobao.org/dist/node/v12.16.2/node-v12.16.2-linux-x64.tar.xz" "d1a52298bb43dbdedb8f84b358ffc772"
}

script_install() {
    node -v |grep ^v12
    if [[ $? -eq 0 ]];then
        print_massage "检测到已安装" "Detected installed"
        exit
    else
        node -v
        if [[ $? -eq 0 ]];then
            print_error "当前已有其它版本nodejs，请手动卸载" "There are other versions of nodejs currently, please uninstall manually"
        fi
    fi
	
	#依赖
	test_detection ${1}
    
    script_get
	  rm -rf node-v12.16.2-linux-x64
    tar -xf node-v12.16.2-linux-x64.tar.xz
    mv node-v12.16.2-linux-x64 ${install_dir}/${server_dir}
    
    #链接
    rm -rf /usr/local/bin/node
    rm -rf /usr/local/bin/npm
    ln -s ${install_dir}/${server_dir}/bin/node /usr/local/bin/node
    ln -s ${install_dir}/${server_dir}/bin/npm /usr/local/bin/npm

    #对结果进行测试
    node -v
    [ $? -eq 0 ] || print_error "安装失败" "2.Installation failed"
    
    print_install_ok $1
	print_log "使用：node -v" "Use：node -v"
	print_log "########################" "########################"
}

script_remove() {
    rm -rf /usr/local/bin/node
    rm -rf /usr/local/bin/npm
    rm -rf ${install_dir}/${server_dir}
    
    print_remove_ok $1
}

script_info() {
	print_massage "名字：nodejs-12.16" "Name：nodejs-12.16"
	print_massage "版本：12.16.2" "Version：12.16.2"
	print_massage "介绍：Node.js 就是运行在服务端的 JavaScript。" "Introduce：Node.js is JavaScript that runs on the server."
    print_massage "作者：日行一善" "do one good deed a day"
}
