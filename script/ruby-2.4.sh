#!/usr/bin/env bash



#[使用设置]
install_dir=/usr/local

ruby_dir=ruby



script_get() {
    test_package "http://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/ruby-2.4.4.tar.gz" "d50e00ccc1c9cf450f837b92d3ed3e88"
}

script_install() {
    ruby -v | grep 2.4
    if [[ $? -eq 0 ]];then
        print_massage "检测到已安装" "Detected installed"
        exit
    else
        ruby -v
        if [[ $? -eq 0 ]];then
            print_error "当前已有其它版本ruby，请手动卸载" "There are other versions of ruby currently, please uninstall manually"
        fi
    fi

    test_dir $ruby_dir
    test_install gcc make openssl openssl-devel zlib zlib-devel
    script_get
    rm -rf ruby-2.4.4/
    tar -xvf package/ruby-2.4.4.tar.gz
    cd ruby-2.4.4/
    ./configure --prefix=${install_dir}/${ruby_dir}
    make && make install || print_error "编译失败，请检查脚本" "Compile failed, please check the script"

   #环境变量
    sed -i '/^RUBY_HOME=/d' /etc/profile
    sed -i '/^PATH=$RUBY_HOME/d' /etc/profile

    echo "RUBY_HOME=${install_dir}/${ruby_dir}/bin"  >> /etc/profile
    echo 'PATH=$RUBY_HOME:$PATH' >> /etc/profile

    source /etc/profile

    cd ext/zlib
    ruby extconf.rb 
    [[ -f Makefile ]] || print_error "生成Makefile失败，请联系作者" "Failed to generate Makefile, please contact author"
    sed -i 's,zlib.o: $(top_srcdir)/include/ruby.h,zlib.o: ../../include/ruby.h,g' Makefile
    make && make install || print_error "zlib构建失败，请联系作者" "Zlib build failed, please contact the author"
    cd ..
    
    cd openssl
    ruby extconf.rb
    [[ -f Makefile ]] || print_error "生成Makefile失败，请联系作者" "Failed to generate Makefile, please contact author"
    sed -i 's,$(top_srcdir),../..,g' Makefile
    make && make install || print_error "openssl构建失败，请联系作者" "openssl build failed, please contact the author"

    cd ..
    cd ..
    rm -rf ruby-2.4.4/

	#测试
	ruby -v | grep 2.4
	[ $? -eq 0 ] || print_error "ruby安装失败，请联系作者" "Ruby installation failed, please contact the author"
    
    
	print_massage "ruby-2.4安装完成" "ruby-2.4 installation is complete"
	print_massage "使用：ruby" "Use：ruby"
}

script_remove() {
    rm -rf /usr/local/ruby
    sed -i '/^RUBY_HOME=/d' /etc/profile
    sed -i '/^PATH=$RUBY_HOME/d' /etc/profile
    source /etc/profile
    
    rvm -v | grep 2.4.1
    [ $? -eq 0 ] && print_error "ruby-2.4卸载失败，请联系作者" "1.ruby-2.4 uninstall failed, please contact the author" || print_massage "rvm-2.4卸载成功" "rvm-2.4 uninstall successfully"
}

script_info() {
    print_massage "名字：ruby-2.4" "Name：ruby-2.4"
    print_massage "版本：2.4.4" "Version：2.4.4"
    print_massage "介绍：Ruby，一种简单快捷的面向对象脚本语言" "Introduction: Ruby，一种简单快捷的面向对象脚本语言"
    print_massage "作者：日行一善" "do one good deed a day"
}
