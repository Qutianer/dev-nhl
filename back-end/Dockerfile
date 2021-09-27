FROM nginx:1.21.3
RUN apt-get update && apt-get -y install php7.3-fpm php7.3-mysql && rm -rf /var/lib/apt/lists/*
COPY include/40-php-fpm.sh  /docker-entrypoint.d/
COPY src /opt/app
