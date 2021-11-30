1, 已验证环境:
```shell
Centos 7
```

2, 关于hosts
```shell
2.1 按需修改hosts.ini
```

3, vars 变量定义, 可按需修改
```shell
# vim group_vars/all.yml
```

4. 下载所需文件
```shell
# vim down-soft.sh #版本与all.yml 对应
```

4, 实现功能
```shell
4.0 系统初始化,并部署java
4.1 自动部署zookeeper集群
4.2 自动部署rocketmq集群
4.3 自动部署redis集群，哨兵模式
4.4 自动部署kafka集群
```

5, 使用方法
```shell
# bash down-soft.sh #下载所需文件
# ansible -i hosts.ini all -m shell -a "whoami" #如能正常线上root, 说明hosts.ini 配置没有问题，并有root权限
# ansible-playbook -i hosts.ini start.yml
```

6, 单独部署
```shell
# ansible-playbook -i hosts.ini start.yml -t init,zookeeper
# ansible-playbook -i hosts.ini start.yml -t init,zookeeper,kafka
```