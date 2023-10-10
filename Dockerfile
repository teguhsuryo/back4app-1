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

# Create a directory to store the webssh files
RUN mkdir /webssh

# Copy the webssh files to the container
RUN cp -r /usr/local/lib/python3.8/dist-packages/webssh/static /webssh

# Use the CMD instruction to start both SSH server and web-based SSH client
CMD ["/bin/bash", "-c", "/usr/sbin/sshd && python3 -m http.server -d /webssh 8080"]

# Expose port 8080 for the web-based SSH client
EXPOSE 8080
