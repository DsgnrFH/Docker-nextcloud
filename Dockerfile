FROM ubuntu:24.04


RUN mkdir /var/www

RUN apt update
RUN apt install -y apache2 libapache2-mod-php php php-cli php-mysql php-gd php-curl \
    php-mbstring php-zip php-intl php-imagick php-bcmath php-gmp php-fileinfo php-xml \
    mariadb-server
RUN apt install git -y
RUN apt install wget -y
RUN apt update && apt install -y unzip

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

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]