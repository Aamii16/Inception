FROM debian:12

RUN apt update && apt install -y \
    php8.2 \
    php-mysql \
    wget \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www

RUN wget https://github.com/vrana/adminer/releases/download/v5.4.2/adminer-5.4.2.php -O index.php

RUN chown -R root:root /var/www/

EXPOSE 8080

ENTRYPOINT ["php8.2", "-S", "0.0.0.0:8080", "-t", "/var/www"]