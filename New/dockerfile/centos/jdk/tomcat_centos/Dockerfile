FROM centos:centos7.9.2009

LABEL maintainer="Jason Lau" \
      jdk_version="1.8.0_311"

ADD jdk-8u311-linux-x64.tar.gz /apps/

RUN cd /apps && mv jdk1.8.0_311 jdk \

ENV JAVA_HOME /apps/jdk
ENV PATH $PATH:$JAVA_HOME/bin
