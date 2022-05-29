FROM stanislasp/pfcnx-laravel:3.0

COPY conf/php.ini /usr/local/etc/php/conf.d/php.ini
COPY conf/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

RUN apt-get update \
    && apt-get install -y default-mysql-client \
    && apt-get -y autoclean \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
