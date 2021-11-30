#!/usr/bin/env bash
#########################################################
# 功能  ：安装 docker-ce/docker-compose/配置国内仓库
# 系统  ：CentOS Linux release 7.9.2009
# 版本  ：1.0
# 作者  ：Jason Lau
#########################################################

# 指定安装版本号
dockerVersion="19.03.1"
dockerComposeVersion="1.24.1"

# 安装 docker-ce
INSTALL_DOCKER(){
    yum install yum-utils device-mapper-persistent-data lvm2 -y
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    yum install docker-ce-${dockerVersion} -y
    systemctl start docker
    systemctl enable docker
    docker version
    [ $? -ne 0 ] && (echo "未找到 docker 命令。";exit 1) || echo "docker-ce 安装成功。"
}

# 安装 docker-compose
INSTALL_COMPOSE(){
    curl -L https://github.com/docker/compose/releases/download/${dockerComposeVersion}/docker-compose-`uname -s`-`uname -m` \
    -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    [ $? -ne 0 ] && (echo "未找到 docker-compose 命令。";exit 2) || echo "docker-compose 安装成功。"
}

# 配置国内docker仓库
CONFIG_DOCKER(){
    [ -f /etc/docker/daemon.json ] || (echo "docker 配置文件 daemon.json 文件已存在";exit 3)
    cat > /etc/docker/daemon.json << EOF
{
    "registry-mirrors":[ "https://registry.docker-cn.com" ]
}
EOF
    systemctl restart docker
}

# 调用函数
INSTALL_DOCKER
INSTALL_COMPOSE
CONFIG_DOCKER