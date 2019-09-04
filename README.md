# 用于生产前请到测试环境进行测试，百密还有一疏呢！ QQ交流群：762696893

## 一.它有什么用？
支持中英文

一键安装LNMP，Redis，Python3，maven，redis集群等服务和环境初始化，性能优化等操作

拥有大量检测，可以用于生产环境（当前未测试完全）使用，当中途报错，解决后可再次执行，不会覆盖操作

支持自定义安装目录，可以搭配ansible或者其他批量操作工具，部署redis，zookeeper等一系列集群

ssc可以对所支持的脚本进行安装，卸载，查看，自定义编辑和离线压缩包


## 二.如何下载ssc！
[所有版本下载地址](https://github.com/goodboy23/shell-script-collection/releases "所有版本下载地址")

如下为安装最新版本：

`yum -y install git`

`git clone https://github.com/goodboy23/shell-script-collection`

`cd shell-script-collection`

`./ssc.sh`

## 三.如何使用ssc？

### 1.安装某个服务

下载后./ssc.sh list 查看是否有你想要的服务

./ssc.sh install nginx-1.8 将会安装nginx1.8版本，出现问题会提示，排除后重新安装

### 2.查看帮助

./ssc.sh
![](http://52wiki.oss-cn-beijing.aliyuncs.com/doc/0f37d3b8a541a4f4a83b226bad42d90e66cb58b9.png)

### 3.查看列表

./ssc.sh list
![](http://52wiki.oss-cn-beijing.aliyuncs.com/doc/67ad2f3b5c713937f4bc218322f6792e282c6d3d.png)

## 四.如何参与本项目？
直接修改再提交即可，也可以加qq1969679546，一起讨论。

## 五.默认安装的服务是1.6版本，我怎么换成1.7的？
例如，默认脚本安装的是1.6版本的nginx，但是你需要1.7版本的。将nginx安装包复制到package文件夹中

再使用./ssc.sh edit nginx 将 script_get 函数中网址部分替换为安装包名，md5部分替换为相应md5值

## 六.这些目录和文件都是干什么的？
conf #存放脚本的简略信息

lib #shell函数文件

material #存放脚本用到的配置文件或者txt文件

package #存放一键安装脚本用到的安装包

script #存放脚本文件

README.md #说明书

ssc.sh #管理脚本，管理其它脚本

## 七.如何添加一个新的脚本到合集中？
如果你想将你自己的一键安装脚本添加进来，可以仿照script/mysql.sh，如果想将备份脚本这种常用命令型脚本添加进来，可以仿照script/batch.sh。

其中用了大量test_exit等函数，可以从lib文件夹中查看函数具体用法

添加完成后，rm -rf conf/list*，删除存在的脚本列表

./ssc.sh list，生产新的脚本列表，使用./ssc.sh list 脚本名，来查看脚本是否被添加进去了
