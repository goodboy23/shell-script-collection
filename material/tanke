#!/bin/bash
#author goodboy23（qq1969679546)
#brief 疯狂小坦克
#date 2017.9.1
#y为行，x为列
#linux中2列的像素等于1行的像素



######                      变量部分                     ######

#基础变量
kuang_se=42 #边框颜色，42为绿色，可参照最下方附件'one'来更换颜色！
index_xy=(6 10 14 18) #首页选项的坐标
index_the=0   #首页选择下标，往下则+1
game_xy=(16 33 50 20)  #几个地图和退出选项的坐标
game_the=0    #地图选择下标，往右+1

#pid
pid_name=(logo shell_xy time_jishi hp) #后台进程名字

#地图坐标，x代表的第几列，y代表第几行
map_one_x=(9 10 10 10 11 11 11 11 11 12 12 12 12 12 12 12 13 13 13 13 13 13 13 13 13 14 14 14 14 14 14 14 14 14 14 14 15 15 15 15 15 15 15 15 15 15 15 15 15)
map_one_y=(37 36 37 38 35 36 37 38 39 34 35 36 37 38 39 40 33 34 35 36 37 38 39 40 41 32 33 34 35 36 37 38 39 40 41 42 31 32 33 34 35 36 37 38 39 40 41 42 43)
map_two_x=(7 7 7 7 7 7 9 9 9 9 9 9 15 15 15 15 15 15 19 19 19 19 19 19)
map_two_y=(20 21 22 23 24 25 43 44 45 46 47 48 31 32 33 34 35 36 52 53 54 55 56 57)
map_three_x=()
map_three_y=()
beijing=()

#碰撞测试的数组
map_x=()    #可以打烂的墙，但每个地图都不一样，这里把其他地图加载进来
map_y=()
qiang_x=()    #墙的数组
qiang_y=()

gam_x=()  #机器人的坐标
gam_y=()


#玩家的成就参数
player_hp=3
gameover=0  #失败次数
success=0   #通关次数
shadi=0     #杀敌总数

shell=0     #0代表基本炮弹

#玩家参数
player_hp=3
zanting=0

#机器人参数
gam_number=40
game_kill=0 #机器人死亡数



######                      保底                      ######
#若玩家强制退出则将终端恢复
#判断边框大小

p_exit() {    #退出恢复
echo -e "\033[?25h"    #显示光标
stty echo    #显示输出内容
pid_clear   #杀死后台残留进程
clear
exit
}

pid_clear() {   #双循环清除Pid
local i o
for i in `echo ${pid_name[@]}`
do
    for o in `jobs -l | awk "/$i/{print $2}"`
    do
        kill $o &> /dev/null
    done
done
kill `echo $$`  #脚本本身pid
}

trap "p_exit;" INT TERM    #当强制退出则执行p_exit函数内容

echo -ne "\033[?25l"    #隐藏光标
stty -echo #输入不显示

yuyan() {   #首先检查语言环境，是否支持中文
if [ `echo $LANG` == "en_US.UTF-8" -o `echo $LANG` == "zh_CN.UTF-8" ];then
    kuang_test
else
    echo "The current language is not Chinese！" #告诉他设置中文
    echo "Please use “LANG=en_US.UTF-8” to set up the language！"
    p_exit
fi
}

kuang_test() {   #若边框大小不符合，则提示更改边框大小
if [ `tput lines` -lt 25 ];then
    echo "当前长为`tput lines`，请扩大到25！"
    sleep 5
    p_exit
fi
if [ `tput cols` -lt 115 ];then
    echo "当前宽为`tput cols`，请扩大到！115"
    sleep 5
    p_exit
fi
}



######                      菜单                      ######
#先显示logo，再显示主菜单页面，然后让玩家操作选择选项

kuang() {   #绘制外边框
local x y

clear

for y in {1..75}
do
    echo -ne "\033["${kuang_se}"m\033[1;${y}H  \033[0m"
    echo -ne "\033["${kuang_se}"m\033[25;${y}H  \033[0m"
done

for x in {2..25}
do
    echo -e "\033["${kuang_se}"m\033[${x};1H  \033[0m"
    echo -e "\033["${kuang_se}"m\033[${x};75H  \033[0m"
done
index
}

