# Use the official Ubuntu image as the base image
FROM ubuntu:latest

# Install the OpenSSH server
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server

# Create a directory for SSH server keys (optional)
RUN mkdir /var/run/sshd

# Set a root password (change 'password' to your desired password)
RUN echo 'root:password' | chpasswd

# Permit root login via SSH (for demonstration purposes; use SSH keys in production)
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Install Python and pip
RUN apt-get install -y python3 python3-pip

# Install webssh
RUN pip3 install webssh

# Create a script to start the SSH server and the web-based SSH client
RUN echo -e '#!/bin/bash\n\
/usr/sbin/sshd\n\
wssh' > /start.sh && chmod +x /start.sh

# Start the SSH server and the web-based SSH client
CMD ["/start.sh"]

# Expose port 8888 for the web-based SSH client
EXPOSE 8888
