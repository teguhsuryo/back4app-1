FROM ubuntu:latest

# Install MySQL server and client
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server mysql-client

# Set root password for MySQL
RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections && \
    echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections

# Install PHP and required extensions
RUN apt-get install -y php php-mysql php-gd php-zip php-mbstring

# Download and extract Adminer
RUN mkdir /var/www && \
    cd /var/www && \
    curl -LJO https://github.com/vrana/adminer/releases/latest/download/adminer-latest.php && \
    mv adminer-latest.php adminer.php

# Start MySQL server and run Adminer
CMD service mysql start && php -S 0.0.0.0:8080 -t /var/www

# Expose port 8080 for Adminer
EXPOSE 8080
