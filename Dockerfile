# Stage 1: Build MySQL
FROM mysql:latest as mysql_builder

# Set environment variables for MySQL
ENV MYSQL_ROOT_PASSWORD=rootpassword
ENV MYSQL_DATABASE=wordpress
ENV MYSQL_USER=wpuser
ENV MYSQL_PASSWORD=wppassword

# Stage 2: Build WordPress
FROM wordpress:latest

# Install the MySQL client to interact with the MySQL server
RUN apt-get update && apt-get install -y mysql-client && rm -rf /var/lib/apt/lists/*

# Copy MySQL configurations from the first stage
COPY --from=mysql_builder /docker-entrypoint-initdb.d /docker-entrypoint-initdb.d

# Set environment variables for WordPress to connect to the MySQL container
ENV WORDPRESS_DB_HOST=localhost
ENV WORDPRESS_DB_USER=wpuser
ENV WORDPRESS_DB_PASSWORD=wppassword
ENV WORDPRESS_DB_NAME=wordpress

# Add a sleep command to wait for MySQL to initialize
RUN sleep 10

# Start services
CMD service mysql start && /usr/sbin/apache2ctl -D FOREGROUND

# Expose the default WordPress port
EXPOSE 80
