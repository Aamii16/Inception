FROM debian:12

RUN apt update 

RUN apt install nginx -y && apt install openssl -y

RUN mkdir -p /etc/nginx/ssl/

RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=MA/ST=Casablanca-Settat/L=Casablanca/O=1337/OU=1337/CN=amzahir.42.fr/UID=amzahir"

COPY conf/server.conf /etc/nginx/conf.d/server.conf

EXPOSE 443

ENTRYPOINT ["nginx", "-g", "daemon off;"]
