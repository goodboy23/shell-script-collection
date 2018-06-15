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

#创建日志目录，并检测服务目录，$1是目录名
test_dir() {
    [[ -d ${install_dir}/$1 ]] && print_error "${install_dir}/${1}目录已经存在，请检查安装脚本路径或手动删除目录" "${install_dir}/${1} directory already exists, please check the installation script path or manually delete the directory"
    [[ ! -d ${install_dir} ]] && mkdir -p ${install_dir}
    [[ ! -d ${log_dir}/$1 ]] &&  mkdir -p ${log_dir}/$1
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
    local command=/usr/local/bin/$1
    rm -rf $command
    cp material/$1 $command
    [[ -f $command ]] || print_error "脚本 $command不存在，请检查脚本" "Script  $command does not exist, please check the script"
    chmod +x $command
    
}

#检查端口是否被占用，$1填写端口
test_port() {
    test_install net-tools
    netstat -unltp | grep :${1}
    if [[ $? -eq 0 ]];then
        print_error "${1}端口被占用，请修改脚本" "The ${1} port is occupied. Please modify the script"
    fi
}

#位置变量皆为软件包名
test_install() {
    for i in `echo $@`
    do
        yum -y install $i
        rpm -q $i
        [ $? -eq 0 ] || print_error "${i}安装包未能用yum安装，请手动安装" "The ${i} package failed to install with yum, please install it manually"
    done
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
                print_error "md5值比对失败，请检查脚本或安装包" "The md5 value comparison fails, please check the script or installation package"
            fi
	fi
    fi
    
    if [[ $a -eq 0 ]];then
        wget -O package/${b} $1
        test_package $1 $2
    fi
}

#依赖，如果依赖的脚本安装失败，则退出报错
test_rely() {
    local i
    for i in `echo $@`
    do
        bash ssc.sh install $i
        [[ $? -eq 1 ]] && print_error "依赖${i}安装失败" "Depends on ${i} installation failed" || source /etc/profile
    done
}
