#!/usr/bin/env bash



script_get() {
    print_massage "不用下载" "Do not download"
}

script_install() {
    if [[ -f /usr/local/bin/clocks ]];then
        print_massage "检测到当前系统已安装" "Detected that the current system is installed"
        exit
    fi
    
    test_bin clocks

	print_install_bin $1
}

script_remove() {
	rm -rf /usr/local/bin/clocks
    
    print_remove_ok $1
}

script_info() {
	print_massage "名字：clocks" "Name：clocks"
	print_massage "版本：1.0" "Version：1.0"
	print_massage "介绍：字符的系统时间脚本" "Introduce：The system time of the character"
	print_massage "作者：未知" "unknown"
}
