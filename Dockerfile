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

# Expose SSH port (default is 22) and the port for the web-based SSH client (e.g., 8080)
# EXPOSE 22
EXPOSE 8080

# Start the SSH server and the web-based SSH client
CMD ["/usr/sbin/sshd", "-D"]
