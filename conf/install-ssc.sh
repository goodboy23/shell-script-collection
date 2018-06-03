#!/bin/bash
#下载ssc

yum -y install git
rpm -q git
if [ $? -ne 0 ];then
    echo "Git can not be installed, please install manually"
    exit 2
fi

git clone https://github.com/goodboy23/ssc.git
if [ ! -d ssc ];then
    echo "Download failed, please re-execute the script"
    exit 3
fi

cd ssc
chmod +x ssc.sh
./ssc.sh

cd ..
rm -rf install-ssc.sh