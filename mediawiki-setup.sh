#!/bin/bash

# Unrelated to mediawiki setup; provide useful features for developers to edit
# mediawiki files in the container without installing vim themself.
apt-get -y update
apt-get -y install vim locate

# Install and run the MySQL database
DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server
service mysql start
mysql_install_db

# Set up necessary features of the database
mysql -u root -e "CREATE DATABASE my_wiki;"
mysql -u root -e "GRANT INDEX, CREATE, SELECT, INSERT, UPDATE, DELETE, ALTER, LOCK TABLES ON my_wiki.* TO 'tartan'@'localhost' IDENTIFIED BY 'password';"
mysql -u root -e "FLUSH PRIVILEGES;"

# Finally, install MediaWiki on this container
php maintenance/install.php --dbname my_wiki --dbpass password --scriptpath '' --dbserver 127.0.0.1 --dbuser tartan --dbtype mysql --installdbpass password --pass password --installdbuser tartan "mediawiki-1.29.0" "admin"
