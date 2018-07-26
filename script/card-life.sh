#!/usr/bin/env bash



script_get() {
    print_massage "不用下载" "Do not download"
}

script_install() {
    if [[ -f /usr/local/bin/card-life ]];then
        print_massage "检测到当前系统已安装" "Detected that the current system is installed"
        exit
    fi
    
    test_bin card-life

    print_install_bin $1
}

script_remove() {
	rm -rf /usr/local/bin/card-life
    
    print_remove_ok $1
}

script_info() {
	print_massage "名字：card-life" "Name：card-life"
	print_massage "版本：1.1" "Version：1.1"
	print_massage "介绍：抽卡人生小游戏" "Introduce：抽卡人生小游戏"
    print_massage "作者：日行一善" "do one good deed a day"
}
