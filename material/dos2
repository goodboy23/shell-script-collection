#!/usr/bin/env bash
# 作者：日行一善 <qq：1969679546> <email：1969679546@qq.com>
# 官网：www.52wiki.cn
#
# 日期：2018/6/15
# 介绍：dos2.sh 将windows写的文件转换为linux格式
#
# 注意：无
# 功能：将单个或者整个文件夹中的文件转换
#
# 适用：centos6+
# 语言：中文



doss() {
    yum -y install dos2unix
    rpm -q dos2unix
    if [ $? -ne 0 ];then
        echo "please yum -y install dos2unix"
        exit
    fi
}

clea() {
    for i in `ls`
    do
        if [ -d $i ];then
            cd $i
            clea
            cd ..
        else
            dos2unix $i
        fi
    done
}


#主体
if [[ ! $1 ]];then
    echo "将windows写的文件转换成linux格式！"
    echo
    echo "bash xx.sh /root/nginx or /etc/passwd.txt"
    exit
else
    doss
    if [[ -e $1 ]];then
        if [[ -d $1 ]];then
            cd $1
            clea
        else
            dos2unix $1
        fi
    else
        echo "$1 not found"
    fi        
fi
