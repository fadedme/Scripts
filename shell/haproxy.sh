#!/bin/bash  
BASE_DIR="/usr/local/haproxy"  
ARGV="$@"  
  
start()  
{  
echo "START HAPoxy SERVERS"  
$BASE_DIR/sbin/haproxy -f $BASE_DIR/haproxy.cfg  
}  
  
stop()  
{  
echo "STOP HAPoxy Listen"  
kill -TTOU $(cat $BASE_DIR/logs/haproxy.pid)  
echo "STOP HAPoxy process"  
kill -USR1 $(cat $BASE_DIR/logs/haproxy.pid)  
}  
case $ARGV in  
  
start)  
start  
ERROR=$?  
;;  
  
stop)  
stop  
ERROR=$?  
;;  
  
restart)  
stop  
start  
ERROR=$?  
;;  
  
*)  
echo "hactl.sh [start|restart|stop]"  
esac  
exit $ERROR  