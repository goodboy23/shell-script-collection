#!/usr/bin/env bash



#[使用设置]

#主目录
#install_dir=/usr/local

#服务目录
jdk_dir=jdk-1.7



script_get() {
    test_package http://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/jdk-1.7.0.tar.gz 99a52cfd9874eb7999a5ea092bb3242d
}

script_install() {
    java -version 2&> conf/log.txt
    grep 'version "1.7' conf/log.txt
    if [[ $? -eq 0 ]];then
        print_massage "检测到已安装" "Detected installed"
        exit
    else
        java -version
        if [[ $? -eq 0 ]];then
            print_error "当前已有其它版本jdk，请手动卸载" "There are other versions of jdk currently, please uninstall manually"
        fi
    fi

    test_dir ${jdk_dir}

    #安装服务
    script_get
    tar -xf package/jdk-1.7.0.tar.gz
    mv jdk1.7.0 ${install_dir}/${jdk_dir}
    
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
    [ $? -eq 0 ] || print_error "安装失败，请联系作者" "Installation failed, please contact the author"

	print_massage "jdk-1.8安装完成" "Jdk-1.8 installation is complete"
	print_massage "安装目录：${install_dir}/${jdk_dir}" "Install Dir：${install_dir}/${jdk_dir}"
	print_massage "使用：java -version" "Use：java -version"
}

script_remove() {
    rm -rf ${install_dir}/${jdk_dir}
    sed -i '/^export JAVA_HOME=/d' /etc/profile
    sed -i '/^export JRE_HOME=/d'  /etc/profile
    sed -i '/^export CLASSPATH=/d' /etc/profile
    sed -i '/^export PATH=$JAVA_HOME/d' /etc/profile
    source /etc/profile
    
    java -version
    [[ $? -eq 0 ]] && print_error "jdk-1.8卸载失败，请联系作者" "Jdk-1.8 uninstall failed, please contact the author" || print_massage "卸载完成" "Uninstall completed"
}

script_info() {
    print_massage "名字：jdk-1.7" "Name：dk-1.7"
    print_massage "版本：1.7.0" "Version：1.7.0"
    print_massage "介绍：JDK是 Java 语言的软件开发工具包" "Introduction: JDK is a Java language software development kit"
    print_massage "作者：日行一善" "do one good deed a day"
}
