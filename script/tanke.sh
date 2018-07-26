#!/usr/bin/env bash



script_get() {
    print_massage "不用下载" "Do not download"
}

script_install() {
    if [[ -f /usr/local/bin/tanke ]];then
        print_massage "检测到当前系统已安装" "Detected that the current system is installed"
        exit
    fi
    
    test_bin tanke

    print_install_bin $1
}

script_remove() {
	rm -rf /usr/local/bin/tank

    print_remove_ok $1
}

script_info() {
	print_massage "名字：tank" "Name：tank"
	print_massage "版本：1.2" "Version：1.2"
	print_massage "介绍：小坦克游戏" "Introduction: Small tank games"
    print_massage "作者：日行一善" "do one good deed a day"
    print_massage "使用说明：当前功能不完善，只有玩家，可以自定义地图" "Instructions for use: The current function is not perfect, only the player can customize the map"
}
