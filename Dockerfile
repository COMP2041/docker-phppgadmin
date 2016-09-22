FROM debian:jessie
# mostly courtesy zhajor/docker-postgresql-9.4-phppgadmin
ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_AU.UTF-8 

RUN apt-get update &&\
	apt-get install -y --no-install-recommends \
		wget unzip locales  ca-certificates \
		apache2 libapache2-mod-php5 php5 php5-pgsql postgresql-9.4 postgresql-client-9.4 postgresql-contrib  &&\
	localedef -i en_AU -c -f UTF-8 -A /usr/share/locale/locale.alias en_AU.UTF-8 &&\
    echo "Australia/Sydney" > /etc/timezone &&\
    dpkg-reconfigure tzdata &&\
    rm -rf /var/lib/apt/lists/*

RUN ln -sf /dev/stdout /var/log/apache2/access.log &&\
	ln -sf /dev/stderr /var/log/apache2/error.log &&\
	cd /var/www/html/ &&\
	wget -q http://github.com/phppgadmin/phppgadmin/archive/master.zip &&\
	unzip -o master.zip &&\
	rm master.zip  &&\
	mv phppgadmin-master/* .  &&\
	mv conf/config.inc.php-dist conf/config.inc.php &&\
	sed -i "s/\$conf\['extra_login_security'\] = true;/\$conf\['extra_login_security'\] = false;/g" conf/config.inc.php &&\
	sed -i "s/\$conf\['servers'\]\[0\]\['host'\] = '';/\$conf\['servers'\]\[0\]\['host'\] = 'localhost';/g" conf/config.inc.php
	
EXPOSE 80

CMD [/usr/sbin/apache2ctl -D FOREGROUND"]