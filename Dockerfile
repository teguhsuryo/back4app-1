# Stage 1: Build MySQL image
FROM mysql:5.7 as mysql_stage

# Set MySQL environment variables (replace with your values)
ENV MYSQL_ROOT_PASSWORD=root_password
ENV MYSQL_DATABASE=wordpress
ENV MYSQL_USER=wordpress_user
ENV MYSQL_PASSWORD=wordpress_password

# Stage 2: Build WordPress image
FROM wordpress:latest

# Expose port 80 for HTTP
EXPOSE 80

# Set environment variables for WordPress
ENV WORDPRESS_DB_HOST=mysql_stage
ENV WORDPRESS_DB_USER=$MYSQL_USER
ENV WORDPRESS_DB_PASSWORD=$MYSQL_PASSWORD
ENV WORDPRESS_DB_NAME=$MYSQL_DATABASE

# Copy MySQL configuration from the mysql_stage
COPY --from=mysql_stage /etc/mysql/my.cnf /etc/mysql/my.cnf
COPY --from=mysql_stage /var/lib/mysql /var/lib/mysql

# Define the entry point
CMD ["apache2-foreground"]
