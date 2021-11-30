FROM centos:centos7.9.2009

LABEL maintainer="Jason Lau"

RUN yum -y install wget \
    && rm -f /etc/yum.repos.d/* \
    && wget -P /etc/yum.repos.d/ http://mirrors.aliyun.com/repo/Centos-7.repo \
    && wget -P /etc/yum.repos.d/ http://mirrors.aliyun.com/repo/epel-7.repo \
    && yum -y install  vim-enhanced tcpdump lrzsz tree telnet bash-completion net-tools wget bzip2 lsof  zip unzip nfs-utils gcc make gcc-c++ glibc glibc-devel pcre pcre-devel openssl  openssl-devel systemd-devel zlib-devel \
    && yum clean all \
    && rm -f /etc/localtime  \
    && ln -s ../usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && groupadd -r appuser && useradd -r -s /bin/false -g appuser appuser \
    && mkdir /apps && chown appuser:appuser /apps