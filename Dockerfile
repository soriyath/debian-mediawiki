FROM soriyath/debian-hhvm
MAINTAINER Sumi Straessle

# Installation:
# A separate database is needed (using mysql:5.6, postgresql doesn't work)
#
# 1. docker network create mediawiki_net
# 2. docker run -it -d --net=mediawiki_net --name mediawiki_db -p 5432:5432 soriyath/debian-postgresql94
# 2. docker run -it -d --net=mediawiki_net --name mediawiki_db -p 3306:3306 -v /var/lib/mediawiki_db:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=docker -e MYSQL_DATABASE=docker -e MYSQL_USER=docker -e MYSQL_PASSWORD=docker mysql:5.6 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
# 3. docker run -it -d --net=mediawiki_net --name mediawiki -p 8080:8080 soriyath/debian-mediawiki 
# 4. Go through the creation of the wiki, provide "mediawiki_db" as the host name for the database
# 5. Get into mediawiki container and inject LocalSettings.php (chmoding 700 before) : docker exec -it mediawiki bash
# 6. Finalize installation, login and customize.

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
	&& apt-get install -y mysql-client

RUN apt-get clean \
	&& apt-get autoremove \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /srv/www
RUN wget https://releases.wikimedia.org/mediawiki/1.27/mediawiki-1.27.1.tar.gz \
	&& tar --strip-components=1 -xzf mediawiki-1.27.1.tar.gz \
	&& rm mediawiki-1.27.1.tar.gz

# default command
CMD ["supervisord", "-c", "/etc/supervisor.conf"]
