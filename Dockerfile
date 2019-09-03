FROM php:7.2-cli

# Install modules
RUN apt-get update && apt-get install -y zlib1g-dev libicu-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libmagickwand-dev \
        libmagickcore-dev \
        libpng-dev \
        libxslt1-dev \
        zip unzip \
        autoconf \
        pkg-config \
        libssl-dev \
        libzip-dev \
        ssh-client \
        --no-install-recommends

RUN apt-get update && apt-get install -y \
    git libmagick++-dev \
    --no-install-recommends && rm -r /var/lib/apt/lists/* && \
    git clone https://github.com/mkoppanen/imagick.git && \
    cd imagick && git checkout master && phpize && ./configure && \
    make && make install && \
    docker-php-ext-enable imagick && \
    cd ../ && rm -rf imagick

RUN pecl channel-update pecl.php.net \
    && docker-php-ext-install intl pdo_mysql bcmath xsl zip mysqli soap \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install pcntl && docker-php-ext-enable pcntl \
    && pecl install xdebug-2.7.0 \
    && pecl install mongodb \
    && echo "extension=mongodb.so" >> /usr/local/etc/php/conf.d/mongodb.ini \
    && docker-php-ext-enable xdebug

RUN pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis

RUN apt-get update && apt-get install -y \
    build-essential \
    vim \
    git-core

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar \
    && mv phpcs.phar /usr/local/bin/phpcs && chmod 777 /usr/local/bin/phpcs \
    && curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar \
    && mv phpcbf.phar /usr/local/bin/phpcbf && chmod 777 /usr/local/bin/phpcbf

RUN curl -LO https://deployer.org/deployer.phar && \
    mv deployer.phar /usr/local/bin/dep && \
    chmod +x /usr/local/bin/dep

RUN apt-get purge -y g++ \
    && apt-get autoremove -y \
    && rm -r /var/lib/apt/lists/* \
    && rm -rf /tmp/*
