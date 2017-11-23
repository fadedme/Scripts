#!/bin/bash
##-----------desc-----------------------
##desc   : system check && initializaton  
##depart : osp
##create : 2017-11-01
##update : 
##version: 1.0.0
##author : Syavingc
##mail   : syavingc@iroogoo.com
##-----------desc-----------------------

#######main

CentOS7_epel() {
echo -e "CentOS7_epel"
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
}

CentOS6_epel() {
echo -e "CentOS7_epel"
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo
}

#install tools
install_tools() {
echo -e "\033[32m \037Begin install tools,please waiting........\033[0m"

yum install -y setuptool tree vim wget ntp ftp telnet openssh-clients make dstat ncurses-devel gcc gcc-c++ make libtool lrzsz tmux>/dev/null 2>&1
if [ $? -eq 0 ];then
	echo -e "\033[32m \037The tools install finshed...\033[0m"
fi
}


selinux()
{
#being selinux config
SELINUX_STATUS=`cat /etc/selinux/config  |grep '^SELINUX\>' |cut -d "=" -f2`
if [[ $SELINUX_STATUS == enforcing || $SELINUX_STATUS == permissive ]];then
	sed -i "s/SELINUX=$SELINUX_STATUS/SELINUX=disabled/g" /etc/selinux/config
  	echo -e "Now selinux status is: \033[1;31m disable\033[0m."
else
  	echo -e "No change.The selinux status is: \033[1;35m disable\033[0m."
fi
}

