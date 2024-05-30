#Define base image

#FROM alpine:3.16.1
#FROM --platform=linux/amd64/v8 alpine:3.16.1
#FROM public.ecr.aws/h1a5s9h8/alpine:latest
FROM public.ecr.aws/docker/library/alpine:edge

ENV ENV_PATH /usr/share/nginx/html
ENV ENV_USER nginx
ENV ENV_GROUP www-data

#installing General updates
RUN apk update && apk upgrade

#installing bash
RUN apk add bash

#installing mysql client
#RUN apk add mysql mysql-client

#installing vim editor
RUN apk add vim

#installing Nginx
RUN apk add nginx

RUN apk add php82 \ 
    php82-fpm \ 
    php82-opcache \
    php82-gd \ 
    php82-zlib \ 
    php82-curl \ 
    php82-iconv \ 
    php82-phar \ 
    php82-mbstring \ 
    php82-xml \ 
    php82-openssl \
    php82-curl \ 
    php82-xsl \ 
    php82-dom \ 
    php82-tokenizer \ 
    php82-xmlwriter \ 
    php82-session \ 
    php82-pdo_mysql \ 
    php82-tidy \ 
    php82-intl \ 
    php82-simplexml \ 
    php82-xmlreader \ 
    php82-zip \ 
    php82-fileinfo \
    php82-mysqli \
    php82-pecl-xdebug \
    php82-exif
    
#RUN apk add php82-pecl-imagick
COPY docker/nginx/default.conf /etc/nginx/http.d/default.conf
COPY docker/nginx/nginx.conf /etc/nginx/nginx.conf

#copy php fpm settings to there.
COPY docker/php /etc/php82

#COPY . /usr/share/nginx/html
COPY . ${ENV_PATH}

COPY ./docker/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN dos2unix /usr/local/bin/entrypoint.sh

#COPY . /app/public/

RUN mkdir /var/run/php

#make php82 as like php. otherwise composer will not execute.
RUN ln -s /usr/bin/php82 /usr/bin/php || echo '/usr/bin/php folder exist'


# Install Composer on alpine image
RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin/ --filename=composer


WORKDIR ${ENV_PATH}/

#laravel permission
RUN chown -R ${ENV_USER}:${ENV_GROUP} ${ENV_PATH}/
RUN chgrp -R ${ENV_GROUP} ${ENV_PATH}/storage ${ENV_PATH}/bootstrap/cache
RUN chmod -R 0777 ${ENV_PATH}/storage

#for local
#EXPOSE 8081
#for live
EXPOSE 80

EXPOSE 443

#set exit signal
STOPSIGNAL SIGTERM

#remmove temp
RUN rm  -rf /tmp/* /var/cache/apk/*

#ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
#CMD ["nginx", "-g", "daemon off;"]
#CMD ["/bin/bash", "-c", "php-fpm82 && chmod 777 /var/run/php/php82-fpm.sock && chmod 755 ${ENV_PATH}/* && nginx -g 'daemon off;'"]
