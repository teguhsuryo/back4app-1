# Use the official Ubuntu image as the base image
FROM ubuntu:latest

# Install required packages for OpenSSH server and Shell In A Box
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server shellinabox

# Create a directory for SSH server keys (optional)
RUN mkdir /var/run/sshd

# Set a root password (change 'password' to your desired password)
RUN echo 'root:password' | chpasswd

# Permit root login via SSH (for demonstration purposes; use SSH keys in production)
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Generate a self-signed SSL certificate for Shell In A Box (replace with your own certificate in production)
RUN openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost" -keyout /etc/shellinabox/certificate.pem -out /etc/shellinabox/certificate.pem

# Configure Shell In A Box to use the generated SSL certificate
RUN sed -i 's/--certfile \/etc\/shellinabox\/certificate.pem/--disable-ssl/g' /etc/default/shellinabox

# Expose SSH and Shell In A Box ports
EXPOSE 4200

# Start the SSH server and Shell In A Box service
CMD ["/bin/bash", "-c", "/usr/sbin/sshd && /usr/bin/shellinaboxd"]
