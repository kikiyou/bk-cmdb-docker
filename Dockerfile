FROM centos:7.3.1611

RUN yum install git traceroute bind-utils net-tools telnet unzip yum-utils epel-release -y && \
    yum install gcc make cpp libgomp libmpc mpfr -y && \
    yum-builddep nginx php -y && \
    curl -o /tmp/nginx.tar.gz http://nginx.org/download/nginx-1.8.1.tar.gz && \
    curl -o /tmp/php.tar.gz http://cn2.php.net/distributions/php-5.6.30.tar.gz && \
    tar xf /tmp/nginx.tar.gz -C /tmp && rm -rf /tmp/nginx.tar.gz && \
    tar xf /tmp/php.tar.gz -C /tmp && rm -rf /tmp/php.tar.gz && \
    cd /tmp/nginx-*/ && ./configure --prefix=/opt/nginx --with-pcre && make && make install && \
    cd /tmp/php-*/ && ./configure --prefix=/opt/php -enable-fpm --with-mysql --with-curl --enable-pcntl --with-mhash -enable-zip --enable-mbregex --enable-mbstring --with-openssl && make && make install && \
    rm -rf /opt/nginx/html/* && git clone https://github.com/Tencent/bk-cmdb.git /opt/nginx/html && \
    mkdir -p /data/session && \
    chmod 777 /data/session /opt/nginx/html/application/resource/upload/importPrivateHostByExcel && \
    rm -rf /tmp/* && yum clean all
    
COPY nginx.conf /opt/nginx/conf/nginx.conf
COPY config.php /opt/nginx/html/application/config/config.php
COPY db.php /opt/nginx/html/application/config/db.php
COPY docker-entrypoint.sh /entrypoint.sh
CMD ["-g", "daemon off;"]
ENTRYPOINT ["/entrypoint.sh"]
