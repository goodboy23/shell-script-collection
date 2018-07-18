#!/usr/bin/env bash



script_get() {
    print_massage "不用下载" "Do not download"
}

script_install() {
    if [[ -f /usr/local/bin/logcut ]];then
        print_massage "检测到当前系统已安装" "Detected that the current system is installed"
        exit
    fi
    
    test_bin logcut

	print_massage "logcut安装完成" "The logcut is installed"
	print_massage "安装目录：/usr/local/bin/logcut" "Install Dir：/usr/local/bin/logcut"
	print_massage "使用：logcut" "Use：logcut"
}

script_remove() {
	rm -rf /usr/local/bin/logcut
    
    [ -f /usr/local/bin/logcut ] && print_error "logcut未成功删除，请联系作者" "1.logcut unsuccessfully deleted, please contact the author" || print_massage "logcut卸载完成！" "logcut Uninstall completed！"
}

script_info() {
	print_massage "名字：logcut" "Name：logcut"
	print_massage "版本：1.0" "Version：1.0"
	print_massage "介绍：日志切割脚本" "Introduce：Log cutting script"
    print_massage "作者：日行一善" "do one good deed a day"
    print_massage "使用说明：需要修改进本，设置文件夹" "Instructions for use: need to modify the input, set the folder"
}