#!/usr/bin/env bash



script_get() {
    print_massage "不用下载" "Do not download"
}

script_install() {
    ruby -v | grep 2.4.1
    if [[ $? -eq 0 ]];then
        print_massage "1.检测到当前系统已安装" "1.Detected that the current system is installed"
        exit
    fi
    
    test_rely rvm
    source /etc/profile

    #安装
    rvm install 2.4.1
    rvm use 2.4.1 --default
	
	#测试
	ruby -v | grep 2.4.1
	[ $? -eq 0 ] || print_error "2.ruby安装失败，请检查脚本" "2.Ruby installation failed, please check the script"
    
    
	print_massage "ruby-2.4安装完成" "ruby-2.4 installation is complete"
	print_massage "使用：ruby" "Use：ruby"
}

script_remove() {
    rvm remove 2.4.1
    rvm -v | grep 2.4.1
    [ $? -eq 0 ] && print_error "1.ruby-2.4卸载失败，请检查脚本" "1.ruby-2.4 uninstall failed, please check the script" || print_massage "rvm-2.4卸载成功" "rvm-2.4 uninstall successfully"
}

script_info() {
    print_massage "名字：ruby-2.4" "Name：ruby-2.4"
    print_massage "版本：2.4.1" "Version：2.4.1"
    print_massage "介绍：Ruby，一种简单快捷的面向对象脚本语言" "Introduction: Ruby，一种简单快捷的面向对象脚本语言"
    print_massage "作者：日行一善" "do one good deed a day"
}
