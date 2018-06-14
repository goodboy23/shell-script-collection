#!/usr/bin/env bash



script_get() {
    print_massage "不用下载" "Do not download"
}

script_install() {
    if [[ -f /usr/local/bin/notty ]];then
        print_massage "1.检测到当前系统已安装" "1.Detected that the current system is installed"
        exit
    fi
    
    test_bin notty

	print_massage "notty安装完成" "The notty is installed"
	print_massage "安装目录：/usr/local/bin/notty" "Install Dir：/usr/local/bin/notty"
	print_massage "使用：notty" "Use：notty"
}

script_remove() {
	rm -rf /usr/local/bin/notty
    
    [ -f /usr/local/bin/notty ] && print_error "1.notty未成功删除，请检查脚本" "1.notty unsuccessfully deleted, please check the script" || print_massage "notty卸载完成！" "notty Uninstall completed！"
}

script_info() {
	print_massage "名字：notty" "Name：notty"
	print_massage "版本：1.2" "Version：1.2"
	print_massage "介绍：禁止密码爆破脚本" "Introduce：Prevent password blasting script"
    print_massage "作者：日行一善" "do one good deed a day"
    print_massage "使用说明：根据lastb来禁止访问次数多的ip，默认5次登陆失败将禁止登陆。" "Instructions for use: According to the lastb to prohibit access to more ip, the default 5 login failure will be prohibited login."
}