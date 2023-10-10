# Use the official Ubuntu image as the base image
FROM ubuntu:latest

# Set environment variables to suppress interactive installation prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install MariaDB and Adminer dependencies
RUN apt-get update && \
    apt-get install -y mariadb-server php-cli php-mysql wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a custom database, user, and password
ENV MYSQL_DATABASE=mydatabase
ENV MYSQL_USER=myuser
ENV MYSQL_PASSWORD=mypassword

# Initialize MariaDB and create the custom database
RUN mkdir -p /var/run/mysqld && chown mysql:mysql /var/run/mysqld
RUN mysqld --user=mysql --skip-networking --skip-grant-tables & \
    sleep 5 && \
    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'your_password';" > /tmp/init.sql && \
    echo "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;" >> /tmp/init.sql && \
    echo "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >> /tmp/init.sql && \
    echo "FLUSH PRIVILEGES;" >> /tmp/init.sql && \
    mysql -u root < /tmp/init.sql && \
    rm /tmp/init.sql

# Install Adminer
RUN mkdir /var/www/html/adminer && \
    wget -qO /var/www/html/adminer/index.php https://www.adminer.org/latest.php

# Expose port 8080 for Adminer (you can change the port if needed)
EXPOSE 8080

# Start MariaDB service
CMD mysqld --user=mysql && php -S 0.0.0.0:8080 -t /var/www/html/
