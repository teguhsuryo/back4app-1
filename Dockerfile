# Use the official Ubuntu image as the base image
FROM ubuntu:latest

# Set environment variables to suppress interactive installation prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages (MySQL, Adminer)
RUN apt-get update && \
    apt-get install -y mysql-server adminer && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Start the Adminer service
CMD ["adminer"]

# Expose port for Adminer (default is 8080)
EXPOSE 8080
