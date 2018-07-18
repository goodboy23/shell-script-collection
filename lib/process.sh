#字符串处理系列 process



#从位置变量中找出是数字的部分
process_number() {
    local a=() b=0 c d i

    for i in `echo $@`
    do
        c=`echo ${i%%.*}`
        d=`echo ${i#*.}`
    
        if [[ $d == $c ]];then
			[[ $c -gt 0 ]] &> /dev/null && a[$b]=$i && let b++ && continue
        else
            [[ $c -gt 0 ]] &> /dev/null && [[ $d -gt 0 ]] &> /dev/null && a[$b]=$i && let b++
        fi
    done
	
    echo "${a[*]}"
}

#从位置变量中找出整数部分
process_integer() {
    local a=() i

    for i in `echo $@`
    do
        [[ $i -gt 0 ]] &> /dev/null && a[$b]=$i
    done

    echo "${a[*]}"
}

#从位置变量中挑出最小值
process_small(){
    echo "$@" | tr " " "\n" | sort -V | head -n 1
}

#从位置变量中挑出最大值
process_big() {
    echo "$@" | tr " " "\n" | sort -rV | head -n 1
}

#把$1汉字转成encode格式
process_encode() {
    echo $1 | tr -d "\n" | xxd -i | sed -e "s/ 0x/%/g" | tr -d " ,\n"
}

#测试输入的是否为ip，$1填写ip
process_ip() {
    local status=$(echo $1|awk -F. '$1<=255&&$2<=255&&$3<=255&&$4<=255{print "yes"}')
    if echo $1|grep -E "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$">/dev/null;
then
	if [ status == "yes" ]; then
		return 0
	else
		return 1
	fi
else
	return 1
fi
}

#将位置变量中的汉语变成英语，不支持标点符号
process_en_cn() {
    local a="" i
	
    for i in `echo $@`
    do
        [ "$i" == "$1" ] && a=$1  &&continue
        a="$a+$i" 
    done
	
    curl -s  http://dict.baidu.com/s?wd=${a} | egrep -o "<a href=[^>]*>" | sed -n '5p' | awk  -F'=' '{print $3}' | awk -F'"' '{print $1}'
}

#转换大小写，$1为字符串，$2为1则大转小，为2则小转大，默认1
process_capital() {
    local a=1
    [ ! $a ] && a=1 || c=$2
	
    if [ $a -eq 1 ];then 
        echo $1 | tr "[A-Z]" "[a-z]"
    elif [ $a -eq 2 ];then
        echo $1 | tr "[a-z]" "[A-Z]"
    else
        return 1
    fi
}

#返回一个随机端口号
process_port() {
    shuf -i 9000-19999 -n 1
}

#随机密码，位置变量1可指定密码长度，默认6位
process_passwd(){
    local a=0 b="" c=6
    [ ! $1 ] && c=6 || c=$1
    
    for i in {a..z}; do arr[a]=${i}; a=`expr ${a} + 1`; done
    for i in {A..Z}; do arr[a]=${i}; a=`expr ${a} + 1`; done
    for i in {0..9}; do arr[a]=${i}; a=`expr ${a} + 1`; done
    for i in `seq 1 $c`; do b="$b${arr[$RANDOM%$a]}"; done
    echo ${b}
}

#一排横线，$1可指定长度，默认70
process_line() {
    local a=70
    [ ! $1 ] || a=$1
    
    printf "%-${a}s\n" "-" | sed 's/\s/-/g'
}

#倒计时，3秒
process_time() {
    local i
    for i in {3..1}
    do
        echo $i
        sleep 1
    done
}

#等待，打任意字结束，ctl+c将退出脚本
process_char(){
    SAVEDSTTY=`stty -g`
    stty -echo
    stty cbreak
    dd if=/dev/tty bs=1 count=1 2> /dev/null
    stty -raw
    stty echo
    stty $SAVEDSTTY
}

#$1为字符，会将字符中的-变成_
process_bian() {
    local a="" i b
	
    for i in `seq 1 ${#1}`
    do
        b=`echo $1 | cut -c $i`
        [ "$b" == "-" ] && a=`echo ${a}_` || a=`echo ${a}${b}`
    done
	
    echo $a
}

#集群使用，根据本地ip算出id号，统一cluster_ip，返回他在数组第几号
process_id() {
 	local num=`echo ${#cluster_ip[*]}` id a=1 i e
    	let num--

	for i in `ip addr | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | egrep -v "^172\.1[6-9]\.|^172\.2[0-9]\.|^172\.3[0-2]\.|^10\.|^127\.|^255\.|^0\."`
	do
		[ $a -eq 0 ] && break
		for e in `seq 0 $num`
		do
            		echo ${cluster_ip[$e]} | grep $i &> /dev/null
        		if [ $? -eq 0 ];then
               			id=$e
				a=0
                		break
        		fi
        	done
    	done
	
	let id++
	echo $id
}

#集群使用，根据本地ip算出当前绑定ip，统一cluster_ip，返回绑定ip
process_ip() {
 	local num=`echo ${#cluster_ip[*]}` ip a=1 i e
    	let num--

	for i in `ip addr | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | egrep -v "^172\.1[6-9]\.|^172\.2[0-9]\.|^172\.3[0-2]\.|^10\.|^127\.|^255\.|^0\."`
	do
		[ $a -eq 0 ] && break
		for e in `seq 0 $num`
		do
            		echo ${cluster_ip[$e]} | grep $i &> /dev/null
        		if [ $? -eq 0 ];then
               			ip=$i
				a=0
                		break
        		fi
        	done
    	done
	echo $ip
}
