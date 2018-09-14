#!/usr/bin/env bash
# 作者：日行一善（qq群762696893）
# 有任何问题或想一起编写，加qq群联系管理。
#
# 功能：shell脚本合集
# 支持：redhat与centos系列
#
# 地址：github https://github.com/goodboy23/shell-script-collection
#       官网   http://www.52wiki.cn/docs/shell/741



#[使用设置]

#输出显示，cn中文，en英文
language=cn

#全局安装目录，所有服务默认安装位置
install_dir=/usr/local

#全局日志目录，所有服务默认日志位置
log_dir=/var/log

#edit选项的编辑器，可选择vi或其他
editor=vim

#当前ssc所在路径
ssc_dir=`pwd`

#安装完成后输出到日志里
ssc_log="${ssc_dir}/install_ok.log"



#########消息函数#########

#提示并退出脚本，$1中文，$2英文
print_error() {
    echo
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    [[ "$language" == "cn" ]] && echo "错误：$1" || echo "Error：$2"
    echo
    [[ "$language" == "cn" ]] && echo "重新执行或联系作者" || echo "Re-execute or contact the author"
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

    exit 1
}

#消息输出，$1中文，$2英文
print_massage() {
	if [[ "$language" == "cn" ]];then
		echo "$1" 
	else
		echo "$2"
	fi
	echo
}

#消息输出，同时输出到日志，用于成功部分
print_log() {
	if [[ "$language" == "cn" ]];then
		echo "$1" 
		echo "$(date +%F/%H/%M/%S) $1" >> $ssc_log
	else
		echo "$2"
		echo "$(date +%F/%H/%M/%S) $2"  >> $ssc_log
	fi
	echo
	echo  >> $ssc_log
}

#$1填写服务名
print_install_ok() {
    clear
	print_log "########################" "########################"
    print_log "${1}安装完成" "The ${1} is installed"
    
	[[ "$install_dir" != "no" ]] && [[ "server_dir" != "no" ]] && print_log "安装目录：${install_dir}/${server_dir}" "Install Dir：${install_dir}/${server_dir}"
	[[ "$log_dir" != "no" ]] && [[ "server_dir" != "no" ]] && print_log "日志目录：${log_dir}/${server_dir}" "Log directory：${log_dir}/${server_dir}"
}

print_install_bin() {
    clear
    print_log "########################" "########################"
    print_log "${1}安装完成" "The ${1} is installed"
	print_log "安装目录：/usr/local/bin/${1}" "Install Dir：/usr/local/bin/${1}"
	print_log "使用：${1}" "Use：${1}"
	print_log "########################" "########################"
}

#$1填写服务名
print_remove_ok() {
    clear
    print_massage "$1卸载完成！" "${1} Uninstall completed！"
    print_massage "依赖均不卸载，可用 './ssc.sh rely 服务名' 来查询有哪些依赖" "Dependencies are not uninstalled, use './ssc.sh rely service name' to query which dependencies"
}



#########基础函数#########

#中文帮助
help_cn() {
	echo "作者：日行一善，如果有使用问题或者想参与编写，请加qq群762696893
当前版本：1.2

install httpd        安装 httpd
remove  httpd        卸载 httpd
get     httpd        离线 httpd 所需要的包
rely    httpd        查询 httpd 有哪些依赖
info    httpd        查询 httpd 详细信息
edit	httpd        编辑 httpd 进行自定义设置

update               升级 ssc

list                 列出 支持  的脚本
list    httpd        列出 httpd 相关脚本"
}

#英文帮助
help_en() {
    echo "Author: Rixingyishan, if you have questions or would like to use in the preparation of, please add qq group 762696893
current version：1.2

install httpd      installation httpd
remove  httpd      Uninstall    httpd
get     httpd      Required     httpd packages for offline
rely    httpd      Rely         httpd query httpd What are the dependencies?
info    httpd      Query        httpd details
edit	httpd      Edit         httpd for custom settings

update             update ssc

list               List supported scripts
list    httpd      List httpd related scripts"
}

p_exit() {    #退出恢复
    print_massage "异常中断退出，请重新安装或联系作者" "Abnormal interrupt exit, please reinstall or contact the author"
    exit 1
}

trap "p_exit;" INT TERM    #当强制退出则执行p_exit函数内容


