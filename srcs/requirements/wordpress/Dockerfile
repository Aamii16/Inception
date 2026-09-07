FROM debian:12

RUN apt update

RUN apt install curl wget  php8.2 php-fpm php-mysql mariadb-client -y

RUN sed -i 's|^listen = .*|listen = 9000|'  /etc/php/8.2/fpm/pool.d/www.conf 

RUN sed -i 's|^;clear_env = yes|clear_env = no|'  /etc/php/8.2/fpm/pool.d/www.conf

RUN wget http://wordpress.org/latest.tar.gz
RUN	tar xfz latest.tar.gz
RUN	rm -rf latest.tar.gz

COPY tools/setup.sh . 

RUN chmod +x setup.sh

EXPOSE 9000

ENTRYPOINT ["./setup.sh"]


