#!/usr/bin/env bash



#[使用设置]
#主目录，相当于/usr/local
#install_dir=

#服务目录名
maven_dir=maven-3.5



script_get() {
    test_package https://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/apache-maven-3.5.2-bin.tar.gz 948110de4aab290033c23bf4894f7d9a
}

script_install() {
    mvn -v | grep 3.5
    if [[ $? -eq 0 ]];then
        print_massage "检测到已安装" "Detected installed"
        exit
    else
        mvn -v
        if [[ $? -eq 0 ]];then
            print_error "当前已有其它版本maven，请手动卸载" "There are other versions of maven currently, please uninstall manually"
        fi
    fi
    
    test_rely jdk-1.8
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
    [[ $? -eq 0 ]] || print_error "maven-3.5安装失败，请检联系作者" "maven-3.5 installation failed, Please check the author"
    
	print_massage "maven-3.5安装完成" "The maven-3.5 is installed"
	print_massage "安装目录：${install_dir}/${maven_dir}" "Install Dir：${install_dir}/${maven_dir}"
	print_massage "使用：mvn -v" "Use：mvn -v"
}

script_remove() {
    rm -rf /usr/local/maven-3.5
    sed -i '/^export MAVEN_HOME=/d' /etc/profile
    sed -i '/^export PATH=${MAVEN_HOME}/d' /etc/profile
    
    source /etc/profile
    which mvn
    [[ $? -eq 0 ]] && print_error "maven-3.5未成功删除，请联系作者" "maven-3.5 unsuccessfully deleted, Please check the author" || print_massage "maven-3.5卸载完成！" "maven-3.5 Uninstall completed！"
}

script_info() {
	print_massage "名字：maven-3.5" "Name：maven-3.5"
	print_massage "版本：3.5" "Version：3.5"
	print_massage "介绍：纯Java编写的开源项目管理工具" "Introduction: Open source project management tool written in pure Java"
    print_massage "作者：日行一善" "do one good deed a day"
}
