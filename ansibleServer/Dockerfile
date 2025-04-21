FROM almalinux:9

# 1. Mise à jour et installation minimale
RUN dnf update -y && \
    dnf install -y epel-release python3 python3-pip openssh-clients sudo bind-utils && \
    dnf clean all

# 2. Installation d'Ansible sans cache
RUN pip3 install --no-cache-dir ansible

# 3. Configuration sécurisée SSH
RUN mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh

COPY id_rsa /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa && \
    echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    echo "UserKnownHostsFile /dev/null" >> /etc/ssh/ssh_config

# 4. Configuration Ansible
RUN mkdir -p /etc/ansible && \
    echo -e "[defaults]\nhost_key_checking = False\nprivate_key_file = /root/.ssh/id_rsa" > /etc/ansible/ansible.cfg && \
    chmod 644 /etc/ansible/ansible.cfg

# 5. Copie des fichiers (en deux étapes pour meilleure gestion du cache)
COPY inventory /etc/ansible/hosts
COPY playbook.yml /ansible/
COPY roles /ansible/roles

COPY ansible.cfg /ansible/ansible.cfg



# 6. Environnement de travail
WORKDIR /ansible

# 7. Commande par défaut
CMD ["/bin/bash", "-c", "while true; do sleep 1; done"]