kuang_clear() { #清除边框内容
local x y

for x in {2..24}
do
    for y in {2..74}
    do
        echo -e "\033["40"m\033[${x};${y}H  \033[0m"
    done
done
}

xinxi_clear() {   #清除右侧信息栏
local x y
for x in {1..25}
do
    for y in {75..115}
    do
        echo -e "\033["40"m\033[${x};${y}H  \033[0m"
    done
done
}

logo() {    #不判断直接显示，会跳过第二条显示，不知道为啥
local a i

for i in {1..100}
do
    a=`echo $[i%2]`
    if [ $a -eq 1 ];then
        echo -e "\033["31"m\033[3;60H 疯狂小坦克\033[0m"
        sleep 0.3
    else
        echo -e "\033["33"m\033[3;60H 疯狂小坦克\033[0m"
        sleep 0.3
    fi
done
}

index() {   #主页面文字
logo &
echo -e "\033["37"m\033[6;35H 开始游戏\033[0m"
echo -e "\033["37"m\033[10;35H 游戏教程\033[0m"
echo -e "\033["37"m\033[14;35H 交流反馈\033[0m"
echo -e "\033["37"m\033[18;35H 退出游戏\033[0m"
echo -e "\033["37"m\033[20;12H w上，s下，a左，d右，空格确认，p退出游戏，i暂停游戏。\033[0m"
index_yidong
}

index_yidong() { #设定一个值，不能超过选项的个数，让他在其中移动
echo -e "\033["41"m\033[${index_xy[$index_the]};34H  \033[0m"
while [ 1 ]
do
    read -s -n 1 index_option

    if [[ $index_option == "w" || $index_option == "W" ]];then
        index_shang
    elif [[ $index_option == "s" ||  $index_option == "S" ]];then
        index_xia
    elif [[ "[$index_option]" == "[]" ]];then
        kill  `jobs -l | awk '/logo/{print $2}'` #这块是单独杀掉进程
        index_ok
    elif [[ $index_option == "p" ]];then
        p_exit
	fi
done
}

index_shang() { #往上移动
if [ $index_the -gt 0 ];then
    echo -e "\033["40"m\033[${index_xy[$index_the]};34H  \033[0m"
    let index_the-=1
	echo -e "\033["41"m\033[${index_xy[$index_the]};34H  \033[0m"
fi
}

index_xia() { #往下移动
if [ $index_the -lt 3 ];then
    echo -e "\033["40"m\033[${index_xy[$index_the]};34H  \033[0m"
    let index_the+=1
	echo -e "\033["41"m\033[${index_xy[$index_the]};34H  \033[0m"
fi
}

index_ok() {
if [ $index_the -eq 0 ];then
    game_begin
elif [ $index_the -eq 1 ];then
    game_jiaocheng
elif [ $index_the -eq 2 ];then
    game_fankui
elif [ $index_the -eq 3 ];then
    p_exit
fi
}



######                      开始游戏                      ######
#因为退出键有点靠下，所以先判断变量game_y是否为3
#为3则再往左，则先将当前位置的红点清除，在左边的位置新建红点
#第三章地图可以编辑

game_begin() {    #显示地图
local i
kuang_clear
echo -e "\033["37"m\033[12;17H 前  哨\033[0m"
echo -e "\033["37"m\033[12;34H 边  境\033[0m"
echo -e "\033["37"m\033[12;51H 中转站\033[0m"
echo -e "\033["37"m\033[20;60H 返回菜单\033[0m"

for i in {1..1875} #长*宽所有格子都为6，不为6则是墙
do
    beijing[$i]=6
done
game_yidong
}

