#!/bin/bash
# 作者：日行一善 <qq：1969679546> <email：1969679546@qq.com>
# 官网：www.52wiki.cn
#
# 日期：2018/4/12
# 介绍：batch.sh 轻便简洁的跳板机批量操作脚本，适合百台以下规模
#
# 注意：基于ssh免密登陆和/etc/hosts文件。
# 功能：1支持分组，2支持禁止使用命令，防止误删除
#
# 适用：centos6+
# 语言：英文



#[使用设置]
#分组，这里填写组的变量名
zu=(app service)

#以下是组变量和组中的机器，组中填写主机名或者ip
app=(app1 app2 app3)

service=(service1 service1)

#默认从第几行开始读取/etc/hosts
hang=3




#检查参数
if [ $# -ne 2 ];then
	echo './batch.sh -a "ls" Operate all'
	echo './batch,sh service "ls" Operate a single group'
    echo
	echo "Currently supported groups： ${zu[*]}"
	exit 1
fi


#不允许使用的命令
cuo=(reboot shutdown xixi) #xixi用来测试

for o in `echo ${cuo[*]}` 
do
	echo "$2" | grep -w "$o"
	if [ $? -eq 0 ];then
		echo "Not allowed to use $o"
		exit
	fi
done


#判断
r=0 #初始，如果都没匹配到则错误
t=`echo ${#zu[*]}` #总数量

if [ "$1" == "-a" ];then
	for i in `tail -n +${hang} /etc/hosts|awk '{print $2}'`
	do
		echo "####################server$i：####################"
		ssh $i $2
	done
else
	for p in `echo ${zu[*]}`
	do
		echo "$1" | grep -w "$p" &> /dev/null
		if [ $? -eq 0 ];then
			for u in $(eval echo \${$p[*]})
			do
				echo "####################server$u：####################"
				ssh $u $2
			done
			exit #完成后退出，不用继续循环
		else
			let r++ #失败+1，全部失败报错
		fi
	done
	[ $r -eq $t ] && echo "Incorrect group name"
fi
