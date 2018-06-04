#!/usr/bin/env bash



#[使用设置]

#主目录
#install_dir=/usr/local

#服务目录
jdk_dir=jdk-1.8



script_get() {
    test_package http://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/jdk-8u152-linux-x64.tar.gz adfb92ae19a18b64d96fcd9a3e7bfb47
}

script_install() {
    java -version
    if [[ $? -eq 0 ]];then
        print_massage "检测到当前系统已安装" "Detected that the current system is installed"
        exit
    fi

    test_dir ${jdk_dir}
    
    #卸载yum装的
    yum -y remove java-1.8.0-openjdk

    #安装服务
    get_jdk
    tar -xf package/jdk-8u152-linux-x64.tar.gz
    rm -rf ${install_dir}/jdk-1.8
    mv jdk1.8.0_152 ${install_dir}/jdk-1.8
    
    #环境变量
    sed -i '/^export JAVA_HOME=/d' /etc/profile
    sed -i '/^export JRE_HOME=/d'  /etc/profile
    sed -i '/^export CLASSPATH=/d' /etc/profile
    sed -i '/^export PATH=$JAVA_HOME/d'  /etc/profile
    
    echo "export JAVA_HOME=${install_dir}/${jdk_dir}" >> /etc/profile
    echo "export JRE_HOME=${install_dir}/${jdk_dir}/jre" >> /etc/profile
    echo 'export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib' >> /etc/profile
    echo 'export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH' >> /etc/profile
    
    source /etc/profile
    
    #测试
    java -version
    [ $? -eq 0 ] || test_exit "安装失败，请检查脚本" "Installation failed, please check the script"

	print_massage "jdk-1.8安装完成" "Jdk-1.8 installation is complete"
	print_massage "安装目录：${install_dir}/${jdk_dir}" "Install Dir：${install_dir}/${jdk_dir}"
	print_massage "使用：java -version" "Use：java -version"
	print_massage "使用说明：java环境" "Instructions for use: Java environment"
}

script_remove() {
    rm -rf ${install_dir}/${jdk_dir}
    sed -i '/^export JAVA_HOME=/d' /etc/profile
    sed -i '/^export JRE_HOME=/d'  /etc/profile
    sed -i '/^export CLASSPATH=/d' /etc/profile
    sed -i '/^export PATH=$JAVA_HOME/d'  /etc/profile

    java -version
    [[ $? -eq 0 ]] && print_error "jdk-1.8卸载失败，请检查脚本" "Jdk-1.8 uninstall failed, please check the script" || print_massage "卸载完成" "Uninstall completed"
}

script_info() {
    print_massage "名字：jdk-1.8" "Name：dk-1.8"
    print_massage "版本：1.8.0" "Version：1.8.0"
    print_massage "介绍：JDK是 Java 语言的软件开发工具包" "Introduction: JDK is a Java language software development kit"
	print_massage "作者：速度与激情小组---Linux部" "Author：Speed and Passion Group --- Linux Department"
}
