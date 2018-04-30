#!/bin/sh
#-----------------------------------
#功能：安装依赖和在cron添加定时任务
#作者：Bear(bearcubhaha@gmail.com)
#备注：仅在Ubuntu16.04上测试过，需要cron支持
#修改时间：2018.04.28
#-----------------------------------
#本文件所在目录
DIR="$( cd "$( dirname "$0"  )" && pwd  )"

cd $DIR

printAndExit(){
  echo -e "\033[41;37m$1\033[0m"
  exit -1
}

if [ $(whoami) != "root" ];then
  printAndExit "不是以root身份执行"
else
  echo "更新apt源……"
  apt-get update > /dev/null || printAndExit "更新apt源失败。是否联网？"
  echo "用apt安装依赖libfontconfig1"
  apt-get install -y libfontconfig1 > /dev/null || printAndExit "apt安装依赖失败。请检查是否联网。"
  if [ ! -f "$DIR/phantomjs-2.1.1-linux-x86_64.tar.bz2" ];then
    echo "下载phantomjs安装包"
    wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 || printAndExit "下载失败。是否有wget命令？"
  fi
  echo "解压phantomjs安装包"
  tar -xjf phantomjs-2.1.1-linux-x86_64.tar.bz2 -C $DIR || printAndExit "解压安装包失败。请检查系统是否有tar命令。"
  echo "用cron设置定时执行认证上网"
  echo "*/10 * * * * root bash $DIR/login.sh" > /etc/cron.d/web-auth-ictcas
  echo "安装完成！"
fi
