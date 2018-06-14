#!/usr/bin/env bash



script_get() {
    test_package "http://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/node-v8.9.3-linux-x64.tar.xz" "32948a8ca5e6a7b69c03ec1a23b16cd2"
}

script_install() {
    node -v
    if [[ $? -eq 0 ]];then
        print_massage "1.检测到当前系统已安装" "1.Detected that the current system is installed"
        exit
    fi

    get_nodejs
    tar -xf package/node-v8.9.3-linux-x64.tar.xz
    rm -rf /usr/local/nodejs-8.9
    mv node-v8.9.3-linux-x64 /usr/local/nodejs-8.9
    
    #链接
	rm -rf /usr/local/bin/node
    rm -rf /usr/local/bin/npm
    ln -s ${install_dir}/${nodejs_dir}/bin/node /usr/local/bin/node
    ln -s ${install_dir}/${nodejs_dir}/bin/npm /usr/local/bin/npm

    #对结果进行测试
    node -v
    [ $? -eq 0 ] || print_error "2.安装失败，请检查脚本" "2.Installation failed, please check the installation script"
    
	print_massage "nodejs-8.9安装完成" "The nodejs-8.9 is installed"
	print_massage "安装目录：/usr/local/nodejs-8.9" "Install Dir：/usr/local/nodejs-8.9"
	print_massage "使用：node -v" "Use：node -v"
}

script_remove() {
    rm -rf /usr/local/bin/node
    rm -rf /usr/local/bin/npm
	rm -rf /usr/local/nodejs-8.9
    
    node -v
	 [[ $? -eq 0 ]] && print_error "1.卸载失败，请检查脚本" "1.Uninstall failed, please check the script" ||print_massage "nodejs卸载完成！" "nodejs Uninstall completed！"
}

script_info() {
	print_massage "名字：nodejs-8.9" "Name：nodejs-8.9"
	print_massage "版本：8.9.3" "Version：8.9.3"
	print_massage "介绍：Node.js 就是运行在服务端的 JavaScript。" "Introduce：Node.js is JavaScript that runs on the server."
    print_massage "作者：日行一善" "do one good deed a day"
}
