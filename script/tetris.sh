#!/usr/bin/env bash



script_get() {
    print_massage "不用下载" "Do not download"
}

script_install() {
    if [[ -f /usr/local/bin/tetris ]];then
        print_massage "检测到当前系统已安装" "Detected that the current system is installed"
        exit
    fi
    
    test_bin tetris

    print_install_bin $1
}

script_remove() {
	rm -rf /usr/local/bin/tetris
    
    print_remove_ok $1
}

script_info() {
	print_massage "名字：tetris" "Name：tetris"
	print_massage "版本：1.0" "Version：1.0"
	print_massage "介绍：俄罗斯方块小游戏脚本" "Introduce：Tetris Game Script"
	print_massage "作者：未知" "Author：未知"
}