#!/usr/bin/env bash



script_get() {
    test_package https://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/apache-ant-1.9.11-bin.tar.gz 07946e9d2d342f3ddfc7cb41c9896401
}

script_install() {
    ant -version
    if [[ $? -eq 0 ]];then
        print_massage "检测到当前系统已安装" "Detected that the current system is installed"
        exit
    fi
    tar -xf package/apache-ant-1.9.11
    mv apache-ant-1.9.11 /usr/local/ant-1.9
    
    sed -i '/^export ANT_HOME=/d' /etc/profile
    sed -i '/^export PATH=${ANT_HOME}/d' /etc/profile
    
    echo 'export ANT_HOME=/usr/local/ant-1.9' >> /etc/profile
    echo 'export PATH=${ANT_HOME}/bin:${PATH}' >> /etc/profile
    source /etc/profile
    
    ant -version
    [[ $? -eq 0 ]] || print_error "ant-1.9安装失败，请检查脚本" "ant-1.9 installation failed, please check the script"

	print_massage "ant-1.9安装完成" "The ant-1.9 is installed"
	print_massage "安装目录：/usr/local/ant-1.9" "Install Dir：/usr/local/ant-1.9"
	print_massage "使用：ant-1.9" "Use：ant-1.9"
	print_massage "使用说明：配置ant环境" "Instructions for use: Configure ant environment"
}

script_remove() {
	rm -rf /usr/local/ant-1.9
    
    sed -i '/^export ANT_HOME=/d' /etc/profile
    sed -i '/^export PATH=${ANT_HOME}/d' /etc/profile
    source /etc/profile
    
    ant -version
    [[ $? -eq 0 ]] && print_error "ant-1.9未成功删除，请检查脚本" "ant-1.9 unsuccessfully deleted, please check the script" || print_massage "ant-1.9卸载完成！" "ant-1.9 Uninstall completed！"
}

script_info() {
	print_massage "名字：ant-1.9" "Name：ant-1.9"
	print_massage "版本：1.9" "Version：1.9"
	print_massage "介绍：Ant，是一个基于JAVA的自动化脚本引擎。" "Introduce：Ant is a Java-based automated scripting engine."
	print_massage "作者：速度与激情小组---Linux部" "Author：Speed and Passion Group --- Linux Department"
}