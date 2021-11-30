#!/usr/bin/env bash
#########################################################
# 功能  ：安装 Golang 环境
# 系统  ：CentOS Linux release 7.9.2009
# 版本  ：1.0
# 作者  ：Jason Lau
#########################################################

goVersion="1.17.2"
installDir=/opt/go${goVersion}

[ -d ${installDir} ] || mkdir -p ${installDir}

INSTALL_GO(){
    wget https://dl.google.com/go/go${goVersion}.linux-amd64.tar.gz
    [ -f go${goVersion}.linux-amd64.tar.gz ] && \
    tar xf go${goVersion}.linux-amd64.tar.gz -C ${installDir} || \
    echo "文件：go${goVersion}.linux-amd64.tar.gz 不存在"
    mkdir -p ${installDir}/gopath/{bin,src}
    cat >>/etc/profile<<EOF
export GOROOT=${installDir}/go
export GOPATH=${installDir}/gopath
export PATH=\$PATH:${installDir}/gopath/bin:${installDir}/go/bin
EOF
    source /etc/profile
    go version
    [ $? -ne 0 ] && (echo "未找到 go 命令。";exit 1) || echo "Golang 安装成功。"
}

# 调用
INSTALL_GO




