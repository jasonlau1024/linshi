#!/usr/bin/env bash
#########################################################
# 功能  ：yum install nginx 最新版本/配置 nginx
# 系统  ：CentOS Linux release 7.9.2009
# 版本  ：1.0
# 作者  ：Jason Lau
#########################################################

# 域名
domainName="www.example.com"

# 证书文件（放于脚本同目录下）
sslCertificate="fullchain.crt"
sslCertificateKey="privkey.key"

# 安装 nginx
INSTALL_NGINX(){
    cat > /etc/yum.repos.d/nginx.repo <<"EOF"
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/7/$basearch/
gpgcheck=0
enabled=1
EOF
    yum install nginx -y
    nginx -V
    [ $? -ne 0 ] && (echo "未找到 nginx 命令。";exit 1) || echo "nginx 安装成功。"
}

# 配置 nginx HTTP 站点
CONFIG_NGINX_HTTP(){


}

# 配置 nginx HTTPS 站点
CONFIG_NGINX_HTTPS(){

}

# 调用函数
INSTALL_NGINX
CONFIG_NGINX_HTTP
