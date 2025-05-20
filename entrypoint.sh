#!/bin/bash
set -e
 
service mariadb start
 
mysql -e "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;"
 
USER_EXISTS=$(mysql -sse "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = '$MYSQL_USER');")
 
if [ "$USER_EXISTS" = 1 ]; then
  mysql -e "ALTER USER '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';"
else
  mysql -e "CREATE USER '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';"
fi
 
mysql -e "GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"
 
if [ ! -f /var/www/nextcloud/config/config.php ]; then
	su -s /bin/bash www-data -c "php /var/www/nextcloud/occ maintenance:install \
  --database=\"mysql\" \
  --database-name=\"$MYSQL_DATABASE\" \
  --database-user=\"$MYSQL_USER\" \
  --database-pass=\"$MYSQL_PASSWORD\" \
  --admin-user=\"$NEXTCLOUD_ADMIN_USER\" \
  --admin-pass=\"$NEXTCLOUD_ADMIN_PASSWORD\""

fi
exec apachectl -D FOREGROUND