# Use the official Ubuntu image as the base image
FROM ubuntu:latest

# Set environment variables to suppress interactive installation prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages (MySQL, Apache, PHP)
RUN apt-get update && \
    apt-get install -y mysql-server apache2 php libapache2-mod-php && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Adminer
RUN mkdir /var/www/html/adminer && \
    curl -L https://www.adminer.org/latest.php -o /var/www/html/adminer/index.php

# Configure Apache to serve Adminer
RUN echo "Alias /adminer /var/www/html/adminer" >> /etc/apache2/apache2.conf && \
    echo "<Directory /var/www/html/adminer>" >> /etc/apache2/apache2.conf && \
    echo "  AllowOverride All" >> /etc/apache2/apache2.conf && \
    echo "</Directory>" >> /etc/apache2/apache2.conf


# Start Apache and MySQL services
CMD ["/bin/bash", "-c", "/etc/init.d/mysql start && /usr/sbin/apache2ctl -D FOREGROUND"]

# Expose ports for Apache (HTTP) and MySQL
EXPOSE 80
