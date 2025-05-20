# Nextcloud Docker Setup
This is a project which provides a self-contained Docker setup
for running the [Nextcloud](https://nextcloud.com/) cloud platform
with Apache, MariaDB, and PHP on Ubuntu 24.04.

---

## Features

- Nextcloud (latest from GitHub)
- Apache2 + PHP 8.3
- MariaDB (internal to same container)
- HTTPS support with self-signed certs
- Automatic Nextcloud installation and setup
- Background job fixes and recommended settings

---

## Requirements

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

---

##  How to Run

### Build and start the container
```bash
docker-compose up --build
```

Nextcloud will be accessible at [http://localhost:8080](http://localhost:8080)

For HTTPS, see nextcloud-ssl.conf and update domain and certificate paths.

---

## Default Credentials
- Admin user: admin
- Admin password: adminpass
- Database user: nextclouduser
- Database password: nextcloudpass
- Database name: nextcloud
You can change these in docker-compose.yml before building.

---

## After Setup
You may still see minor warnings in the admin panel. These can be resolved manually via the Nextcloud web UI or by customizing entrypoint.sh.

---

## Credits
Built using:
- Nextcloud
- Ubuntu
- Apache

Made with a bit of grumbling about Docker by [DsgnrFH (Oleksandr)](https://github.com/DsgnrFH/)