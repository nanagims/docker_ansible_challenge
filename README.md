##  Objectif

Ce projet a pour but de démontrer ma compréhension des mécanismes de déploiement automatisé via Docker, Ansible et GitLab CI. Il met en œuvre :
- Un container SSH basé sur Debian 12
- Un container Ansible basé sur AlmaLinux 9
- Une automatisation du déploiement d’un serveur Nginx via Ansible
- Une pipeline CI/CD GitLab pour reproduire le processus

---

## Étapes techniques

### 1. SSH Server Docker (Debian 12)
- Dockerfile configurant `openssh-server`, un utilisateur non-root avec `sudo` sans mot de passe.
- Configuration du serveur SSH sécurisée (clé publique, port, etc.)
- Démarrage avec `docker-compose`.
- Pour pouvoir acceder au serveur ssh 
   * il faut generer une paire de clef ssh a partir de son pc ensuite ajouter la la clé publique dans le fichier ./sshConfig/clefsssh 
   * ensuite mettre la clef prive dans le fichier ./ansibleServer/id_rsa
 Sécurisation :
- Utilisation d’un utilisateur non-root
- Désactivation du login root
- Authentification par clé SSH uniquement

### 2. Ansible Controller Docker (AlmaLinux 9)
- Dockerfile installant `ansible` via `dnf`
- Configuration `ansible.cfg` pour désactiver la vérification de clé SSH et simplifier les tests
- Ajout du fichier `hosts` avec le nom du container `ssh_server`

 Bonne pratique :
- Ansible lancé depuis un container dédié, isolant l’environnement de contrôle

### 3. Playbook Ansible pour Nginx
- Création d’un playbook et d’un rôle minimal pour :
  - Installer `nginx`
  - S'assurer que le service est démarré
  - Ouvrir le port 80
- Test avec `curl` depuis le container Ansible vers `ssh_server`

 Performance :
- Utilisation d’un rôle modulaire pour rendre le playbook réutilisable
- Exécution en mode `--check` pour éviter des changements inutiles

### 4. GitLab CI/CD (Bonus)
- Pipeline découpée en jobs :
  - `build` des images
  - `deploy` via `docker-compose`
  - `install` via Ansible
  - `test` via `curl`

 Variables et runners :
- Utilisation de runners Docker
- Mise en cache d’images entre les jobs pour accélérer la CI

---

## Réflexion personnelle

J’ai choisi d'isoler les rôles dans Ansible et de privilégier la sécurité même dans un environnement local. Cela me permettra facilement d'étendre ce projet vers un environnement cloud ou clusterisé.

Je n'ai pas pu finaliser tous les tests (ex: DNS, reverse proxy, monitoring), mais j’ai documenté mes intentions et fourni un setup prêt à évoluer.

---

## ▶ Pour exécuter

```bash
docker-compose up --build