#地图选择部分
game_yidong() {
echo -e "\033["41"m\033[12;${game_xy[$game_the]}H  \033[0m" #红点
while [ 1 ] 
do
    read -s -n 1 game_option
    if [[ $game_option == "A" || $game_option == "a" ]]; then game_zuo
    elif [[ $game_option == "D" || $game_option == "d" ]]; then game_you
    elif [[ "[$game_option]" == "[]" ]]; then game_ok
    elif [[ $game_option == "p" || $game_option == "p" ]]; then p_exit
    fi
done
}

game_zuo() {
if [ $game_the -gt 0 ];then
    if [ $game_the -eq 3 ];then
        echo -e "\033["40"m\033[${game_xy[$game_the]};59H  \033[0m"
        let game_the-=1
        echo -e "\033["41"m\033[12;${game_xy[$game_the]}H  \033[0m"
    else
        echo -e "\033["40"m\033[12;${game_xy[$game_the]}H  \033[0m"
        let game_the-=1
        echo -e "\033["41"m\033[12;${game_xy[$game_the]}H  \033[0m"
    fi
fi
}

game_you() {
if [ $game_the -lt 3 ];then
    if [ $game_the -eq 2 ];then
        echo -e "\033["40"m\033[12;${game_xy[$game_the]}H  \033[0m"
        let game_the+=1
        echo -e "\033["41"m\033[${game_xy[$game_the]};59H  \033[0m" #新的地点
    else
        echo -e "\033["40"m\033[12;${game_xy[$game_the]}H  \033[0m"
        let game_the+=1
        echo -e "\033["41"m\033[12;${game_xy[$game_the]}H  \033[0m"
    fi
fi
}

game_ok() {
kuang_clear
if [ $game_the -eq 0 ];then
    map_one
elif [ $game_the -eq 1 ];then
    map_two
elif [ $game_the -eq 2 ];then
    map_three
elif [ $game_the -eq 3 ];then
    kuang_clear
    index
fi
}

map_one() { #第一张地图
local a b c i

a=`echo ${#map_one_x[*]}`
b=`echo $[a-1]`
for i in `seq 0 $b`   #查看数组中有多少值，来循环创建地图
do
    echo -e "\033["44"m\033[${map_one_x[$i]};${map_one_y[$i]}H  \033[0m"
    ((c= map_one_x[$i] * 25 + map_one_y[$i])) #用来标识唯一位置
	beijing[$c]=9 #为9则是墙
done
xinxi
player
}

map_two() { #地图分开显示
local a b c i

a=`echo ${#map_two_x[*]}`
b=`echo $[a-1]`
for i in `seq 0 $b`
do
    echo -e "\033["44"m\033[${map_two_x[$i]};${map_two_y[$i]}H  \033[0m"
    ((c= map_two_x[$i] * 25 + map_two_y[$i]))
	beijing[$c]=9
done
xinxi
player
}

map_three() {
if [ -f $PWD/goodboy.txt ];then
    map_jiazai
else
    echo -e "\033["37"m\033[6;78H 没有地图文件，按i绘制，按p返回\033[0m"
    map_yidong
fi
}

map_jiazai() {
local a b c d i o

a=`wc -l goodboy.txt | awk '{print $1}'`
b=0

for i in `seq 1 $a` #提取到数组里
do
    map_three_x[$b]=`sed -n "${i}p" goodboy.txt | awk -F',' '{print $1}'`
    map_three_y[$b]=`sed -n "${i}p" goodboy.txt | awk -F',' '{print $2}'`
    let b++
done

c=`echo ${#map_three_x[*]}`
d=`echo $[c-1]`

for o in `seq 0 $d`
do
    echo -e "\033["44"m\033[${map_three_x[$o]};${map_three_y[$o]}H  \033[0m"
    ((c= map_three_x[$o] * 25 + map_three_y[$o]))
	beijing[$c]=9
done
xinxi
player
}

map_yidong() {
while [ 1 ] 
do
    read -s -n 1 map_option
    if [[ $map_option == "i" || $map_option == "I" ]]; then
        map_vim
    elif [[ $map_option == "p" || $map_option == "p" ]]; then
        kuang_clear
        game_begin
    fi
done
}


