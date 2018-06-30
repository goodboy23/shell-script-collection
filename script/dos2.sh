#!/usr/bin/env bash



script_get() {
    print_massage "不用下载" "Do not download"
}

script_install() {
    if [[ -f /usr/local/bin/dos2 ]];then
        print_massage "1.检测到当前系统已安装" "1.Detected that the current system is installed"
        exit
    fi
    
    test_bin dos2

	print_massage "dos2安装完成" "The dos2 is installed"
	print_massage "安装目录：/usr/local/bin/dos2" "Install Dir：/usr/local/bin/dos2"
	print_massage "使用：dos2" "Use：dos2"
}

script_remove() {
	rm -rf /usr/local/bin/dos2
    
    [ -f /usr/local/bin/dos2 ] && print_error "1.dos2未成功删除，请检查脚本" "1.dos2 unsuccessfully deleted, please check the script" || print_massage "dos2卸载完成！" "dos2 Uninstall completed！"
}

script_info() {
	print_massage "名字：dos2" "Name：dos2"
	print_massage "版本：1.0" "Version：1.0"
	print_massage "介绍：批量将win写的文件转换为linux格式" "Introduce：Batch convert files written in win to linux format"
	print_massage "作者：日行一善" "do one good deed a day"
}
