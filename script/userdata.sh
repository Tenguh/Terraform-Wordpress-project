#!/bin/bash
# Update system
apt update -y && apt upgrade -y

# Install Apache, MySQL, PHP, and other dependencies
apt install -y apache2 mysql-server php php-mysql wget unzip

# Start and enable Apache & MySQL
systemctl start apache2
systemctl enable apache2
systemctl start mysql
systemctl enable mysql

# Secure MySQL (requires manual input if run later)
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'your-root-password';"
mysql -e "DELETE FROM mysql.user WHERE User='';"
mysql -e "DROP DATABASE IF EXISTS test;"
mysql -e "FLUSH PRIVILEGES;"

# Create WordPress database and user
mysql -u root -p'your-root-password' -e "CREATE DATABASE wordpress;"
mysql -u root -p'your-root-password' -e "CREATE USER 'wp_user'@'localhost' IDENTIFIED BY 'wp_password';"
mysql -u root -p'your-root-password' -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_user'@'localhost';"
mysql -u root -p'your-root-password' -e "FLUSH PRIVILEGES;"

# Download and configure WordPress
cd /var/www/html
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
mv wordpress/* .
rm -rf wordpress latest.tar.gz
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Configure wp-config.php
cp wp-config-sample.php wp-config.php
sed -i "s/database_name_here/wordpress/" wp-config.php
sed -i "s/username_here/wp_user/" wp-config.php
sed -i "s/password_here/wp_password/" wp-config.php

# Restart Apache
systemctl restart apache2
