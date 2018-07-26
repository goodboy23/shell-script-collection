#!/usr/bin/env bash



script_get() {
    print_massage "不用下载" "Do not download"
}

script_install() {
    if [[ -f /usr/local/bin/bidfree ]];then
        print_massage "检测到当前系统已安装" "Detected that the current system is installed"
        exit
    fi
    
    test_bin bidfree

    print_install_bin $1
}

script_remove() {
	rm -rf /usr/local/bin/bidfree
    
    print_remove_ok $1
}

script_info() {
	print_massage "名字：bidfree" "Name：bidfree"
	print_massage "版本：1.0" "Version：1.0"
	print_massage "介绍：hadoop使用，双向免密脚本" "Introduce：Hadoop use, two-way secret script"
	print_massage "作者：日行一善" "do one good deed a day"
    
    print_massage "使用说明：需要修改脚本，设置ip" "Instructions for use: need to modify the script, set the ip"
}
