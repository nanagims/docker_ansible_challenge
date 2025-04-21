#!/bin/bash

# Démarrer le service SSH
service ssh start

# Démarrer nginx
service nginx start

# Garder le conteneur en vie
tail -f /dev/null
