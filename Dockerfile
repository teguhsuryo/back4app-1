# Use the official Ubuntu image as the base image
FROM ubuntu:latest

# Set environment variables to suppress interactive installation prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install MySQL and Adminer dependencies
RUN apt-get update && \
    apt-get install -y mysql-server php-cli php-mysql wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Adminer
RUN mkdir /var/www/html/adminer && \
    wget -qO /var/www/html/adminer/index.php https://www.adminer.org/latest.php

# Start MySQL service
CMD /etc/init.d/mysql start && php -S 0.0.0.0:8080 -t /var/www/html/

# Expose port 8080 for Adminer (you can change the port if needed)
EXPOSE 8080
