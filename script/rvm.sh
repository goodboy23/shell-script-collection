#!/usr/bin/env bash



script_get() {
    print_massage "不用下载" "Do not download"
}

script_install() {
    which rvm
    if [[ $? -eq 0 ]];then
        print_massage "检测到当前系统已安装" "Detected that the current system is installed"
        exit
    fi

    test_remove ruby
    
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    \curl -sSL https://get.rvm.io | bash -s stable
    
    [ -f /etc/profile.d/rvm.sh ] || print_error "rvm下载失败，请联系作者" "Rvm download failed, please contact the author"
    
    #设置环境变量
    sed -i '/^source RVM_HOME=/d' /etc/profile
    sed -i '/^source $RVM_HOME/d' /etc/profile
        
    echo 'export RVM_HOME=/etc/profile.d/rvm.sh' >> /etc/profile
    echo 'source $RVM_HOME' >> /etc/profile
        
    source /etc/profile
    echo "ruby_url=https://cache.ruby-china.org/pub/ruby" > ~/.rvm/user/db
    
    #测试
    which rvm
    [ $? -eq 0 ] || print_error "rmv环境变量设置失败，请联系作者" "3. The rmv environment variable setting failed,  please contact the author"

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
    [ $? -eq 0 ] &&  print_error "rvm卸载失败，请联系作者" "Rvm uninstall failed， please contact the author" || print_massage "rvm卸载成功" "Rvm uninstallation succeeded"
}

script_info() {
    print_massage "名字：rvm" "Name：rvm"
    print_massage "版本：0" "Version：0"
    print_massage "介绍：rvm是ruby管理器" "Introduction: Rvm is a ruby manager"
    print_massage "作者：日行一善" "do one good deed a day"
}
