#!/bin/bash
#
# Version: V1.0
# Author: syavingc
# Contact: syavingc@iroogoo.com
# Created Time : 2017-11-01 
# Describe:


#由于CentOS没有官方FFmpeg rpm软件包。但是，我们可以使用第三方YUM源（Nux Dextop）完成此工作。

#for CentOS 7
ffmpeg_epol_CentOS7(){
rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro
rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
}


#for CentOS 6
ffmpeg_epol_CentOS6(){
rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro
rpm -Uvh http://li.nux.ro/download/nux/dextop/el6/x86_64/nux-dextop-release-0-2.el6.nux.noarch.rpm
}

#Choose yum 
ffmpeg_epol_CentOS6

#install FFmpeg and FFmpeg-devel
yum install ffmpeg ffmpeg-devel -y

#test ffmpeg
ffmpeg
