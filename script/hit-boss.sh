#!/usr/bin/env bash



script_get() {
    print_massage "不用下载" "Do not download"
}

script_install() {
    if [[ -f /usr/local/bin/hit-boss ]];then
        print_massage "检测到当前系统已安装" "Detected that the current system is installed"
        exit
    fi
    
    test_bin hit-boss

    print_install_bin $1
}

script_remove() {
	rm -rf /usr/local/bin/hit-boss
    
    print_remove_ok $1
}

script_info() {
	print_massage "名字：hit-boss" "Name：hit-boss"
	print_massage "版本：1.0" "Version：1.0"
	print_massage "介绍：打boss小游戏脚本" "Introduce：Play boss game script"
    print_massage "作者：日行一善" "do one good deed a day"
}