#更新
update_ssc() {
    test_root
    test_install git
    git clone https://github.com/goodboy23/shell-script-collection.git #下载文件到当前
    [[ -d shell-script-collection ]] || print_error "下载失败，请重新更新" "Install Error，please Renew Update"
    rm -rf /tmp//tmp/batch1-batch2
    mv shell-script-collection /tmp/batch1-batch2
    ls | grep -v package | xargs rm -rf #将安装包以外文件删除
    rm -rf /tmp/batch1-batch2/package #去除新包的package目录
    mv /tmp/batch1-batch2/* . #将新下载的所有内容复制到当前
    rm -rf /tmp/batch1-batch2
    chmod +x ssc.sh
    [[ $? -eq 0 ]] && print_massage "升级成功！" "update ok!" || print_error "安装失败，请重新更新" "Install Error，please Renew Update"
}

#根据每个和脚本的info函数形成支持的脚本列表
list_generate() {
    local z=0
    rm -rf conf/a.txt
    rm -rf conf/b.txt

    for i in `ls script/` #将每个脚本的信息都输出找出前3行形成列表
    do
        i=`echo ${i%.*}`
        a=`bash ssc.sh info $i | awk  -F'：' '{print $2}' | sed -n '1p'`
        b=`bash ssc.sh info $i | awk  -F'：' '{print $2}' | sed -n '3p'`
        c=`bash ssc.sh info $i | awk  -F'：' '{print $2}' | sed -n '5p'`
        print_massage "$a 信息生成完毕" "$a Information generated"
        let z++
        echo "$a:$b:$c" >> conf/a.txt
    done
    
    while read list
    do
        name=`echo $list |awk -F: '{print $1}'`
        version=`echo $list |awk -F: '{print $2}'`
        intr=`echo $list |awk -F: '{print $3}'`
        awk 'BEGIN{printf "%-20s%-20s%-20s\n","'"$name"'","'"$version"'","'"$intr"'";}' >> conf/list_${language}.txt
        echo " " >> conf/list_${language}.txt
    done < conf/a.txt
    echo "total : ${z}" >> conf/list_${language}.txt
    
    rm -rf conf/a.txt
}

#对于合集中脚本的操作，安装，卸载，离线包，信息查询，编辑，依赖查询
server() {
    test_version
    test_root
    source /etc/profile
    source ~/.bashrc
    
    if [[ -f script/${2}.sh ]];then
        source script/${2}.sh
        if [[ "$1" == "install" ]];then
            print_massage "正在安装${2}" "Installing ${2}" 6
            print_massage "若中途报错，请按照提示操作，解决后再次安装即可。" "If you report an error in the middle, please follow the prompts, and then install it again."
            print_massage "ssc脚本合集只进行部署，并不修改防火墙等操作。" "The ssc script collection is only deployed, and does not modify the firewall and other operations."
            process_time
            test_init
            script_install ${2}
            print_massage "请'source /etc/profile;source ~/.bashrc' 来加载环境变量" "Please 'source /etc/profile;source ~/.bashrc' to load environment variables"
		elif [[ "$1" == "remove" ]];then
			script_remove ${2}
        elif [[ "$1" == "get" ]];then
			yum_get ${2}
			rely_get
            script_get
			echo
			print_massage "脚本：${2} 依赖包下载完成！" "Script: ${2} Dependency package download is complete!"
        elif [[ "$1" == "rely" ]];then
            print_massage "yum依赖：$server_yum" "Yum dependency: $server_yum"
            print_massage "内部依赖：$server_rely" "Internal dependencies: $server_rely"
        elif [[ "$1" == "info" ]];then
            script_info
            print_massage "警告：当前一切配置默认，若有其他需求，请 './ssc.sh edit 服务' 来修改脚本" "Warning: All current configuration defaults, if there are other requirements, please './ssc.sh edit server' to modify the script"
        elif [[ "$1" == "edit" ]];then
			which $editor &> /dev/null || print_error "编辑器${editor}不存在" "Editor ${editor} does not exist"
            $editor script/${2}.sh
        else
            [[ "$language" == "cn" ]] && help_cn || help_en
        fi
    else
        print_massage "没有这个脚本" "Without this service"
        bash ssc.sh list ${2}
    fi
}



#########main主体#########

for i in `ls lib/*` #将函数文件加载到当前
do
    source $i
done

if [[ $# -eq 0 ]];then
    [[ "$language" == "cn" ]] && help_cn || help_en
elif [[ $# -eq 1 ]];then
    if [[ "$1" == "list" ]];then
        [[ -f conf/list_${language}.txt ]] || list_generate #生成表
        cat conf/list_${language}.txt
    elif [[ "$1" == "update" ]];then
        update_ssc
	elif [[ "$1" == "installed" ]];then
		cat conf/installed.txt
	elif [[ "$1" == "init" ]];then
		rm -rf conf/list_*
		rm -rf conf/yum.log
    else
        [[ "$language" == "cn" ]] && help_cn || help_en
    fi
elif [[ $# -eq 2 ]];then
    if [[ "$1" == "list" ]];then
        [[ -f conf/list_${language}.txt ]] || print_error "请先./ssc.sh list 来生成表" "Please first ./ssc.sh list to generate the table"
        print_massage "$2相关脚本：" "$2 Related script："
        grep "^$2" conf/list_${language}.txt
    else
        server $1 $2
    fi
else
    [[ "$language" == "cn" ]] && help_cn || help_en
fi