Time()
{
#time zone
TIME_ZONE=`cat /etc/sysconfig/clock |grep '^ZONE' |cut -d "=" -f2`
if [ $TIME_ZONE != \"Asia/Shanghai\" ];then
cat > /etc/sysconfig/clock <<EOF
ZONE="Asia/Shanghai"
UTC=false
ARC=false
EOF

	TIME_ZONE=`cat /etc/sysconfig/clock |grep '^ZONE' |cut -d "=" -f2`
	echo -e "Now Time zone set success ,Zone now is: \"\033[1;31m$TIME_ZONE\033[0m\"."
else
  	echo -e "No change.Time zone is: \"\033[1;35m$TIME_ZONE\033[0m\"."
fi

}

##time sync
time_sync()
{
time_dns='pool.ntp.org'
/usr/sbin/ntpdate  -s $time_dns
TIME=`date +%Y-%m-%d_%T`
export LANG=C
if [ $? -eq 0 ];then
	echo -e "Sync time success.Now the time is: \"\033[1;32m$TIME\033[0m\""
fi
#sync time for bios
hwclock --systohc

}


ssh_port()
{
#change ssh login port
DE_SH=`cat /etc/ssh/sshd_config |grep 'Port\>' |head -c1`
DE_SH_PORT=`cat /etc/ssh/sshd_config |grep 'Port\>'`
if [ $DE_SH == \# ];then
	sed -i s/"$DE_SH_PORT"/"Port 8822"/ /etc/ssh/sshd_config
	SSH_PORT=`cat /etc/ssh/sshd_config |grep 'Port\>' |awk '{print $2}'`
	if [ $SSH_PORT == 8822 ];then
		echo -e "Now SSH port set success,port is: \"\033[1;31m$SSH_PORT\033[0m.\""
	fi
else
  	SSH_PORT=`cat /etc/ssh/sshd_config |grep 'Port\>' |awk '{print $2}'`
  	if [ $SSH_PORT != 8822 ];then
    		sed -i s/"Port $SSH_PORT"/"Port 8822"/ /etc/ssh/sshd_config
    		echo -e "Now SSH port \"\033[1;31m$SSH_PORT\033[0m\" has change \"\033[1;31m33898\033[0m\"."
  	else 
  		echo -e "No change SSH port is: \"\033[1;35m33898\033[0m\""
  	fi
fi
}


ssh_zip()
{
#open ssh zip
DEF_ZIP=`cat /etc/ssh/sshd_config |grep Compression  |head -c 1`
ZIP_STAT=`cat /etc/ssh/sshd_config |grep 'Compression'`
if [ $DEF_ZIP == \# ];then
	sed -i s/"$ZIP_STAT"/"Compression yes"/  /etc/ssh/sshd_config
	ZIP_STAT=`cat /etc/ssh/sshd_config |grep 'Compression'`
	echo -e "Open zip for scp success.status is: \"\033[1;31m$ZIP_STAT\033[0m.\""
else
	ZIP_STATUS=`cat /etc/ssh/sshd_config |grep 'Compression' |awk '{print $2}'`
	if [ $ZIP_STATUS != yes ];then
	 	sed -i s/"Compression $ZIP_STATUS"/"Compression yes"/  /etc/ssh/sshd_config
		echo -e "Scp zip status: \"\033[1;31m$ZIP_STATUS\033[0m\" has change \"\033[1;31myes\033[0m\"."
	else
		echo -e "No change scp commpression status: \"\033[1;35myes\033[0m\""
	fi
fi
}

ssh_dns()
{
#close dns for ssh con
DEF_DNS=`cat /etc/ssh/sshd_config |grep 'UseDNS' |head -c 1`
DNS_STAT=`cat /etc/ssh/sshd_config |grep 'UseDNS'`
if [ $DEF_DNS == \# ];then
	sed -i s/"$DNS_STAT"/"UseDNS no"/  /etc/ssh/sshd_config
	DNS_STAT=`cat /etc/ssh/sshd_config |grep 'UseDNS'`
	echo -e "Close dns for ssh.status is: \"\033[1;31m$DNS_STAT\033[0m.\""
else
	DNS_STATUS=`cat /etc/ssh/sshd_config |grep 'UseDNS' |awk '{print $2}'`
	if [ $DNS_STATUS != no ];then
	 	sed -i s/"UseDNS $DNS_STATUS"/"Compression no"/  /etc/ssh/sshd_config
		echo -e "DNS status: \"\033[1;31m$DNS_STATUS\033[0m\" has change \"\033[1;31mno\033[0m\"."
	else
		echo -e "No change UseDNS status: \"\033[1;35mno\033[0m\""
	fi
fi
}

ssh_startup()
{
#max start
START_MAX=`cat /etc/ssh/sshd_config |grep MaxStartups |head -c 1`
MAX_STAT=`cat /etc/ssh/sshd_config |grep MaxStartups`
if [ $DEF_DNS == \# ];then
	sed -i s/"$MAX_STAT"/"MaxStartups 5"/  /etc/ssh/sshd_config
	MAX_STAT=`cat /etc/ssh/sshd_config |grep MaxStartups`
	echo -e "The max startups status is : \"\033[1;31m$MAX_STAT\033[0m.\""
fi
}

ssh_emptypasswd()
{
#refuse empty passwd login
DEF_EMPTY=`cat /etc/ssh/sshd_config |grep PermitEmptyPasswords |head -c 1`
EMPTY_STAT=`cat /etc/ssh/sshd_config |grep PermitEmptyPasswords`
if [ $DEF_EMPTY == \# ];then
	sed -i s/"$EMPTY_STAT"/"PermitEmptyPasswords no"/  /etc/ssh/sshd_config
	EMPTY_STAT=`cat /etc/ssh/sshd_config |grep PermitEmptyPasswords`
	echo -e "PermitEmptyPasswords status is: \"\033[1;31m$EMPTY_STAT\033[0m.\""
else	
	EMPTY_STATUS=`cat /etc/ssh/sshd_config |grep 'PermitEmptyPasswords' |awk '{print $2}'`
	if [ $EMPTY_STATUS != no ];then
	 	sed -i s/"PermitEmptyPasswords $EMPTY"/"PermitEmptyPasswords no"/  /etc/ssh/sshd_config
		echo -e "PermitEmptyPasswords status: \"\033[1;31m$EMPTY_STATUS\033[0m\" has change \"\033[1;31mno\033[0m\"."
	else
		echo -e "No change PermitEmptyPasswords status: \"\033[1;35mno\033[0m\""
	fi
fi

}

ssh_restart()
{
echo -e "\033[1;32m Begin restart sshd process....\033[0m"
/etc/init.d/sshd restart >/dev/null
if [ $? -eq 0 ];then
	echo -e "\033[1;31m sshd_config set success. \033[0m"
fi

}

profile_hist()
{
#begin set add time format for history
PRO_COUNT=`cat /etc/profile |grep 'HISTTIMEFORMAT' |wc -l`
if [ $PRO_COUNT -eq 0 ];then
  	/bin/sed -i "/^export PATH/a\export HISTTIMEFORMAT" /etc/profile
  	/bin/sed -i "/^HISTSIZE/a\HISTTIMEFORMAT=\"%Y-%m-%d %H:%M:%S: \"" /etc/profile
  	export HISTTIMEFORMAT
  	echo -e "Now The\033[1;31m history timeformat\033[0m set success now."
else
  	echo -e "No change.The\033[1;35m history timeformat\033[0m has setted ."
fi
}

profile_other()
{
echo "TMOUT=1800" >> /etc/profile 
echo "alias vi='vim'" >>/etc/profile
echo "unset MAILCHECK" >> /etc/profile
source /etc/profile
}

run_level()
{
#begin set runlevel
RUNLEVEL=`cat /etc/inittab |grep '^id:.:initdefaul' |cut -d":" -f2`
if [ $RUNLEVEL != 3 ];then
  	/bin/sed -i  s/"id:$RUNLEVEL"/"id:3"/ /etc/inittab
  	NOW_RUNLEVEL=`cat /etc/inittab |grep '^id:.:initdefaul' |cut -d":" -f2`
  	echo -e "Now the runlevel is \"\033[1;31m$NOW_RUNLEVEL\033[0m\"."
else
  	echo -e "No change .The runlevel is \"\033[1;35m$RUNLEVEL\033[0m\"."
fi
}

iptables()
{
##begin set iptables start levle
/sbin/chkconfig --level 2345 iptables off
echo -e "Now default \033[1;31m iptables\033[0m start runlevel all set off "
/etc/init.d/iptables stop > /dev/null 
}


unnecessary_service()
{
#begin turn off unnecessary services
export LANG=C
echo -e "\e[32m begin turn off unnecessary services.....\e[0m"
for close_list in `chkconfig --list |awk '($5~/on/ || $7~/on/) {print $1}' | grep -vE "atd|crond|cpuspeed|irqbalance|lvm2-monitor|network|smartd|sshd|syslog|sysstat"`
do		
	echo $close_list
	/sbin/chkconfig --level 2345 $close_list off
	/sbin/service $close_list stop >/dev/null
done
echo -e "Now The \033[1;31m unnecessary services \033[0m turn off now."
#echo -e "\e[32m----------------End  system initialization ---------------\e[0m"
}

##set sysctl.conf

sysctl_set()
{
cat >> /etc/sysctl.conf <<EOF
###################################################
vm.overcommit_memory = 1
###################################################
net.netfilter.nf_conntrack_max=1000000
###################################################
net.core.rmem_default = 126976
net.core.wmem_default = 126976
net.core.wmem_max = 16777216
net.core.rmem_max = 16777216
net.ipv4.tcp_mem = 8192 87380 16777216
net.ipv4.tcp_wmem = 8192 65536 16777216
net.ipv4.tcp_rmem = 8192 87380 16777216
###################################################
net.core.netdev_max_backlog = 2500
net.core.somaxconn = 100000
###################################################
net.ipv4.tcp_no_metrics_save = 0
net.ipv4.tcp_moderate_rcvbuf = 1
net.ipv4.tcp_orphan_retries= 1
net.ipv4.tcp_fin_timeout = 5 
net.ipv4.tcp_keepalive_time = 300
net.ipv4.tcp_syncookies = 1 
net.ipv4.tcp_sack = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.ip_local_port_range = 10250 65000
net.ipv4.tcp_max_syn_backlog = 81920
net.ipv4.tcp_max_tw_buckets = 1600000
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 2
net.ipv4.tcp_retries2 = 2
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_timestamps = 1 
###################################################
fs.file-max = 1024000
EOF

sysctl -p >/dev/null 2>1&

}

#limit file 
limit_file()
{
cat >> /etc/security/limits.conf <<EOF
*                hard    nofile         1024000
*                soft    nofile         1024000
*                hard    nproc          1024000
*                soft    nproc          1024000
EOF
}

sudu_log()
{
touch /var/log/sudo.log
cat >> /etc/sudoers <<EOF
syavingc    ALL=(ALL)       NOPASSWD: /bin/sh
Defaults logfile=/var/log/sudo.log
EOF

cat >> /etc/rsyslog.conf <<EOF
local8.debug    /var/log/sudo.log
EOF
}



echo -e "\e[32m----------------Begin  system initialization ---------------\e[0m"
echo
CentOS6_epel
install_tools
selinux
Time
time_sync
ssh_port
ssh_zip
ssh_dns
ssh_startup
ssh_emptypasswd
ssh_restart
profile_hist
profile_other
run_level
iptables
unnecessary_service
sysctl_set
limit_file
sudu_log
echo
echo -e "\e[32m----------------End  system initialization ---------------\e[0m"
