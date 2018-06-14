#!/usr/bin/env bash



script_get() {
    print_massage "不用下载" "Do not download"
}

script_install() {
    if [[ -f /usr/local/bin/tetris ]];then
        print_massage "1.检测到当前系统已安装" "1.Detected that the current system is installed"
        exit
    fi
    
    test_bin tetris

	print_massage "tetris安装完成" "The tetris is installed"
	print_massage "安装目录：/usr/local/bin/tetris" "Install Dir：/usr/local/bin/tetris"
	print_massage "使用：tetris" "Use：tetris"
}

script_remove() {
	rm -rf /usr/local/bin/tetris
    
    [ -f /usr/local/bin/tetris ] && print_error "1.tetris未成功删除，请检查脚本" "1.tetris unsuccessfully deleted, please check the script" || print_massage "tetris卸载完成！" "tetris Uninstall completed！"
}

script_info() {
	print_massage "名字：tetris" "Name：tetris"
	print_massage "版本：1.0" "Version：1.0"
	print_massage "介绍：俄罗斯方块小游戏脚本" "Introduce：Tetris Game Script"
	print_massage "作者：未知" "Author：未知"
}