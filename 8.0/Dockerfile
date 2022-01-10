FROM php:8.0-fpm

WORKDIR /var/www

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=UTC
ARG WWWUSER=1000
ENV WWWUSER ${WWWUSER}
ARG WWWGROUP=1000
ENV WWWGROUP ${WWWGROUP}

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y libxml2-dev libzip-dev libpq-dev libpng-dev curl ca-certificates zip unzip inetutils-syslogd git gnupg \
    && mkdir -p ~/.gnupg \
    && chmod 600 ~/.gnupg \
    && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf \
    && apt-key adv --homedir ~/.gnupg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E5267A6C \
    && apt-key adv --homedir ~/.gnupg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C300EE8C \
    && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && docker-php-ext-install bcmath pdo_pgsql zip gd \
    && curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get update \
    && apt-get install -y --no-install-recommends nodejs \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends yarn \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && pecl channel-update https://pecl.php.net/channel.xml \
    && pecl install xdebug swoole \
    && docker-php-ext-enable xdebug swoole \
    && addgroup -gid ${WWWGROUP} application \
    && adduser --system --uid ${WWWUSER} --home "/home/application" --shell /bin/bash -gid ${WWWGROUP} application \
    && chown application:application /var/www

COPY ext-xdebug.ini /usr/local/etc/php/conf.d/
COPY php/local.ini /usr/local/etc/php/php.ini
COPY start.sh /start.sh
COPY www.conf /usr/local/etc/php-fpm.d/www.conf

EXPOSE 9000

CMD ["bash", "/start.sh"]