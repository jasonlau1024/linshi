#!/usr/bin/env bash
#########################################################
# 功能  ：安装 docker-ce/docker-compose/配置国内仓库
# 系统  ：CentOS Linux release 7.9.2009
# 版本  ：1.0
# 作者  ：Jason Lau
# 备注  ：传递一个参数，该参数为对应的网卡名，如：eth0
#########################################################

Usage="Usage:/bin/bash $0 NICDriver"
NICDriver=$1

grep "${NICDriver}" /proc/net/dev >> /dev/null
if [[ $? != 0 ]] || [[ $# != 1 ]] ;then
    echo ${Usage}
    exit 3
fi

while true;do
    RXFirst=$(awk '$0~"'$NICDriver'"{print $2}' /proc/net/dev)
    TXFirst=$(awk '$0~"'$NICDriver'"{print $10}' /proc/net/dev)
    sleep 1
    RXNext=$(awk '$0~"'$NICDriver'"{print $2}' /proc/net/dev)
    TXNext=$(awk '$0~"'$NICDriver'"{print $10}' /proc/net/dev)

    RX=$(((${RXNext} - ${RXFirst})/1024))
    TX=$(((${TXNext} - ${TXFirst})/1024))
    clear
    echo -e "$(date +%k:%M:%S)"
    echo -e "入流量(RX): ${RX} KB/s"
    echo -e "出流量(TX): ${TX} KB/s"
done