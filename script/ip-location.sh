#!/usr/bin/env bash



script_get() {
    print_massage "不用下载" "Do not download"
}

script_install() {
    if [[ -f /usr/local/bin/ip-location ]];then
        print_massage "1.检测到当前系统已安装" "1.Detected that the current system is installed"
        exit
    fi
    
    test_bin ip-location

	print_massage "ip-location安装完成" "The ip-location is installed"
	print_massage "安装目录：/usr/local/bin/ip-location" "Install Dir：/usr/local/bin/ip-location"
	print_massage "使用：ip-location" "Use：ip-location"
}

script_remove() {
	rm -rf /usr/local/bin/ip-location
    
    [ -f /usr/local/bin/ip-location ] && print_error "ip-location未成功删除，请联系作者" "Ip-location was not successfully deleted, please contact the author" || print_massage "ip-location卸载完成！" "ip-location Uninstall completed！"
}

script_info() {
	print_massage "名字：ip-location" "Name：ip-location"
	print_massage "版本：1.0" "Version：1.0"
	print_massage "介绍：查询ip地址所在地脚本" "Introduce：Query ip address location script"
    print_massage "作者：日行一善" "do one good deed a day"
}