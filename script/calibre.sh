#!/usr/bin/env bash



script_get() {
	print_massage "不用下载" "Do not download"
}

script_install() {
    ebook-convert --version
    if [[ $? -eq 0 ]];then
        print_massage "检测到当前系统已安装" "Detected that the current system is installed"
        exit
    fi

    #安装依赖
    test_www
	test_rely chinese-font
	test_install mesa-libGL qt5-qtquickcontrols qt5-qtdeclarative-devel libGL.so.1

	#安装版本
	wget -nv -O- https://download.calibre-ebook.com/linux-installer.py |python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"
	
	#测试
	ebook-convert --version
	[[ $? -eq 0 ]] || print_error "安装失败，请检查脚本" "Installation failed, please check the script"
    
    #效验是否工作正常
	ebook-convert script/batch.sh batch.pdf
	[[ -f batch.pdf ]] || print_error "生成pdf失败，请检查脚本" "Failed to generate pdf, please check the script"
    rm -rf batch.pdf
    
    #完成
    print_massage "calibre安装完成" "The calibre is installed"
    print_massage "ebook-convert a.txt a.pdf 方式生成pdf文件" "ebook-convert a.txt a.pdf method to generate pdf file"
}

script_remove() {
	print_massage "calibre当前无法卸载！" "calibre cannot be uninstalled at this time！"
}

script_info() {
    print_massage "名字：calibre" "Name：calibre"
    print_massage "版本：3.18.0" "Version：3.18.0"
    print_massage "介绍：Calibre是基于python的电子书制作软件" "Introduction: Calibre is a python-based e-book making software"
    print_massage "作者：速度与激情小组---Linux部" "Author：Speed and Passion Group --- Linux Department"
}
