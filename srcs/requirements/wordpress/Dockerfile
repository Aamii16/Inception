FROM debian:12

RUN apt update

RUN apt install curl wget  php8.2 php-fpm php-mysql mariadb-client -y

RUN sed -i 's|^listen = .*|listen = 9000|'  /etc/php/8.2/fpm/pool.d/www.conf 

RUN sed -i 's|^;clear_env = yes|clear_env = no|'  /etc/php/8.2/fpm/pool.d/www.conf

RUN curl -o wordpress.tar.gz https://wordpress.org/latest.tar.gz \
    && tar -xzf wordpress.tar.gz \
    && rm wordpress.tar.gz

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp
    
COPY tools/setup.sh . 

RUN chmod +x setup.sh

EXPOSE 9000

ENTRYPOINT ["./setup.sh"]


