#!/usr/bin/env bash



script_get() {
	test_package https://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/Python-3.6.0.tgz 3f7062ccf8be76491884d0e47ac8b251
}

script_install() {
    python3.6 --version
    if [[ $? -eq 0 ]];then
        print_massage "检测到当前系统已安装" "Detected that the current system is installed"
        exit
    fi
    
	test_install gcc make cmake openssl-devel bzip2-devel expat-devel gdbm-devel readline-devel sqlite-devel
    script_get
    
	tar -xf package/Python-3.6.0.tgz
	cd Python-3.6.0
	./configure --prefix=/usr/local/python3.6
	make
	make altinstall
	
	ln -s /usr/local/python3.6/bin/python3.6 /usr/bin/python3.6
    ln -s /usr/local/python3.6/bin/python3.6 /usr/bin/python3
	
	#测试
	python3.6 --version
	[ $? -eq 0 ] || print_error "安装失败，请查看脚本" "Installation failed, please check the script"
    
 	print_massage "python3.6安装完成" "The python3.6 is installed"
	print_massage "安装目录：/usr/local/python3.6" "Install Dir：/usr/local/python3.6"
	print_massage "使用：python3.6" "Use：python3.6"
}

script_remove() {
	rm -rf /usr/local/python3.6
    rm -rf /usr/bin/python3.6
    rm -rf /usr/bin/python3
	
    python3.6 --version
    [[ $? -eq 0 ]] && print_error "卸载失败，请检查脚本" "Uninstall failed, please check the script"|| print_massage "python卸载完成！" "Python uninstall complete"
}

script_info() {
	print_massage "名字：python-3.6" "Name：python-3.6"
	print_massage "版本：3.6" "Version：3.6"
	print_massage "介绍：Python是一种解释型、面向对象、动态数据类型的高级程序设计语言" "Introduce：Python is an interpretive, object-oriented, dynamic data type high-level programming language"
	print_massage "作者：速度与激情小组---Linux部" "Author：Speed and Passion Group --- Linux Department"
}
