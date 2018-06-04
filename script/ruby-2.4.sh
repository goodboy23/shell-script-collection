#!/usr/bin/env bash



script_get() {
    print_massage "不用下载" "Do not download"
}

script_install() {
    rvm use 2.4.1 --default
    if [[ -f /usr/local/bin/batch ]];then
        print_massage "检测到当前系统已安装" "Detected that the current system is installed"
        exit
    fi

    which rvm
    if [[ $? -ne 0 ]];then
        gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
        \curl -sSL https://get.rvm.io | bash -s stable
    
        [ -f /etc/profile.d/rvm.sh ] || print_error "rvm下载失败，请重新安装ruby" "Rvm download failed, please re-install ruby"
    
        #设置环境变量
        sed -i '/^source RVM_HOME=/d' ~/.bashrc
        sed -i '/^source $RVM_HOME/d' ~/.bashrc
        
        echo 'export RVM_HOME=/etc/profile.d/rvm.sh' >> ~/.bashrc
        echo 'source $RVM_HOME' >> ~/.bashrc
        
        source ~/.bashrc
        echo "ruby_url=https://cache.ruby-china.org/pub/ruby" > ~/.rvm/user/db

    fi
    
    #安装
    rvm install 2.4.1
    rvm use 2.4.1 --default
	
	#测试
	rvm use 2.4.1 --default
	[ $? -eq 0 ] || print_error "ruby安装失败，请检查脚本" "Ruby installation failed, please check the script"
    
    
	print_massage "ruby-2.4安装完成" "ruby-2.4 installation is complete"
	print_massage "使用：rvm list known " "Use：rvm list known"
	print_massage "使用说明：使用rvm来安装ruby" "Instructions for use：Use rvm to install ruby"
}

script_remove() {
	print_massage "当前不支持卸载" "Does not currently support uninstallation"
}

script_info() {
    print_massage "名字：ruby-2.4" "Name：ruby-2.4"
    print_massage "版本：2.4.1" "Version：2.4.1"
    print_massage "介绍：Ruby，一种简单快捷的面向对象脚本语言" "Introduction: Ruby，一种简单快捷的面向对象脚本语言"
	print_massage "作者：速度与激情小组---Linux部" "Author：Speed and Passion Group --- Linux Department"
}
