#!/usr/bin/env bash



#[使用设置]
#主目录，相当于/usr/local
#install_dir=

#服务目录名
maven_dir=maven3.5



script_get() {
    test_package https://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/apache-maven-3.5.2-bin.tar.gz 948110de4aab290033c23bf4894f7d9a
}

script_install() {
    which mvn
    if [[ $? -eq 0 ]];then
        print_massage "检测到当前系统已安装" "Detected that the current system is installed"
        exit
    fi
    
    test_dir ${maven_dir}
    
    script_get
    tar -xf package/apache-maven-3.5.2-bin.tar.gz
    mv apache-maven-3.5.2 ${install_dir}/${maven_dir}
    
    #清理环境变量
    sed -i '/^export MAVEN_HOME=/d' /etc/profile
    sed -i '/^export PATH=${MAVEN_HOME}/d' /etc/profile
    
    echo "export MAVEN_HOME=${install_dir}/${maven_dir}" >> /etc/profile
    echo 'export PATH=${MAVEN_HOME}/bin:${PATH}' >> /etc/profile
    source /etc/profile
    
    mvn -v
    [[ $? -eq 0 ]] || print_error "maven-3.5安装失败，请检查脚本" "maven-3.5 installation failed, please check the script"
    
	print_massage "maven-3.5安装完成" "The maven-3.5 is installed"
	print_massage "安装目录：${install_dir}/${maven_dir}" "Install Dir：${install_dir}/${maven_dir}"
	print_massage "使用：mvn -v" "Use：mvn -v"
	print_massage "使用说明：maven环境部署" "Instructions for use: Maven environment deployment"
}

script_remove() {
    rm -rf /usr/local/maven-3.5
    sed -i '/^export MAVEN_HOME=/d' /etc/profile
    sed -i '/^export PATH=${MAVEN_HOME}/d' /etc/profile
    
    source /etc/profile
    which mvn
    [[ $? -eq 0 ]] && print_error "maven-3.5未成功删除，请检查脚本" "maven-3.5 unsuccessfully deleted, please check the script" || print_massage "maven-3.5卸载完成！" "maven-3.5 Uninstall completed！"
}

script_info() {
	print_massage "名字：maven-3.5" "Name：maven-3.5"
	print_massage "版本：3.5" "Version：3.5"
	print_massage "介绍：maven环境部署" "Introduction: Maven environment deployment"
	print_massage "作者：速度与激情小组---Linux部" "Author：Speed and Passion Group --- Linux Department"
}
