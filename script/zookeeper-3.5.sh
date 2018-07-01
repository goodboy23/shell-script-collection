#!/usr/bin/env bash



#[使用设置]

#主目录，相当于/usr/local
#install_dir=

#服务目录名
zookeeper_dir=zookeeper

port=2181


script_get() {
    test_package http://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/zookeeper-3.5.2-alpha.tar.gz adc27d412f283c0dc6ec9d08e30f4ec0
}

script_install() {
    which zkServer.sh
    if [[ $? -eq 0 ]];then
        print_massage "1.检测到当前系统已安装" "1.Detected that the current system is installed"
        exit
    fi
    
    test_port ${port}
    test_rely jdk-1.8
    test_dir ${zookeeper_dir}
    
    script_get
    tar -xf   package/zookeeper-3.5.2-alpha.tar.gz
    mv zookeeper-3.5.2-alpha ${install_dir}/${zookeeper_dir}
    
    #环境变量
    sed -i '/^ZOOKEEPER_HOME=/d' /etc/profile
    sed -i '/^PAHT=ZOOKEEPER_HOME/d'  /etc/profile
    
    echo "ZOOKEEPER_HOME=${install_dir}/${zookeeper_dir}/bin" >> /etc/profile
    echo 'PATH=$ZOOKEEPER_HOME:$PATH' >> /etc/profile
    source /etc/profile
   
    #配置文件
    rm -rf ${install_dir}/${zookeeper_dir}/conf/zoo.cfg
    echo "tickTime=2000  
dataDir=${install_dir}/${zookeeper_dir}
clientPort=2181  
initLimit=5  
syncLimit=2" >> ${install_dir}/${zookeeper_dir}/conf/zoo.cfg

    which zkServer.sh
    [ $? -eq 0 ] || print_error "2.环境变量设置失败，请检查脚本" "2.environment variable settings failed, please check the script"
    
	print_massage "zookeeper-3.5安装完成" "The zookeeper-3.5 is installed"
	print_massage "安装目录：/usr/local/bin/zookeeper-3.5" "Install Dir：/usr/local/bin/zookeeper-3.5"
	print_massage "使用：zkServer.sh start" "Use：zkServer.sh start"
}

script_remove() {
    rm -rf ${install_dir}/${zookeeper_dir}
    
    sed -i '/^ZOOKEEPER_HOME=/d' /etc/profile
    sed -i '/^PAHT=ZOOKEEPER_HOME/d'  /etc/profile
    source /etc/profile
    
	which zkServer.sh
    [ $? -eq 0 ] && print_error "1.zookeeper-3.5未成功删除，请检查脚本" "1.zookeeper-3.5 unsuccessfully deleted, please check the script" || print_massage "zookeeper-3.5卸载完成！" "zookeeper-3.5 Uninstall completed！"
}

script_info() {
	print_massage "名字：zookeeper-3.5" "Name：zookeeper-3.5"
	print_massage "版本：3.5.2" "Version：3.5.2"
	print_massage "介绍：分布式应用程序协调服务" "Introduce：Distributed Application Coordination Service"
	print_massage "作者：日行一善" "do one good deed a day"
}
