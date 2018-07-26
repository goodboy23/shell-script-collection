#!/usr/bin/env bash



script_get() {
    print_massage "不用下载" "Do not download"
}

script_install() {
    if [[ -f /usr/local/bin/batch ]];then
        print_massage "检测到当前系统已安装" "Detected that the current system is installed"
        exit
    fi
    
    test_bin batch

	print_install_bin $1
}

script_remove() {
	rm -rf /usr/local/bin/batch
    
    print_remove_ok $1
}

script_info() {
	print_massage "名字：batch" "Name：batch"
	print_massage "版本：1.2" "Version：1.2"
	print_massage "介绍：批量操作跳板机脚本" "Introduction: Batch operation springboard script"
	print_massage "作者：日行一善" "do one good deed a day"
    
	print_massage "使用说明：根据/etc/hosts文件和免密登陆来进行批量ssh操作" "Instructions for use: batch ssh operations based on the /etc/hosts file and free login"
	print_massage "支持对/etc/hosts中的主机分组，需要修改batch" "Support for grouping hosts in /etc/hosts, need to modify the batch"
	print_massage "支持对rm等命令进行禁用，防止批量操作产生影响，需要batch" "Supports the disabling of commands such as rm to prevent batch operation and requires batch"
}
