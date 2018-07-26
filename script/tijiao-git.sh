#!/usr/bin/env bash



script_get() {
    print_massage "不用下载" "Do not download"
}

script_install() {
    if [[ -f /usr/local/bin/tijiao-git ]];then
        print_massage "检测到当前系统已安装" "Detected that the current system is installed"
        exit
    fi
    
    test_bin tijiao-git

    print_install_bin $1
}

script_remove() {
	rm -rf /usr/local/bin/tijiao-git
    
    print_remove_ok $1
}

script_info() {
	print_massage "名字：tijiao-git" "Name：tijiao-git"
	print_massage "版本：1.0" "Version：1.0"
	print_massage "介绍：自动提交代码到github" "Introduce：Automatically submit code to github"
    print_massage "使用说明：需要修改脚本填写github账号" "Instructions: need to modify the script to fill in the github account"
	print_massage "作者：日行一善" "do one good deed a day"
}
