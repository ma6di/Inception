
```markdown
# 🏗️ Inception - Docker Infrastructure Project

> 42 Network DevOps Project — Secure, containerized LEMP stack with WordPress

---

## 📌 Objective

Inception is a system administration and Docker orchestration project. The goal is to **set up a secure, Docker-based infrastructure** that runs:

- A web server (NGINX)
- A PHP-based website (WordPress)
- A relational database (MariaDB)

All components must run in **isolated containers**, connected via a **custom Docker network**, with **data persisting through bind-mounted volumes**.

---

## 🧱 Architecture Overview

```

🌍 Browser ([https://localhost:8443](https://localhost:8443))
│
▼ Port 8443 on host → Port 443 on guest VM
┌────────────┐
│   NGINX    │ 🐳
│ (Reverse Proxy)
└────────────┘
│ FastCGI 9000
▼
┌───────────────┐
│  WordPress    │ 🐳
│ (PHP-FPM)     │
└───────────────┘
│ TCP 3306
▼
┌───────────────┐
│   MariaDB     │ 🐳
│ (Database)    │
└───────────────┘

🔗 Docker network: `inception`

📦 Volumes:

* /home/username/data/wordpress ←→ /var/www/html
* /home/username/data/mariadb   ←→ /var/lib/mysql

````

---

## ✅ Project Requirements Covered

- ✔️ Containers built from scratch (no prebuilt DockerHub images)
- ✔️ HTTPS access via TLSv1.2 or TLSv1.3
- ✔️ `.env` file for secrets and configs
- ✔️ Persistent storage via bind-mounted volumes
- ✔️ Custom Docker bridge network
- ✔️ Auto-restart of containers on crash
- ✔️ No credentials hardcoded
- ✔️ No DNS modification (`/etc/hosts`)
- ✔️ All traffic flows through NGINX only

---

## ⚙️ How to Use

### 1. 📁 Clone the repo

```bash
git clone https://github.com/yourusername/inception.git
cd inception
````

---

### 2. 🔧 Configure environment

Create a `.env` file in the project root:

```dotenv
LOGIN=username
DOMAIN=username.42.fr
DB_NAME=wordpress
DB_USER=wp_user
DB_PASSWORD=wp_pass
DB_ROOT_PASSWORD=superroot
```

---

### 3. 🛠️ Configure VM Port Forwarding (📦 VirtualBox / UTM)

Forward host port `8443` to guest port `443` (used by NGINX container):

#### VirtualBox:

* Open VM settings → Network → Advanced → Port Forwarding
* Add:

  ```
  Name: https
  Protocol: TCP
  Host Port: 8443
  Guest Port: 443
  ```

#### UTM:

* Open VM config → Network → Port Forwarding
* Add rule:

  ```
  Host Port: 8443
  Guest Port: 443
  Protocol: TCP
  ```

---

### 4. ▶️ Run the Project

Use the included Makefile:

```bash
make
```

(Internally runs `docker compose up --build`.)

---

### 5. 🌐 Access the Site

- **From the host OS (e.g., Ubuntu):**
> This works because you've set up port forwarding from host `8443` → guest `443`.

```
https://localhost:8443
```

- **From inside the VM:**
> This works because inside the VM, the `nginx` container listens on port 443 and `mcheragh.42.fr` is mapped via `/etc/hosts` to `127.0.0.1`.

```
https://username.42.fr
```

> Accept the self-signed certificate warning.
> You should now see the WordPress setup screen.

---

## 📂 Project Structure

```
inception/
├── Makefile
├── .env
├── docker-compose.yml
├── srcs/
│   └── requirements/
│       ├── mariadb/
│       │   ├── Dockerfile
│       │   └── conf/
│       │       ├── entrypoint.sh
│       │       └── init.sql
│       ├── wordpress/
│       │   ├── Dockerfile
│       │   └── conf/
│       │       └── entrypoint.sh
│       ├── nginx/
│       │   ├── Dockerfile
│       │   └── conf/
│       │       ├── nginx.conf
│       │       └── ssl/
│       │           ├── server.crt
│       │           └── server.key
└── README.md
```

---

## 🔄 Project Flow Summary

1. Browser connects to `https://localhost:8443`
2. Host forwards traffic to port 443 inside the VM
3. NGINX container receives the TLS request
4. NGINX forwards PHP requests to WordPress container (via FastCGI port 9000)
5. WordPress runs PHP, connects to MariaDB (port 3306), and renders HTML
6. Response goes back to NGINX → sent to browser

