#!/usr/bin/env bash



script_get() {
    print_massage "不用下载" "Do not download"
}

script_install() {
    which rvm
    if [[ $? -eq 0 ]];then
        print_massage "1.检测到当前系统已安装" "1.Detected that the current system is installed"
        exit
    fi

    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    \curl -sSL https://get.rvm.io | bash -s stable
    
    [ -f /etc/profile.d/rvm.sh ] || print_error "2.rvm下载失败，请检查脚本" "2.rvm download failed, please check the script"
    
    #设置环境变量
    sed -i '/^source RVM_HOME=/d' /etc/profile
    sed -i '/^source $RVM_HOME/d' /etc/profile
        
    echo 'export RVM_HOME=/etc/profile.d/rvm.sh' >> /etc/profile
    echo 'source $RVM_HOME' >> /etc/profile
        
    source /etc/profile
    echo "ruby_url=https://cache.ruby-china.org/pub/ruby" > ~/.rvm/user/db

    fi
    
    #测试
    which rvm
    [ $? -eq 0 ] || print_error "3.rmv环境变量设置失败，请检查脚本" "3. The rmv environment variable setting failed, please check the script"

	print_massage "rvm安装完成" "rvm installation is complete"
    print_massage "安装目录： /usr/local/rvm" "Installation directory: /usr/local/rvm"
	print_massage "使用：rvm list known " "Use：rvm list known"
}

script_remove() {
    rm -rf /etc/profile.d/rvm.sh
    rm -rf /usr/local/rvm
    
    sed -i '/^source RVM_HOME=/d' /etc/profile
    sed -i '/^source $RVM_HOME/d' /etc/profile
    source /etc/profile
    
    which rvm
    [ $? -eq 0 ] &&  print_error "1.rvm卸载失败" "1.Rvm uninstall failed" || print_massage "rvm卸载成功" "Rvm uninstallation succeeded"
}

script_info() {
    print_massage "名字：ruby-2.4" "Name：ruby-2.4"
    print_massage "版本：2.4.1" "Version：2.4.1"
    print_massage "介绍：Ruby，一种简单快捷的面向对象脚本语言" "Introduction: Ruby，一种简单快捷的面向对象脚本语言"
    print_massage "作者：日行一善" "do one good deed a day"
}
