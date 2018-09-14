#!/usr/bin/env bash



#[使用设置]

#主目录
#install_dir=/usr/local

#服务目录
server_dir=jdk



script_get() {
    test_package http://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/jdk-8u152-linux-x64.tar.gz adfb92ae19a18b64d96fcd9a3e7bfb47
}

script_install() {
    java -version &> conf/log.txt
    grep 'version "1.8' conf/log.txt
    if [[ $? -eq 0 ]];then
        print_massage "检测到已安装" "Detected installed"
        exit
    else
        java -version
        if [[ $? -eq 0 ]];then
            print_error "当前已有其它版本jdk，请手动卸载" "There are other versions of jdk currently, please uninstall manually"
        fi
    fi

   	#依赖
	test_detection ${1}

    #安装服务
    script_get
	rm -rf jdk1.8.0_152
    tar -xf package/jdk-8u152-linux-x64.tar.gz
    rm -rf ${install_dir}/jdk-1.8
    mv jdk1.8.0_152 ${install_dir}/${server_dir}
    
    #环境变量
    sed -i '/^export JAVA_HOME=/d' /etc/profile
    sed -i '/^export JRE_HOME=/d'  /etc/profile
    sed -i '/^export CLASSPATH=/d' /etc/profile
    sed -i '/^export PATH=$JAVA_HOME/d'  /etc/profile
    
    echo "export JAVA_HOME=${install_dir}/${server_dir}" >> /etc/profile
    echo "export JRE_HOME=${install_dir}/${server_dir}/jre" >> /etc/profile
    echo 'export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib' >> /etc/profile
    echo 'export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH' >> /etc/profile
    source /etc/profile
    
    #测试
    java -version
    [[ $? -eq 0 ]] || print_error "${1}安装失败" "${1}Installation failed"

    print_install_ok $1
	print_massage "使用：java -version" "Use：java -version"
}

script_remove() {
    rm -rf ${install_dir}/${server_dir}
    sed -i '/^export JAVA_HOME=/d' /etc/profile
    sed -i '/^export JRE_HOME=/d'  /etc/profile
    sed -i '/^export CLASSPATH=/d' /etc/profile
    sed -i '/^export PATH=$JAVA_HOME/d' /etc/profile

    print_remove_ok $1
}

script_info() {
    print_massage "名字：jdk-1.8" "Name：dk-1.8"
    print_massage "版本：1.8.0" "Version：1.8.0"
    print_massage "介绍：JDK是 Java 语言的软件开发工具包" "Introduction: JDK is a Java language software development kit"
    print_massage "作者：日行一善" "do one good deed a day"
}
