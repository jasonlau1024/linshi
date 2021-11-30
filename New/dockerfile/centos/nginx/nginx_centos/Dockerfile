FROM centos:centos7.9.2009

LABEL maintainer="Jason Lau" \
      nginx_version="1.20.1" \
      nginx_path="/apps/nginx{conf,html,logs}"

ADD nginx-1.20.1.tar.gz /usr/local/src

RUN yum install -y  gcc gcc-c++  pcre pcre-devel zlib zlib-devel openssl openssl-devel \
    && yum clean all \
    && cd /usr/local/src/nginx-1.20.1 \
    && ./configure --prefix=/apps/nginx \
    && make && make install \
    && rm -rf /usr/local/src/nginx* \
    && groupadd -r nginx && useradd -r -s /bin/false -g nginx nginx

COPY nginx.conf /apps/nginx/conf/

COPY index.html /apps/nginx/html/

EXPOSE 80 443

CMD ["/apps/nginx/sbin/nginx","-g","daemon off;"]