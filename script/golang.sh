#!/usr/bin/env bash



#安装目录
#install_dir=

log_dir=no

#服务目录
server_dir=go

server_yum="curl"



script_get() {
	test_package "https://studygolang.com/dl/golang/go1.10.1.linux-amd64.tar.gz" "ad5d557f69f8cb6a6a7773eb374a24c9"
}

script_install() {
    which go
    if [[ $? -eq 0 ]];then
        print_massage "检测到已安装" "Detected installed"
        exit
    fi
	
	#依赖
	test_detection ${1}
    
	script_get
	rm -rf go
	tar -xf package/go1.10.1.linux-amd64.tar.gz
	mv go ${install_dir}/${server_dir}
	
	#环境变量
    sed -i '/^export GO_HOME=/d' /etc/profile
    sed -i '/^export PATH=${GO_HOME}/d' /etc/profile
    
    echo "export GO_HOME=${install_dir}/${server_dir}" >> /etc/profile
    echo 'export PATH=${GO_HOME}/bin:${PATH}' >> /etc/profile
    source /etc/profile

    #对结果进行测试
    which go
    [ $? -eq 0 ] || print_error "安装失败" "2.Installation failed"
	
	cd ${ssc_dir}
	local ceshi=`go run material/ifbook.go`
	[[ "$ceshi" == "Hello" ]] || print_error "功能测试失败" "Functional test failed"
    
    print_install_ok $1
	print_log "使用：go" "Use：go"
	print_log "########################" "########################"
}

script_remove() {
	rm -rf ${install_dir}/${server_dir}
	sed -i '/^export GO_HOME=/d' /etc/profile
    sed -i '/^export PATH=${GO_HOME}/d' /etc/profile
	
    print_remove_ok $1
}

script_info() {
	print_massage "名字：golang" "Name：golang"
	print_massage "版本：1.10.1" "Version：1.10.1"
	print_massage "介绍：Go语言是谷歌2009发布的第二款开源编程语言。" "Introduce：The Go language is the second open source programming language released by Google 2009."
    print_massage "作者：日行一善" "do one good deed a day"
}