#!/usr/bin/env bash
#test组  测试，不成功将给出返回值，或者退出报错



#测试版本，当前只支持redhat与centos
test_version() {
    local ver
    if [ -f /etc/redhat-release ];then
        ver=`grep -oE "[0-9.]"+ /etc/redhat-release`
    else
        print_error "当前只支持redhat与centos系列" "Currently only supports redhat and centos series"
    fi
}

#控制启动关闭，仅限yum安装，$1填写start,stop,restart,status，$2填写服务名
test_man() {
	local ver=`cat /etc/redhat-release |awk  '{print $4}' | awk -F'.' '{print $1}'`
	if [[ $ver -eq 6 ]];then
		service $2 $1
	elif [[ $ver -eq 7 ]];then
		systemctl $1 $2
	fi
}

#创建日志目录，并检测服务目录，$1是目录名
test_dir() {
    if [[ ! $1 ]];then
        return 1
    else
        [[ -d ${install_dir}/$1 ]] && print_error "${install_dir}/${1}目录已经存在，请检查安装脚本路径或手动删除目录" "${install_dir}/${1} directory already exists, please check the installation script path or manually delete the directory"
        [[ ! -d ${install_dir} ]] && mkdir -p ${install_dir}
        [[ ! -d ${log_dir}/$1 ]] &&  mkdir -p ${log_dir}/$1
    fi
}

#依赖，如果依赖的脚本安装失败，则退出报错
test_rely() {
    if [[ ! $1 ]];then
        return 1
    else
        local i
        for i in `echo $@`
        do
            bash ssc.sh install $i
            [[ $? -eq 1 ]] && print_error "依赖${i}安装失败" "Depends on ${i} installation failed" || source /etc/profile
        done
    fi
}

#检查端口是否被占用，$1填写端口
test_port() {
    if [[ ! $1 ]];then
        return 1
    else
        for i in `echo $@`
        do
            netstat -unltp | grep :${i}
            if [[ $? -eq 0 ]];then
                print_error "${i}端口被占用，请检查端口或修改脚本" "${i} port is occupied, please check the port or modify the scriptt"
            fi
        done
    fi
}

#位置变量皆为软件包名
test_install() {
    if [[ ! $1 ]];then
        return 1
    else
        for i in `echo $@`
        do
            yum -y install $i &> /dev/null
            yum -y install  $i $> /dev/null
            [ $? -eq 0 ] || print_error "${i}安装包未能用yum安装，请重新执行脚本" "${i} installation package failed to install with yum, please re-execute the script"
        done
    fi
}

#位置变量软件包名，卸载
test_remove() {
    for i in `echo $@`
    do
        yum -y remove $i &> /dev/null
        rpm -q $i
        [ $? -eq 0 ] && print_error "${i}安装包未能用yum卸载，请手动卸载" "The ${i} package failed to remove with yum, please remove it manually"
    done
}

#测试是否是root
test_root(){
    if [[ $EUID -ne 0 ]]; then
       print_error "这个脚本需要root权限" "This script must be run as root"
    fi
}

#使用systemctl启动，$1填写服务名
test_start() {
    for i in `echo $@`
    do
        systemctl status $i | grep 'Active: active (running)'
        if [[ $? -ne 0 ]];then
            systemctl restart $i
            systemctl status $i | grep 'Active: active (running)'
            [[ $? -eq 0 ]] || print_error "$i服务启动失败，请检查脚本" "Failed to start the $i service, please check the script"
        fi
        systemctl enable $i
    done
}

#测试是否可以联网
test_www() {
    local a=`curl -o /dev/null --connect-timeout 3 -s -w "%{http_code}" www.baidu.com`
    [[ $a -eq 200 ]] || print_error "当前环境需要连接网络，请检查网络问题" "Unable to access external network, please try again or debug network"
}

#关于使用脚本的，$1为脚本名
test_bin() {
    command=/usr/local/bin/$1
    rm -rf $command
    cp material/$1 $command
    [[ -f $command ]] || print_error "脚本 $command不存在，请联系作者" "Script  $command does not exist, Please contact the author"
    chmod +x $command
    
    if [[ ! $server_dir ]];then
        return 1
    else
        sed -i "2a install_dir=${install_dir}" $command
        sed -i "3a log_dir=${log_dir}" $command
        sed -i "4a server_dir=${server_dir}" $command
    fi
}

#下载,$1写下载地址或者package文件夹中包名，$2写md5值
test_package() {
    test_install wget
    local a=0 b=`echo ${1##*/}` c i

    if [[ -f package/$b ]];then 
        if [[ ! $2 ]];then
            a=1
        else
            c=`md5sum package/$b | awk '{print $1}'` #如果包存在则将包md5值比对
            if [[ "$c" == "$2" ]];then
                a=1
            else
                rm -rf package/$b #比对失败则下载包不对，将文件删除
                print_error "${b}的md5值比对失败，请重新安装" "The ${b} md5 value comparison fails, Please reinstall"
            fi
        fi
    fi
    
    if [[ $a -eq 0 ]];then
        wget -O package/${b} $1
        [[ -f package/${b} ]] || print_error "${b}安装包下载失败，请重新安装" "${b}Installation package download failed, please reinstall"
        test_package $1 $2
    fi
}


#########综合函数#########

#初始化做的事情
test_init() {
    test_install net-tools
}

#检测函数
test_detection() {
    test_port ${port}
    test_dir ${server_dir}
    test_rely ${server_rely}
    test_install ${server_yum}
}