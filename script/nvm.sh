#!/usr/bin/env bash



#安装目录
install_dir=$HOME

log_dir=no

#服务目录
server_dir=".nvm"

server_yum="curl"



script_get() {
	echo "no"
}

script_install() {
    nvm --version
    if [[ $? -eq 0 ]];then
        print_massage "检测到已安装" "Detected installed"
        exit
    fi
	
	#依赖
	test_detection ${1}
    
	curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
	source ~/.bashrc

    #对结果进行测试
    nvm --version
    [ $? -eq 0 ] || print_error "安装失败" "2.Installation failed"
    
    print_install_ok $1
	print_log "使用：nvm --version" "Use：nvm --version"
	print_log "########################" "########################"
}

script_remove() {
	print_massage "当前无法卸载" "Unable to uninstall currently"
}

script_info() {
	print_massage "名字：nvm" "Name：nvm"
	print_massage "版本：0.33.11" "Version：0.33.11"
	print_massage "介绍：nodejs的管理器" "Introduce：Nodejs manager"
    print_massage "作者：日行一善" "do one good deed a day"
}