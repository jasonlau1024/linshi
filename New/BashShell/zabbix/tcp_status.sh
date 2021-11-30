#!/usr/bin/env bash
#########################################################
# 功能  ：获取指定 TCP 状态连接数
# 系统  ：CentOS Linux release 7.9.2009
# 版本  ：1.0
# 作者  ：Jason Lau
#########################################################
[ $# -ne 1 ] && echo "Usage:CLOSE-WAIT|CLOSED|CLOSING|ESTAB|FIN-WAIT-1|FIN-WAIT-2|LAST-ACK|LISTEN|SYN-RECV|SYN-SENT|TIME_WAIT" && exit 1

TCP_STATUS(){
    tcpStat=$1
    ss -ant |awk 'NR>1 {++S[$1]} END {for(k in s) print k,s[k]}' > /tmp/ss.txt
    tcpStatNum=$(grep "${tcpStat}" /tmp/ss.txt | cut -d ' ' -f2)
    if [ -z "${tcpStatNum}" ];then
        tcpStatNum=0
    fi
    echo ${tcpStatNum}
}
TCP_STATUS $1