# Use the official Ubuntu image as the base image
FROM ubuntu:latest

# Set environment variables to suppress interactive installation prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install MariaDB and Adminer dependencies
RUN apt-get update && \
    apt-get install -y mariadb-server php-cli php-mysql wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set up MariaDB root password
ENV MYSQL_ROOT_PASSWORD=rootpassword

# Create a custom database, user, and password
ENV MYSQL_DATABASE=mydatabase
ENV MYSQL_USER=myuser
ENV MYSQL_PASSWORD=mypassword

# Initialize MariaDB and create the custom database
RUN mkdir -p /var/run/mysqld && chown mysql:mysql /var/run/mysqld
RUN mysqld --user=mysql --initialize-insecure --skip-networking && \
    mysqld --user=mysql --skip-networking & \
    sleep 5 && \
    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';" && \
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;" && \
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" && \
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"

# Install Adminer
RUN mkdir /var/www/html/adminer && \
    wget -qO /var/www/html/adminer/index.php https://www.adminer.org/latest.php

# Expose port 8080 for Adminer (you can change the port if needed)
EXPOSE 8080

# Start MariaDB service
CMD mysqld --user=mysql && php -S 0.0.0.0:8080 -t /var/www/html/
