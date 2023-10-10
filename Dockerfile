# Build webssh
FROM snsyzb/webssh

# Expose the default webssh port
EXPOSE 8080

# Use the official Ubuntu image as the base image
FROM ubuntu:latest

# Install the OpenSSH server and update the package list
RUN apt-get update && apt-get install -y openssh-server

# Create a directory for SSH server keys (optional)
RUN mkdir /var/run/sshd

# Set a root password (change 'password' to your desired password)
RUN echo 'root:password' | chpasswd

# Permit root login via SSH (for demonstration purposes, you should use SSH keys in production)
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Start the SSH server
CMD ["/usr/sbin/sshd", "-D"]