#以下是绘制地图部分

qiu_clear() {
if [ $hua -eq 1 ];then
    echo -e "\033["40"m\033[${qiu_x};${qiu_y}H       \033[0m"
    xiao_x[$xiao]=$qiu_x
    xiao_y[$xiao]=$qiu_y
    let xiao++
fi
}

zengjia() {
    xian_x[$xian]=$qiu_x
    xian_y[$xian]=$qiu_y
    let xian++
}

vim_shang() { #向上移动先把原来坐标小点抹去，把x轴-1
    qiu_clear
    let qiu_x-=1
    echo -e "\033["44"m\033[${qiu_x};${qiu_y}H  \033[0m"
    zengjia
}

vim_xia() {
    qiu_clear
    let qiu_x+=1
    echo -e "\033["44"m\033[${qiu_x};${qiu_y}H  \033[0m"
    zengjia
}

vim_zuo() {
    qiu_clear
    let qiu_y-=2 #像素问题
    echo -e "\033["44"m\033[${qiu_x};${qiu_y}H  \033[0m"
    zengjia
}

vim_you() {
    qiu_clear
    let qiu_y+=2
    echo -e "\033["44"m\033[${qiu_x};${qiu_y}H  \033[0m"
    zengjia
}

zhengli(){
local i

for i in `seq 0 $xian`
do
    echo "${xian_x[$i]},${xian_y[$i]}" >> good.txt
done
sort good.txt | uniq > boy.txt #不重复的写进去

for i in `seq 0 $xiao` #再后面增加
do
    echo "${xiao_x[$i]},${xiao_y[$i]}" >> boy.txt
done
sort boy.txt | uniq -u > goodboy.txt #d地图
rm -rf good.txt boy.txt
}

map_vim() {
local hua xian xiao xian_x xian_y xiao_x xiao_y option qiu_x qiu_y

hua=0
xian=0
xiao=0
xian_x=()
xian_y=()
xiao_x=()
xiao_y=()
qiu_x=15
qiu_y=35


echo -e "\033["37"m\033[2;15H wasd移动,按空格切换绘画模式,p返回\033[0m"

echo -e "\033["44"m\033[${qiu_x};${qiu_y}H  \033[0m" #先显示一遍小点
zengjia
while [ 1 ] #支持大小写操作
do
    read -s -n 1 option
    if [[ $option == "w" || $option == "W" ]];then
        vim_shang
    elif [[ $option == "s" ||  $option == "S" ]];then
        vim_xia
    elif [[ $option == "a" ||  $option == "A" ]];then
        vim_zuo
    elif [[ $option == "d" ||  $option == "D" ]];then
        vim_you
    elif [[ "[$option]" == "[]" ]];then #按空格绘制
        if [ $hua -eq 1 ];then
            hua=0
        else
            hua=1
        fi
    elif [[ $option == "p" ||  $option == "P" ]];then
        zhengli
        kuang_clear
        game_begin
    fi
done
}


xinxi() { #右侧信息栏
echo -e "\033["32"m\033[2;78H 游戏时间：\033[0m"
time_jishi &    #计时
jieshao #地图介绍
hp &    #血量

echo -e "\033["32"m\033[11;78H 敌人数量：\033[0m"
echo -e "\033["32"m\033[12;78H 杀敌数：\033[0m"

echo -e "\033["32"m\033[14;78H 操作介绍：\033[0m"
echo -e "\033["37"m\033[15;78H W上，S下，A左，D右\033[0m"
echo -e "\033["37"m\033[16;78H I暂停游戏，P退出游戏\033[0m"

echo -e "\033["37"m\033[18;78H 消息：\033[0m"
}


