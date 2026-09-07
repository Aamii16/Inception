FROM debian:12

RUN apt update 

RUN apt install mariadb-server -y


COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY tools/setup.sh . 

RUN chmod +x setup.sh

EXPOSE 3306

ENTRYPOINT ["./setup.sh"]
