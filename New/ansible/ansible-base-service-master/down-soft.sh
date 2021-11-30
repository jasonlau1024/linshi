#!/bin/bash
tmp_dir="/opt/softdir"

#创建临时目录
mkdir -p $tmp_dir


# 下载java jdk
wget https://d2.injdk.cn/oracle/8/jdk-8u251-linux-x64.tar.gz -P $tmp_dir

# 下载zookeeper
wget http://archive.apache.org/dist/zookeeper/zookeeper-3.4.14/zookeeper-3.4.14.tar.gz -p $tmp_dir

# 下载rocketmq
wget https://archive.apache.org/dist/rocketmq/4.4.0/rocketmq-all-4.4.0-bin-release.zip -P $tmp_dir

# 下载redis
wget http://download.redis.io/releases/redis-5.0.8.tar.gz -P $tmp_dir

# 下载kafka
wget https://mirrors.tuna.tsinghua.edu.cn/apache/kafka/2.5.1/kafka_2.12-2.5.1.tgz -P $tmp_dir