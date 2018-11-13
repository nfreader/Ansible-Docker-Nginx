#ansible-neffy-docker
This is a horrible all-in-one solution to:
- Set up a bare VPS as a docker container host and a MariaDB server
- Configure it to host multiple websites using nginx as a reverse-proxy
- Automatically generate configuration files and SSL certificates from letsencrypt for any number of domains
- Backup website files to an S3 bucket

In layman's terms, this configures a shared-hosting -like environment, except a little more managed.

##Prerequisites
- A bare DitgitalOcean VPS with a `root` user set up that you can ssh into with a public key
- The domains you want to host on this server need their `A` record set to the IP of the core server. A `wwww` `CNAME` record is also expected (`www` will redirect to the domain without `www` because it's 2018 ffs). Letsencrypt will fail if the www record is not configured

##Puzzle Pieces
- Docker
- https://github.com/evertramos/docker-compose-letsencrypt-nginx-proxy-companion
- geerlingguy's numerous ansible playbooks

##Roles
###Core
Servers in the `core` inventory group are the root-level docker hosts:
- geerlingguy.pip
- geerlingguy.docker
- geerlingguy.firewall
- geerlingguy.security
- init
- core
- backup

####init
Installs the DigitalOcean monitoring script, configures cron.

###core
Clones `https://github.com/evertramos/docker-compose-letsencrypt-nginx-proxy-companion` and configures some settings. We're using a modified docker-compose file because we also want to spin up a MariaDB server. 

###Site
Servers in the `site` inventory will get their own special docker-compose.yml and .env copied to the `core` server. We then run those docker-compose files so that each site gets its own php-fpm-apache webserver, reverse-proxied to the primary nginx webserver.
- site
