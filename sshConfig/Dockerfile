FROM debian:12

# Mise à jour + installation des paquets nécessaires
RUN apt-get update && apt-get install -y \
    python3 \
    sudo \
    openssh-server \
    nginx \
    curl \
    procps \
    net-tools \
    iproute2 \
    systemctl \
    lsb-release \
    gnupg \
    ca-certificates

# Création du user non-root
RUN adduser --disabled-password user1 && \
    adduser user1 sudo && \
    echo 'user1 ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Configuration SSH
RUN mkdir /var/run/sshd && \
    mkdir -p /home/user1/.ssh
COPY clefsssh /home/user1/.ssh/authorized_keys
RUN chown -R user1:user1 /home/user1/.ssh && \
    chmod 700 /home/user1/.ssh && \
    chmod 600 /home/user1/.ssh/authorized_keys

# Activation de Nginx
RUN systemctl enable nginx || true

# Script d’entrée
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22
CMD ["/entrypoint.sh"]
