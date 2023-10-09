# Use an official MySQL base image from Docker Hub
FROM mysql:5.7

# Optional: Set the MySQL root password (replace 'your_root_password')
ENV MYSQL_ROOT_PASSWORD=your_root_password

# Optional: Create a database during image build (replace 'your_db_name')
# ENV MYSQL_DATABASE=your_db_name

# Optional: Create a user and grant privileges (replace 'your_db_user' and 'your_db_password')
# ENV MYSQL_USER=your_db_user
# ENV MYSQL_PASSWORD=your_db_password

# Expose port 3306 for MySQL connections
EXPOSE 3306

# Optionally, you can copy SQL scripts to initialize the database
# COPY ./init.sql /docker-entrypoint-initdb.d/

# CMD ["mysqld"]
