FROM php:7.2-fpm

RUN sed -i "s@http://deb.debian.org@http://mirrors.aliyun.com@g" /etc/apt/sources.list && rm -Rf /var/lib/apt/lists/* &&  cat /etc/apt/sources.list

RUN apt-get update \
	&& apt-get install sudo -y \
	#安装vim文本编辑器
	&& apt-get install vim -y \
	#安装wget下载工具
	&& apt-get install wget -y \
	#安装网络管理工具
	&& apt-get install net-tools -y \
	#安装ping
	&& apt-get install iputils-ping -y \
	#安装telnet
	&& apt-get install telnet -y \
	#安装进程管理命令ps, top, vmstat, w, kill, free, slabtop, and skill
	&& apt-get install procps -y \
		#安装C/C++编译包，该软件包，编译c/c++所需要的软件包也都会被安装。
    	#该包包含gcc，g++，make等`
    && apt-get install build-essential -y \
	&& apt-get install -y \
        git \
        curl \
        libpng-dev \
        libonig-dev \
        libxml2-dev \
        zip \
        unzip\
	&& docker-php-ext-install -j$(nproc) pdo_mysql bcmath mbstring sockets pcntl zip

RUN pecl install redis-5.1.1 \
    && docker-php-ext-enable redis
	#安装zip依赖 zlib




