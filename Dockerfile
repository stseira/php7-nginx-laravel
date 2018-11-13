FROM ubuntu:18.04
ADD sources.list /etc/apt/sources.list

ENV LC_ALL=C.UTF-8 
ENV export LANG=C.UTF-8

RUN apt-get update
RUN apt-get install -y wget nginx php7.2 php7.2-fpm php7.2-json php7.2-mbstring php7.2-cli php7.2-xml php7.2-zip unzip

RUN sed -i "s/^;date.timezone =$/date.timezone = \"Asia\/Seoul\"/" /etc/php/7.2/fpm/php.ini
RUN sed -i "s/^;date.timezone =$/date.timezone = \"Asia\/Seoul\"/" /etc/php/7.2/cli/php.ini
ADD nginx-default /etc/nginx/sites-available/default

ADD composer_installer.sh /root/composer_installer.sh
RUN . /root/composer_installer.sh
RUN composer config -g repositories.packagist composer https://packagist.jp

WORKDIR /var/www
RUN composer create-project --prefer-dist laravel/laravel laravel
RUN chown -R www-data.www-data /var/www/laravel/storage

ADD entrypoint.sh /root/entrypoint.sh
ENTRYPOINT [ "/bin/bash", "/root/entrypoint.sh" ]

EXPOSE 8000