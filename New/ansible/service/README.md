
ansible-playbook 目录规划
```SHELL
groups  # 用于多个role共享变量，（groups 内文件 roles内文件 和 主机组 命名保持一致）
  aaaa(group01)
  bbbb(group02)
  ...
roles   # 命名应该尽量做到见名知其意，可以把 软件 安装 和 软件配置 分开，以便重复利用。
  aaaa(role01)
  bbbb(role02)
  ...

xx.yml
hosts.ini
# 主机定义规则，一般定义IP即可，需要配置相关hostname,ssh信息的也可以配置。
第一种：
[aaaa]
192.168.1.10 hostname=test-app01-project01-hk-aliyun
192.168.1.10 hostname=test-app02-project01-hk-aliyun
192.168.1.10 hostname=test-app03-project01-hk-aliyun
第二种：一般要求，新接入的机器，需要统一做初始化工作，包括创建一个具有sudo权限的用户用于管理机器。
[aaaa]
192.168.3.161 hostname=test-app01-project01-hk-aliyun ansible_ssh_port=22 ansible_ssh_user=root ansible_ssh_pass=Aa123456
192.168.3.162 hostname=test-app02-project01-hk-aliyun ansible_ssh_port=22 ansible_ssh_user=root ansible_ssh_pass=Aa123456
192.168.3.163 hostname=test-app03-project01-hk-aliyun ansible_ssh_port=22 ansible_ssh_user=root ansible_ssh_pass=Aa123456




### nginx
目录结构：
```SHELL
roles/nginx
├── files
│   ├── index.html
│   ├── nginx-1.20.1.tar.gz
│   ├── nginx.service
│   └── nginx.sh
├── tasks
│   └── main.yml
├── templates
│   ├── default_server.conf.j2
│   ├── nginx.conf.j2
│   ├── status.conf.j2
│   └── www.conf.j2
└── vars
    └── main.yml
```


nginx 源码包下载地址：
<https://nginx.org/download/nginx-1.20.1.tar.gz>

nginx 官方启动脚本文档：
<https://www.nginx.com/resources/wiki/start/topics/examples/initscripts/>



### jdk
目录结构：
```SHELL
roles/jdk
├── files
│   ├── jdk-8u311-linux-x64.tar.gz
│   └── jdk.sh
├── tasks
│   └── main.yml
└── vars
    └── main.yml
```


### mysql
mysql 二进制包下载地址：
<https://downloads.mysql.com/archives/community/>

目录结构：
```SHELL
roles/mysql/
├── files
│   ├── libaio-0.3.109-13.el7.x86_64.rpm
│   ├── mysql-5.7.36-el7-x86_64.tar.gz
│   ├── mysqld.service
│   └── mysql.sh
├── tasks
│   └── main.yml
├── templates
│   └── my.cnf.j2
└── vars
    └── main.yml
```

### tomcat



### php
下载地址：
<https://www.php.net/downloads.php>



### docker
目录结构：
```SHELL
roles/docker
├── files
│   └── daemon.json
├── tasks
│   ├── 1_install_docker.yml
│   ├── 2_install_docker-compose.yml
│   └── main.yml
└── vars
    └── main.yml

```

### kafka

功能验证：
1）创建 topic
```SHELL
# 创建 topic test
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test
# 查看 topic
bin/kafka-topics.sh --list --zookeeper localhost:2181
```
2) 消息生产与消费
```SHELL
# 发送消息
bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test
Hello 01
Hello 02
# 接收消息
bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test --from-beginning
Hello 01
Hello 02
···


