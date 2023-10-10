# Use an official MySQL image as the initial build stage
FROM mysql:5.7 as mysql_stage

# Set MySQL environment variables (replace with your values)
ENV MYSQL_ROOT_PASSWORD=root_password
ENV MYSQL_DATABASE=wordpress
ENV MYSQL_USER=wordpress_user
ENV MYSQL_PASSWORD=wordpress_password

# Use an official WordPress image as the final build stage
FROM wordpress:latest

# Copy the MySQL configuration from the mysql_stage
COPY --from=mysql_stage /etc/mysql/my.cnf /etc/mysql/my.cnf
COPY --from=mysql_stage /var/lib/mysql /var/lib/mysql

# Expose port 80 for HTTP
EXPOSE 80

# Define environment variables for WordPress
ENV WORDPRESS_DB_HOST=127.0.0.1
ENV WORDPRESS_DB_USER=$MYSQL_USER
ENV WORDPRESS_DB_PASSWORD=$MYSQL_PASSWORD
ENV WORDPRESS_DB_NAME=$MYSQL_DATABASE

# Define the entry point
# CMD ["apache2-foreground"]

# Add a sleep command to wait for MySQL to initialize
RUN sleep 10

# Start services
CMD service mysql start && /usr/sbin/apache2ctl -D FOREGROUND
