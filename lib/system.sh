#system组 系统，返回各种系统信息



#系统和版本
system_version_two() {
    [ -f /etc/redhat-release ] && awk '{print ($1,$3~/^[0-9]/?$3:$4)}' /etc/redhat-release && return
    [ -f /etc/os-release ] && awk -F'[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release && return
    [ -f /etc/lsb-release ] && awk -F'[="]+' '/DESCRIPTION/{print $2}' /etc/lsb-release && return
}

#系统版本号
system_vrsion(){
    if [[ -s /etc/redhat-release ]];then
        grep -oE  "[0-9.]+" /etc/redhat-release
    else
        grep -oE  "[0-9.]+" /etc/issue
    fi
}

#系统是64位则返回0
systemctl_64bit(){
    if [ `getconf WORD_BIT` = '32' ] && [ `getconf LONG_BIT` = '64' ] ; then
        return 0
    else
        return 1
    fi
}

#返回一个外网ipv4
system_ipv4() {
    wget -qO- -t1 -T2 ipv4.icanhazip.com
}

#如果本地ip为私有地址，将返回公有地址
system_ipv4_two() {
    local IP=$( ip addr | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | egrep -v "^192\.168|^172\.1[6-9]\.|^172\.2[0-9]\.|^172\.3[0-2]\.|^10\.|^127\.|^255\.|^0\." | head -n 1 )
    [ -z ${IP} ] && IP=$( wget -qO- -t1 -T2 ipv4.icanhazip.com )
    [ -z ${IP} ] && IP=$( wget -qO- -t1 -T2 ipinfo.io/ip )
    [ ! -z ${IP} ] && echo ${IP} || echo
}

#一个外网ipv6地址
system_ipv6(){
    wget -qO- -t1 -T2 ipv6.icanhazip.com
}

#$1为ip，根据输入ip返回所在地
system_location() {
    curl -s "http://ip138.com/ips138.asp?ip=${1}&action=2"| iconv -f gb2312 -t utf-8|grep '<ul class="ul1"><li>' |awk -F '<' '{print $4}' | awk -F'：' '{print $2}'
}

#测试硬盘读写速度
system_iospeed() {
    (LANG=C dd if=/dev/zero of=test_xx bs=64k count=16k conv=fdatasync && rm -f test_xx ) 2>&1 | awk -F, '{io=$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*$//'
}