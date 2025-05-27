
# 🏗️ Inception - Docker Infrastructure Project

> 42 Network DevOps Project — Secure, containerized LEMP stack with WordPress

---

## 📌 Objective

Inception is a system administration and Docker orchestration project. The goal is to **set up a secure, Docker-based infrastructure** that runs:

* A web server (**NGINX**)
* A PHP-based website (**WordPress**)
* A relational database (**MariaDB**)

All components run in **isolated containers**, connected via a **custom Docker network**, with **data persisting through bind-mounted volumes** and **sensitive credentials stored using Docker secrets**.

---

## 🧱 Architecture Overview

```
🌍 Browser (https://login.42.fr)
    │
    ▼ Port 443 (VM host forwarded to container)
┌────────────┐
│   NGINX    │ 🐳
│ (TLS + Proxy)
└────────────┘
      │
      ▼ FastCGI (port 9000)
┌───────────────┐
│  WordPress    │ 🐳
│ (PHP-FPM + Redis)  
└───────────────┘
      │
      ▼ TCP (port 3306)
┌───────────────┐
│   MariaDB     │ 🐳
│ (Database)    │
└───────────────┘

🔐 Secrets:
- /run/secrets/db_password
- /run/secrets/db_root_password
- /run/secrets/wp_admin_password
- /run/secrets/wp_secondary_password

🔗 Docker network: `inception`

📦 Volumes:
- /home/<user>/data/wordpress ←→ /var/www/html
- /home/<user>/data/mariadb   ←→ /var/lib/mysql
```

---

## ✅ Project Requirements Covered

* ✔️ All containers built from scratch (no DockerHub pulls)
* ✔️ All traffic secured via HTTPS (TLSv1.2 or TLSv1.3)
* ✔️ `.env` used for non-sensitive configs
* ✔️ 🔐 **Docker secrets** used for all sensitive data (passwords)
* ✔️ Persistent volumes for MariaDB and WordPress
* ✔️ Custom internal Docker network
* ✔️ Auto-restart policies for resilience
* ✔️ No `/etc/hosts` editing required
* ✔️ NGINX is the only exposed entry point (port 443)

---

## ⚙️ How to Use

### 1. 📁 Clone the repository

```bash
git clone https://github.com/yourusername/inception.git
cd inception
```

---

### 2. 🔐 Set up secrets

Create a `secrets/` folder and place one file per secret:

```bash
mkdir -p secrets

echo "superroot"         > secrets/db_root_password
echo "wp_pass"           > secrets/db_password
echo "superadminpass"    > secrets/wp_admin_password
echo "editoruserpass"    > secrets/wp_secondary_password
```

✅ Ensure `secrets/` is **ignored in Git** using `.gitignore`.

---

### 3. ⚙️ Create your `.env`

```dotenv
# WordPress DB (non-sensitive)
DB_NAME=wordpress
DB_USER=wp_user

# Site config
DOMAIN=login.42.fr
WP_TITLE=InceptionSite
WP_ADMIN=admin42
WP_ADMIN_EMAIL=admin@42.fr
WP_SECONDARY=editor42
WP_SECONDARY_EMAIL=editor@42.fr
```

---
### 6. configure your domain name to point to your local IP address.
```bash
sudo nano /etc/hosts
```

add "127.0.0.1    login.42.fr" to the hosts file and save
---

### 5. ▶️ Build & Run

```bash
make build
make up
```

---

### 6. 🌐 Access Your WordPress Site

From the VM or forwarded host:

```bash
https://login.42.fr      # Inside VM
```
🔐 Accept the self-signed TLS certificate warning in the browser.

---

## 📁 Project Structure

```
inception/
├── Makefile
├── .env
├── docker-compose.yml
├── secrets/               ← DO NOT TRACK IN GIT
│   ├── db_root_password
│   ├── db_password
│   ├── wp_admin_password
│   └── wp_secondary_password
├── srcs/
│   └── requirements/
│       ├── mariadb/
│       │   ├── Dockerfile
│       │   └── conf/
│       ├── wordpress/
│       │   ├── Dockerfile
│       │   └── conf/
│       ├── nginx/
│       │   ├── Dockerfile
│       │   └── conf/
└── README.md
```


