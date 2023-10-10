FROM ubuntu:latest

# Install MariaDB
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y mariadb-server mariadb-client

# Set root password for MariaDB
RUN echo "UPDATE mysql.user SET authentication_string=PASSWORD('root') WHERE User='root'; FLUSH PRIVILEGES;" | mysql -u root

# Install PHP and required extensions
RUN apt-get install -y php php-mysql php-gd php-zip php-mbstring

# Download and extract Adminer
RUN mkdir /var/www && \
    cd /var/www && \
    curl -LJO https://github.com/vrana/adminer/releases/latest/download/adminer-latest.php && \
    mv adminer-latest.php adminer.php

# Expose port 8080 for Adminer
EXPOSE 8080

# Start MariaDB server and run Adminer
CMD service mysql start && php -S 0.0.0.0:8080 -t /var/www