abc=()
b=0 #记录对话的个数
xiaoxi() { #每一句话都会记录到数组中，再提取
    let b++
    abc[$b]=$1 #放进数组

    if [ $b -gt 4 ];then #大于4个则刷新
        d=`echo $[b-4]` #永远是最新5句对话
        e=0 #做基础值，每次刷新对话则变为0
        for i in `seq $d $b`
        do
            f=`echo $[e+19]` #循环显示，3为基础
	    let e++
            echo -e "\033["32"m\033[${f};78H${abc[$i]}\033[0m"
        done
    else
        c=`echo $[b+19]`
        echo -e "\033["32"m\033[${c};78H${a}\033[0m" #否则正常往下显示
    fi
    sleep 0.5
}


jieshao() { #单独写 免得太乱
echo -e "\033["32"m\033[5;78H 地图介绍：\033[0m"
if [ $game_the -eq 0 ];then
    echo -e "\033["37"m\033[6;78H 这里是M国防卫系统的最前沿\033[0m"
    echo -e "\033["37"m\033[7;78H 你如果想要前进，最好把他们都打趴下\033[0m"
elif [ $game_the -eq 1 ];then
    echo -e "\033["37"m\033[6;78H 前面就是M国的小镇了\033[0m"
    echo -e "\033["37"m\033[7;78H 通过这里，意味着对小镇的占领\033[0m"
elif [ $game_the -eq 2 ];then  #最后一个也别用else，防止出问题
    echo -e "\033["37"m\033[6;78H 这里存储着大量的物资\033[0m"
    echo -e "\033["37"m\033[7;78H 如果摧毁这里，战争将会结束\033[0m"
fi
}



######                      坦克                      ######
#先绘制出坦克的模型，移动的显示
#然后 子弹，血量是单独的运算
#最后是玩家控制和电脑的ai控制



tanke_suan() {  #根据中心点来绘制出坦克的4个点
tanke_y[4]=`echo $[tanke_y[0]+2]`
tanke_x[3]=`echo $[tanke_x[0]+1]`
tanke_y[2]=`echo $[tanke_y[0]-2]`
tanke_x[1]=`echo $[tanke_x[0]-1]`
}

tanke_yian() {  #根据位置变量来显示上下左右
tanke_suan  #做一次方块计算
echo -e "\033["$se"m\033[${tanke_x[$1]};${tanke_y[$1]}H  \033[0m"
echo -e "\033["$se"m\033[${tanke_x[$2]};${tanke_y[$2]}H  \033[0m"
echo -e "\033["$se"m\033[${tanke_x[$3]};${tanke_y[$3]}H  \033[0m"
tanke_player_x=(${tanke_x[$1]} ${tanke_x[$2]} ${tanke_x[$3]}) #用作碰撞检测和消除
tanke_player_y=(${tanke_y[$1]} ${tanke_y[$2]} ${tanke_y[$3]})
}

tanke_clear(){  #根据玩家的数组来消除坦克的显示
for cle in {0..2}
do
    echo -e "\033["40"m\033[${tanke_player_x[$cle]};${tanke_player_y[$cle]}H  \033[0m"
done
}

tanke_hua() {   #先画出坦克,1 2 4是数组的下标
if [ $tanke_the -eq 1 ];then
    tanke_clear
    tanke_yian 1 2 4
elif [ $tanke_the -eq 2 ];then
    tanke_clear
    tanke_yian 3 4 2
elif [ $tanke_the -eq 3 ];then
    tanke_clear
    tanke_yian 2 3 1
elif [ $tanke_the -eq 4 ];then
    tanke_clear
    tanke_yian 4 1 3
fi
}

tanke_shang() { #不是朝上的先转方向，下次再移动
if [ $tanke_the -eq 1 ];then
    tanke_clear
    for hua in {0..4}
    do
        tanke_x[$hua]=`echo $[tanke_x[$hua]-1]`
    done
    tanke_yian 1 2 4
    tanke_the=1
else
    tanke_the=1
    tanke_hua
fi
}

tanke_xia() {   #让数组整体后退一步，然后调用里面的块
if [ $tanke_the -eq 2 ];then
    tanke_clear
    for hua in {0..4}
    do
        tanke_x[$hua]=`echo $[tanke_x[$hua]+1]`
    done
    tanke_yian 3 4 2
    tanke_the=2
else
    tanke_the=2
    tanke_hua
fi
}

