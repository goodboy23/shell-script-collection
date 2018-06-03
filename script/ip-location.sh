#!/usr/bin/env bash



script_get() {
    print_massage "不用下载" "Do not download"
}

script_install() {
    if [[ -f /usr/local/bin/ip-location ]];then
        print_massage "检测到当前系统已安装" "Detected that the current system is installed"
        exit
    fi
    
    test_bin ip-location

	print_massage "ip-location安装完成" "The ip-location is installed"
	print_massage "安装目录：/usr/local/bin/ip-location" "Install Dir：/usr/local/bin/ip-location"
	print_massage "使用：ip-location" "Use：ip-location"
	print_massage "使用说明：查询ip地址所在地" "Instructions for use: Query ip address location"
}

script_remove() {
	rm -rf /usr/local/bin/ip-location
    
    [ -f /usr/local/bin/ip-location ] && print_error "ip-location未成功删除，请检查脚本" "ip-location unsuccessfully deleted, please check the script" || print_massage "ip-location卸载完成！" "ip-location Uninstall completed！"
}

script_info() {
	print_massage "名字：ip-location" "Name：ip-location"
	print_massage "版本：1.0" "Version：1.0"
	print_massage "介绍：查询ip地址所在地脚本" "Introduce：Query ip address location script"
	print_massage "作者：速度与激情小组---Linux部" "Author：Speed and Passion Group --- Linux Department"
}