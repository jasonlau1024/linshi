参考文档：https://prometheus.io/docs/guides/cadvisor/#prometheus-configuration

默认安装：

cadvisor

prometheus

prometheus_grafana_1

redis-for-monitor-test

## 部署

`docker-compose up`

如果 Docker Compose 成功启动了所有三个容器，您应该会看到如下输出：

```
prometheus  | level=info ts=2018-07-12T22:02:40.5195272Z caller=main.go:500 msg="Server is ready to receive web requests."
```

`docker-compose ps`

```SHELL
         Name                       Command               State                    Ports
----------------------------------------------------------------------------------------------------------
cadvisor                 /usr/bin/cadvisor -logtostderr   Up      8080/tcp
prometheus               /bin/prometheus --config.f ...   Up      9090/tcp
prometheus_grafana_1     /run.sh                          Up      0.0.0.0:3000->3000/tcp,:::3000->3000/tcp
redis-for-monitor-test   docker-entrypoint.sh redis ...   Up      6379/tcp
```

### 配置 Grafana 使用 Prometheus 源

URL http://prometheus:9090

## 异常报错

### 1. 国内网络下载不了`gcr.io/cadvisor/cadvisor`Google镜像

解决:

docker.io仓库对google的容器做了镜像，可以改成：`docker.io/mirrorgooglecontainers/cadvisor:latest`