tanke_zuo() {
if [ $tanke_the -eq 3 ];then
    tanke_clear
    for hua in {0..4}
    do
        tanke_y[$hua]=`echo $[tanke_y[$hua]-2]` #也是要动2格子像素
    done
    tanke_yian 2 3 1
    tanke_the=3
else
    tanke_the=3
    tanke_hua
fi
}

tanke_xou(){
if [ $tanke_the -eq 4 ];then
    tanke_clear
    for hua in {0..4}
    do
        tanke_y[$hua]=`echo $[tanke_y[$hua]+2]`
    done
    tanke_yian 4 1 3
    tanke_the=4
else
    tanke_the=4
    tanke_hua
fi
}


######                      坦克的攻击                      ######
#玩家可以放置地雷，或者购买不同的炮弹来攻击
#炮弹是单独计算，所有可以多样

tanke_ok() {    #放在后台
shell_xy &
}

pa=0
shell_dandao() {  #子弹的弹道,并进行碰撞和掉血判断
echo -e "\033["45"m\033[${shell_x};${shell_y}H  \033[0m"
sleep 0.1
echo -e "\033["40"m\033[${shell_x};${shell_y}H  \033[0m"
}

shell_xy() {    #判断子弹的朝向
local shell_x shell_y she

shell_x=${tanke_player_x[0]}   #把头总是排在这个数组的0下标
shell_y=${tanke_player_y[0]}

if [ $tanke_the -eq 1 ];then    #如果朝上，则弹道向上
    for fa in {1..15}
    do
        let shell_x--
        if [ $shell_x -eq 1 ];then
            break
        fi
        zhuang
        shell_dandao
    done
elif [ $tanke_the -eq 2 ];then
    for fa in {1..15}
    do
        let shell_x++ 
        if [ $shell_x -eq 25 ];then
            break
        fi
        zhuang
        shell_dandao
    done
 elif [ $tanke_the -eq 3 ];then #因为格子问题，列的块要*2
    for fa in {1..30}
    do
        let shell_y--
        let shell_y--
        if [ $shell_y -eq 1 ];then
            break
        fi
        zhuang
        shell_dandao
    done
elif [ $tanke_the -eq 4 ];then    
    for fa in {1..30}
    do
        let shell_y++
        let shell_y++
        if [ $shell_y -eq 75 ];then
            break
        fi
        zhuang
        shell_dandao
    done
fi
}

zhuang() { #把墙去掉
local she
if ((${beijing[shell_x * 25 + shell_y]} != 6 ))
then
    echo -e "\033["40"m\033[${shell_x};${shell_y}H  \033[0m"
    ((she= shell_x * 25 + shell_y))
	beijing[$she]=6
    break
fi
}



######                      属性栏                      ######
#右侧属性栏有各种选项，用来显示血量等等
#属性栏在之前都不会显示
#属性栏中很多东西都是在后台运算的，比如计时，血量，炸弹数量等等



hp() {  #时刻检测血量
echo -e "\033["32"m\033[9;78H 当前血量： ${player_hp}\033[0m"   #先显示一个
echo -e "\033["37"m\033[9;89H ${player_hp}\033[0m"
while [ 1 ]
do
    if [ $player_hp -eq 0 ];then    #为0则退出游戏
        tanke_zanting
        kuang_clear
        shuxing_clear
        echo -e "\033["37"m\033[12;35H GAME OVER\033[0m"
        time_five
        p_exit
    fi
    echo -e "\033["40"m\033[9;89H         \033[0m" #清除

    echo -e "\033["37"m\033[9;89H ${player_hp}\033[0m"
    sleep 1 #防止死循环
done
}


