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

# Use the CMD instruction to start both SSH server and web-based SSH client
CMD ["/bin/bash", "-c", "/usr/sbin/sshd && wssh --port=80"]

# Expose port 80 for the web-based SSH client
EXPOSE 80
