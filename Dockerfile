FROM php:7.0-fpm

# Install modules
RUN apt-get update && apt-get install -y zlib1g-dev libicu-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libmagickwand-dev \
        libmagickcore-dev \
        libpng12-dev \
        libxslt1-dev \
        zip unzip \
        --no-install-recommends

RUN pecl channel-update pecl.php.net \
    && docker-php-ext-install intl pdo_mysql bcmath xsl zip mysqli imagick \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && pear install PHP_CodeSniffer

RUN curl -sS https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/bin
