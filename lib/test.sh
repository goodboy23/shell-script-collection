#!/usr/bin/env bash
#test组  测试，不成功将给出返回值，或者退出报错



#测试版本，当前只支持redhat7与centos7
test_version() {
    local ver
    if [[ -f /etc/redhat-release ]];then
        ver=`grep ' 7.' /etc/redhat-release`
    else
        print_error "当前只支持redhat7与centos7系列" "Currently only supports redhat7 and centos7 series"
    fi
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

#位置变量软件包名，卸载
test_remove() {
    for i in `echo $@`
    do
        yum -y remove $i &> /dev/null
        rpm -q $i
        [ $? -eq 0 ] && print_error "${i}安装包未能用yum卸载，请手动卸载" "The ${i} package failed to remove with yum, please remove it manually"
    done
}

#测试是否可以联网
test_www() {
    local a=`curl -o /dev/null --connect-timeout 3 -s -w "%{http_code}" www.baidu.com`
    [[ $a -eq 200 ]] || print_error "当前环境需要连接网络，请检查网络问题" "Unable to access external network, please try again or debug network"
}

#关于使用脚本的，$1为脚本名
test_bin() {
	[[ -d /usr/local/bin ]] || print_error "/usr/local/bin目录不存在，请创建并加入到环境变量" "The /usr/local/bin directory does not exist. Please create and add to the environment variable."
    command=/usr/local/bin/$1
 
	rm -rf $command
    cp material/$1 $command
    [[ -f $command ]] || print_error "脚本 $command不存在" "Script  $command does not exist"
    chmod +x $command
	
	[[ $install_dir != "no" ]] && sed -i "2a install_dir=${install_dir}" $command
    [[ $log_dir != "no" ]] && sed -i "3a log_dir=${log_dir}" $command
    [[ $server_dir != "no" ]] && sed -i "4a server_dir=${server_dir}" $command
}

#下载,$1写下载地址或者package文件夹中包名，$2写md5值
test_package() {
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

#创建日志目录，并检测服务目录，$1是目录名
test_dir() {
    if [[ ! $1 ]];then
        return 1
    else
        [[ -d ${install_dir}/$1 ]] && print_error "${install_dir}/${1}目录已经存在，请检查安装脚本路径或手动删除目录" "${install_dir}/${1} directory already exists, please check the installation script path or manually delete the directory"
        [[ ! -d ${install_dir} ]] && mkdir -p ${install_dir}
        [[ "$log_dir" != no ]] && [[ ! -d ${log_dir}/$1 ]] &&  mkdir -p ${log_dir}/$1
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
            netstat -unltp | grep -w :${i}
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
            grep -w "$i" ${ssc_dir}/conf/yum.log
            if [[ $? -ne 0 ]];then
                yum -y install $i #这里不用rpm -q检测，因为像nc这种命令，他其实是属于net-tools包的，rpm查不到nc。
                [[ $? -eq 0 ]] && echo "$i" >> ${ssc_dir}/conf/yum.log || print_error "${i}安装包未能用yum安装，请重新执行脚本" "${i} installation package failed to install with yum, please re-execute the script" 
            fi
        done
    fi
}

yum_get() {
	if [[ ! $server_yum ]];then
		return 1
	else
		[[ -d ${ssc_dir}/package/${1} ]] || mkdir ${ssc_dir}/package/${1}
	
	    for i in `echo ${server_yum[*]}`
        do
			yum install -y --downloadonly --downloaddir=${ssc_dir}/package/${1} $i
			if [[ $? -ne 0 ]];then
				print_error "rpm包：${i} 下载失败" "rpm package: ${i} download failed"
			fi
        done
	fi
}

rely_get() {
	if [[ ! $server_rely ]];then
		return 1
	else
		for i in `echo ${server_rely[*]}`
		do
			cd $ssc_dir
			bash ssc.sh get $i
		done
	fi
}



#########综合函数#########

#初始化做的事情
test_init() {
    if [[ ! -f ${ssc_dir}/conf/init.log ]];then
        test_install net-tools epel-release wget yum-plugin-downloadonly
    fi
}

test_detection() {
	test_port ${port}
    test_dir ${server_dir}
    test_rely ${server_rely}
	
    if [[ -d ${ssc_dir}/package/${1} ]];then
		cd ${ssc_dir}/package/${1}
		yum -y install *
		
		for i in `ls`
		do
			local bao_name=`echo "${i}" | awk -F'.rpm' '{print $1}'`
			rpm -q ${bao_name}
			[[ $? -eq 0 ]] &&  echo "${bao_name}" >> ${ssc_dir}/conf/yum.log || print_error "rpm包：${bao_name} 未安装成功" "rpm package: ${bao_name} not installed successfully"
		done
	else
		test_install ${server_yum}
	fi
	cd ${ssc_dir}
}