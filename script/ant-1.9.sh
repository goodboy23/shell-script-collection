#!/usr/bin/env bash



#[使用设置]

#主目录，相当于/usr/local
#install_dir=

#服务目录名
ant_dir=ant-1.9



script_get() {
    test_package https://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/apache-ant-1.9.11-bin.tar.gz 07946e9d2d342f3ddfc7cb41c9896401
}

script_install() {
    ant -version
    if [[ $? -eq 0 ]];then
        print_massage "1.检测到当前系统已安装" "1.Detected that the current system is installed"
        exit
    fi
    
    test_dir $ant_dir
    script_get
    tar -xf package/apache-ant-1.9.11
    mv apache-ant-1.9.11 ${install_dir}/${ant_dir}

    sed -i '/^export ANT_HOME=/d' /etc/profile
    sed -i '/^export PATH=${ANT_HOME}/d' /etc/profile
    
    echo "export ANT_HOME=${install_dir}/${ant_dir}" >> /etc/profile
    echo 'export PATH=${ANT_HOME}/bin:${PATH}' >> /etc/profile
    source /etc/profile
    
    ant -version
    [[ $? -eq 0 ]] || print_error "2.ant-1.9安装失败，请检查脚本" "2.ant-1.9 installation failed, please check the script"

	print_massage "ant-1.9安装完成" "The ant-1.9 is installed"
	print_massage "安装目录：${install_dir}/${ant_dir}" "Install Dir：${install_dir}/${ant_dir}"
	print_massage "验证：ant -version" "verification：ant -version"
}

script_remove() {
	rm -rf ${install_dir}/${ant_dir}
    
    sed -i '/^export ANT_HOME=/d' /etc/profile
    sed -i '/^export PATH=${ANT_HOME}/d' /etc/profile
    source /etc/profile
    
    ant -version
    [[ $? -eq 0 ]] && print_error "1.ant-1.9未成功删除，请检查脚本" "1.ant-1.9 unsuccessfully deleted, please check the script" || print_massage "ant-1.9卸载完成！" "ant-1.9 Uninstall completed！"
}

script_info() {
	print_massage "名字：ant-1.9" "Name：ant-1.9"
	print_massage "版本：1.9" "Version：1.9"
	print_massage "介绍：配置ant环境" "Introduce：Configure ant environment"
	print_massage "作者：日行一善" "do one good deed a day"
}
