FROM php:7.1-fpm-alpine
RUN apk upgrade --update && apk add --no-cache --update \
    autoconf file g++ gcc binutils isl libatomic libc-dev musl-dev make re2c libstdc++ libgcc libcurl binutils-libs mpc1 mpfr3 gmp libgomp coreutils freetype-dev libjpeg-turbo-dev libltdl libmcrypt-dev libpng-dev openssl-dev libxml2-dev expat-dev  libmemcached-dev curl-dev zlib-dev icu icu-libs icu-dev libsasl
RUN docker-php-ext-install \
    intl \
    pdo \
    pdo_mysql \
    curl \
    bcmath \
    mcrypt \
    mbstring \
    json \
    xml \
    zip \
    opcache \
    soap \
    phar

RUN pecl channel-update pecl.php.net
ENV MEMCACHED_DEPS zlib-dev libmemcached-dev cyrus-sasl-dev
RUN apk add --no-cache --update libmemcached-libs zlib
RUN set -xe \
    && apk add --no-cache --update --virtual .phpize-deps $PHPIZE_DEPS \
    && apk add --no-cache --update --virtual .memcached-deps $MEMCACHED_DEPS \
    && pecl install memcached \
    && echo "extension=memcached.so" > /usr/local/etc/php/conf.d/20_memcached.ini \
    && rm -rf /usr/share/php7 \
    && rm -rf /tmp/* \
    && apk del .memcached-deps .phpize-deps
RUN pecl install mongodb && docker-php-ext-enable mongodb
RUN pecl install igbinary && docker-php-ext-enable igbinary
RUN pecl install xdebug && \
echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
echo "xdebug.idekey=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
echo "xdebug.remote_port=9001" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
echo "xdebug.remote_autostart=0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
echo "xdebug.remote.mode=req" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
echo "xdebug.remote.handler=dbgp" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
docker-php-ext-enable xdebug
RUN curl -sS https://getcomposer.org/installer | php \
        && mv composer.phar /usr/local/bin/ \
        && ln -s /usr/local/bin/composer.phar /usr/local/bin/composer
RUN echo "[PHP]\\ndate.timezone=UTC" | tee -a /usr/local/etc/php/conf.d/tzone.ini

CMD ["php-fpm"]
