# PHP 5.6 Oracle Legacy

Legacy PHP 5.6 FPM container with Oracle Instant Client 11.2 and OCI8 support.

This image is intended for legacy web applications that still require:

- PHP 5.6
- Oracle Database
- OCI8
- Redis
- MySQL/MariaDB
- GD Extension

The container is designed to be deployed behind a modern reverse proxy such as:

- Nginx
- Coraza WAF
- Naxsi
- CrowdSec
- BunkerWeb

---

# Features

- PHP 5.6 FPM
- Debian Stretch base
- Oracle Instant Client 11.2
- OCI8 2.0.12
- Redis Extension
- MySQL Extension
- PDO MySQL
- GD Extension
- mbstring
- zip
- exif
- curl

---

# Base Image

```dockerfile
FROM php:5.6-fpm-stretch
```

---

# Installed Extensions

## PHP Extensions

- gd
- mysqli
- mysql
- pdo
- pdo_mysql
- mbstring
- zip
- exif
- dom
- curl
- oci8
- redis

---

# Oracle Information

## Oracle Instant Client

- Version: 11.2.0.4.0

## OCI8

- Version: 2.0.12

---

# Redis Information

## Redis PECL Extension

- Version: 4.3.0

---

# Build Image

```bash
docker build -t atmaluhur/php56-oracle:webkampus-v1 .
```

---

# Run Container

```bash
docker run -d \
  --name php56 \
  atmaluhur/php56-oracle:webkampus-v1
```

---

# Test OCI8

```bash
docker exec -it php56 bash
```

```bash
php --ri oci8
```

---

# Test Redis

```bash
php --ri redis
```

---

# Example docker-compose.yml

```yaml
services:
  php56:
    image: atmaluhur/php56-oracle:latest
    container_name: php56
    restart: unless-stopped

    volumes:
      - ./web:/var/www/html
      - ./custom.ini:/usr/local/etc/php/conf.d/custom.ini

    ports:
      - "9000:9000"
```

---

# Example custom.ini

```ini
date.timezone = Asia/Jakarta

memory_limit = 512M
upload_max_filesize = 100M
post_max_size = 100M
max_execution_time = 300

display_errors = Off
log_errors = On

cgi.fix_pathinfo = 0

expose_php = Off
session.cookie_httponly = 1
```

---

# Security Notes

This image contains legacy software and should NOT be exposed directly to the internet.

Recommended deployment architecture:

```text
Internet
   ↓
Modern Nginx / WAF
   ↓
PHP 5.6 OCI Container
```

Recommended protections:

- Reverse Proxy
- WAF
- Rate Limiting
- Internal Docker Network
- Non-public PHP-FPM Port

---

# Important Notes

This container uses archived Debian Stretch repositories.

The environment is intended to be:

- stable
- reproducible
- frozen

Avoid unnecessary upgrades or frequent rebuilds.

---

# Repository

GitHub:

```text
https://github.com/terserah/php56-oracle
```

DockerHub:

```text
docker.io/atmaluhur/php56-oracle
```

---

# Maintainer

Rezky Yuranda
