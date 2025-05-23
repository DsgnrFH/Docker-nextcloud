FROM ubuntu:24.04


RUN mkdir /var/www

RUN apt update && apt install -y ca-certificates
RUN apt install -y apache2 libapache2-mod-php php php-cli php-mysql php-gd php-curl \
    php-mbstring php-zip php-intl php-imagick php-bcmath php-gmp php-fileinfo php-xml \
    mariadb-server git wget unzip

RUN a2enmod rewrite headers env dir mime && \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf

COPY nextcloud.conf /etc/apache2/sites-available/nextcloud.conf
RUN a2ensite nextcloud.conf
RUN a2dissite 000-default.conf

RUN git clone https://github.com/nextcloud/server.git /var/www/nextcloud --depth 1
RUN cd /var/www/nextcloud && git submodule update --init

RUN chown -R www-data:www-data /var/www/nextcloud

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY 99-nextcloud.ini /etc/php/8.3/apache2/conf.d/99-nextcloud.ini
RUN chmod 777 /etc/php/8.3/apache2/conf.d/99-nextcloud.ini

# SSL cert
# Please fill in your information
RUN apt install -y openssl
RUN mkdir -p /etc/ssl/private /etc/ssl/certs && \
    openssl req -x509 -nodes -days 365 \
    -subj "/C=US/ST=State/L=City/O=Organisation/OU=Unit/CN=localhost" \
    -newkey rsa:2048 \
    -keyout /etc/ssl/private/nextcloud-selfsigned.key \
    -out /etc/ssl/certs/nextcloud-selfsigned.crt
RUN a2enmod ssl

COPY nextcloud-ssl.conf /etc/apache2/sites-available/nextcloud-ssl.conf
RUN a2ensite nextcloud-ssl.conf

EXPOSE 80 443
ENTRYPOINT ["/entrypoint.sh"]