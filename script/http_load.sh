#!/usr/bin/env bash



#安装目录
install_dir=/usr/local/bin

log_dir=no

#服务目录
server_dir=no

server_yum="gcc cmake"



script_get() {
    test_package "http://www.acme.com/software/http_load/http_load-12mar2006.tar.gz" "d1a6c2261f8828a3f319e86ff0517219"
}

script_install() {
    which http_load
    if [[ $? -eq 0 ]];then
        print_massage "检测到已安装" "Detected installed"
        exit
    fi
	
	#依赖
	test_detection ${1}
    
    script_get
	rm -rf http_load-12mar2006
	rm -rf /usr/local/man
	mkdir /usr/local/man
	
	rm -rf http_load-12mar2006
	tar -xf  package/http_load-12mar2006.tar.gz
	cd http_load-12mar2006
	make && make install || print_error "make操作失败" "make operation failed"
	
	cd ${ssc_dir}
	rm -rf http_load-12mar2006

    #对结果进行测试
    which http_load
    [[ $? -eq 0 ]] || print_error "安装失败" "2.Installation failed"
    
    print_install_ok $1
	print_log "使用：http_load" "Use：http_load"
	print_log "########################" "########################"
}

script_remove() {
    rm -f /usr/local/bin/http_load
	rm -rf /usr/local/man

    print_remove_ok $1
}

script_info() {
	print_massage "名字：http_load" "Name：http_load"
	print_massage "版本：12mar2006" "Version：12mar2006"
	print_massage "介绍：并行复用的web检测工具" "Introduce：Parallel multiplexed web detection tool"
    print_massage "作者：日行一善" "do one good deed a day"
}