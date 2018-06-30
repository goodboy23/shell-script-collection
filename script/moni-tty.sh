#!/usr/bin/env bash



script_get() {
    print_massage "不用下载" "Do not download"
}

script_install() {
    if [[ -f /usr/local/bin/moni-tty ]];then
        print_massage "1.检测到当前系统已安装" "1.Detected that the current system is installed"
        exit
    fi
    
    test_bin moni-tty

	print_massage "moni-tty安装完成" "The moni-tty is installed"
	print_massage "安装目录：/usr/local/bin/moni-tty" "Install Dir：/usr/local/bin/moni-tty"
	print_massage "使用：moni-tty" "Use：moni-tty"
}

script_remove() {
	rm -rf /usr/local/bin/moni-tty
    
    [ -f /usr/local/bin/moni-tty ] && print_error "1.moni-tty未成功删除，请检查脚本" "1.moni-tty unsuccessfully deleted, please check the script" || print_massage "moni-tty卸载完成！" "moni-tty Uninstall completed！"
}

script_info() {
	print_massage "名字：moni-tty" "Name：moni-tty"
	print_massage "版本：1.0" "Version：1.0"
	print_massage "介绍：模拟shell登陆" "Introduce：Simulated shell login"
	print_massage "作者：日行一善" "do one good deed a day"
}