player() {  #玩家的控制
local tanke_x tanke_y tanke_player_x tanke_player_y tanke_the se

tanke_y=(37 37 0 37 0)    #结合来看，为$1部分是不变的部分
tanke_x=(24 0 24 0 24)
tanke_player_x=() #最初坐标
tanke_player_y=()
tanke_the=1
se=47

tanke_yian 1 2 4   #显示初始的
while [ 1 ]
do
    read -s -n 1 tanke_zou  #坦克移动
    if [[ $tanke_zou == "w" || $tanke_zou == "W" ]];then
        tanke_shang
    elif [[ $tanke_zou == "s" ||  $tanke_zou == "S" ]];then
        tanke_xia
    elif [[ $tanke_zou == "a" ||  $tanke_zou == "A" ]];then
        tanke_zuo
    elif [[ $tanke_zou == "d" ||  $tanke_zou == "D" ]];then
        tanke_xou
#    elif [[ $tanke_zou == "i" ||  $tanke_zou == "I" ]];then
        #tanke_zanting
    elif [[ "[$tanke_zou]" == "[]" ]];then
        tanke_ok
        xiaoxi 发射子弹$pa
        let pa++
    elif [[ $tanke_zou == "1" ]];then   #按1放爆炸地雷
        blast_ok
    elif [[ $tanke_zou == "2" ]];then   #按2放脉冲地雷
        dizzy_ok
    elif [[ $tanke_zou == "P" || $tanke_zou == "p" ]];then
        p_exit
	fi  
done
}



######                      交流反馈                      ######

game_fankui() {
kuang_clear
echo -e "\033["32"m\033[12;15H qq：1969679546\033[0m"
echo -e "\033["32"m\033[13;15H 有反馈或改进的地方，可以联系我\033[0m"
echo -e "\033["32"m\033[14;15H 写这个是为了练手，不要喷我！\033[0m"
echo -e "\033["32"m\033[15;15H 当初看人写的shell俄罗斯方块，感觉好厉害，都看不懂\033[0m"
echo -e "\033["32"m\033[16;15H 没过一个月，现在我也能写个一样的了，大家加油！\033[0m"
echo -e "\033["37"m\033[20;60H 返回菜单\033[0m"
echo -e "\033["41"m\033[20;59H  \033[0m"    #红点
while [ 1 ]
do
read -s -n 1 ok
if [[ "[$ok]" == "[]" ]];then
    kuang_clear
    index
fi
done
}


######                      单独系统                      ######

time_five() {   #倒计时
for t in {5..1}
do
    echo -e "\033["37"m\033[3;65H $t\033[0m"
    sleep 1
done
}

time_jishi() {  #游戏计时系统
local time_one=0
while [ 1 ]
do
    time_fen=`echo $[time_one/60]` #计算出第几分钟
    time_miao=`echo $[time_one%60]` #计算秒
    if [ $time_one -lt  60 ];then
        echo -e "\033["40"m\033[3;78H                                \033[0m"
        echo -e "\033["37"m\033[3;78H 0：${time_miao}\033[0m"
        let time_one++
        sleep 1
    else
        echo -e "\033["40"m\033[3;78H                                \033[0m"
        echo -e "\033["37"m\033[3;78H ${time_fen}：${time_miao}\033[0m"
        let time_one++
        sleep 1
    fi
done
}



######                      游戏主程序                     ######
#把调用放在最后，因为脚本会整个读完放在内存中，不用怕先后问题

if [ $1 == "--help" ];then
    echo "直接执行即可！"
else
    #yuyan  #先检语言
    kuang   #开始主体菜单
    p_exit	#最后退出恢复
fi



######                      附加部分                      ######

one() {
字背景颜色范围:40----49 
40:黑 
41:深红 
42:绿
43:黄色 
44:蓝色 
45:紫色 
46:深绿 
47:白色 
}

two(){
经验：
1.首先是别想一次就做好，先想出个主页面，先把基本的实现出来再往里填
2.多用函数，阅读方便，修改方便，往里添加东西不会影响其他的
3.local加载的变量名可以一样，有规律好阅读
4.没有思路那就先把目前完成，你会发现有很多东西可以扩展
5.改一个版本就要备份一个，不然会后悔
6.当出现错误，可以把某些变量>> 到一个文件里看变量的变化做日志
}


