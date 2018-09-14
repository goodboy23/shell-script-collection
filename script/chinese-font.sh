#!/usr/bin/env bash



script_get() {
    test_package https://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/simhei.ttf 5b4ceb24c33f4fbfecce7bd024007876
    test_package https://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/simsun.ttc bc9c5051b849545eaecb9caeed711d79
}

script_install() {
    fc-list  | grep '/usr/share/fonts/chinese/simsun.ttc'
    if [[ $? -eq 0 ]];then
        print_massage "检测到当前系统已安装" "Detected that the current system is installed"
        exit
    fi
    
	test_install fontconfig
	[[ -d /usr/share/fonts/chinese ]] || mkdir -p /usr/share/fonts/chinese
	
	#放字体到文件夹
	script_get
	rm -rf /usr/share/fonts/chinese/simhei.ttf /usr/share/fonts/chinese/simsun.ttc
	cp package/simhei.ttf /usr/share/fonts/chinese/
	cp package/simsun.ttc /usr/share/fonts/chinese/
	chmod -R 755 /usr/share/fonts/chinese
	
	#将字体的文件夹位置写到配置文件
    test_install ttmkfdir
    [[ -f /usr/share/X11/fonts/encodings/encodings.dir ]] || ttmkfdir -e /usr/share/X11/fonts/encodings/encodings.dir
    
    hang=`grep -n '<dir>/usr/share/fonts</dir>' /etc/fonts/fonts.conf  | awk -F':' '{print $1}'`
	sed -i "${hang}a <dir>/usr/shared/fonts/chinese</dir>" /etc/fonts/fonts.conf
    
	fc-cache
	fc-list  | grep '/usr/share/fonts/chinese/simsun.ttc'
    [[ $? -eq 0 ]] || print_error "生成失败" "The build failed"

    #完成
    print_install_ok $1
	print_log "########################" "########################"
}

scrip_remove() {
	print_massage "chinese-font当前无法卸载！" "Chinese-font cannot be uninstalled at this time！"
}

script_info() {
    print_massage "名字：chinese-font" "Name：chinese-font"
    print_massage "版本：0" "Version：0"
    print_massage "介绍：安装中文字体" "Introduce：Install Chinese font"
    print_massage "作者：日行一善" "do one good deed a day"
}