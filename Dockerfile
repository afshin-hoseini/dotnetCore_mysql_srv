From microsoft/dotnet:2.1-sdk

Run apt-get update
Run apt-get upgrade -y

#Set time zone
RUN apt-get -y install tzdata
Run ln -sf /usr/share/zoneinfo/UTC /etc/localtime


# ------ Mariadb installation --------

RUN {\

		echo mariadb-server-10.2 mysql-server/root_password password 'root'; \
		echo mariadb-server-10.2 mysql-server/root_password_again password 'root'; \
	} | debconf-set-selections &&\
	apt-get install software-properties-common -y &&\
	apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8 &&\
	add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://mariadb.mirrors.ovh.net/MariaDB/repo/10.2/ubuntu xenial main' &&\
	apt-get install mariadb-server -y

RUN mysql --version

#--------Mariandb Installation Finish ------------




#-------------Install nginx and copy config file----------------
Run apt-get install -y nginx 


#Remove nginx default file if exists
Run rm /etc/nginx/sites-available/default


#Copy nginx default file from ./Nginx/default to image
Copy Nginx/default /etc/nginx/sites-available/default
#-------------Nginx finish------------------




#installs php and extensions

RUN apt-get install php7.0 -y
RUN apt-get install php7.0-fpm
RUN apt-get install php-mysql -y


# -------- PhpMyAdmin installation ---------
RUN {\
		echo phpmyadmin phpmyadmin/dbconfig-install boolean true; \
		echo phpmyadmin phpmyadmin/app-password-confirm password 'root'; \
		echo phpmyadmin phpmyadmin/mysql/admin-pass password 'root'; \
		echo phpmyadmin phpmyadmin/mysql/app-pass password 'root'; \
		echo phpmyadmin phpmyadmin/reconfigure-webserver multiselect none; \
	} | debconf-set-selections &&\
	apt-get install wget &&\
	cd /var/www/html &&\
	wget https://files.phpmyadmin.net/phpMyAdmin/4.7.7/phpMyAdmin-4.7.7-english.tar.gz &&\
	tar xvzf phpMyAdmin-4.7.7-english.tar.gz &&\
	mv phpMyAdmin-4.7.7-english phpmyadmin &&\
	rm phpMyAdmin-4.7.7-english.tar.gz

#----------phpmyadmin finish



#install unzip
Run apt-get install unzip


COPY entrypoint.sh /bin/entrypoint.sh

RUN chmod +x /bin/entrypoint.sh
RUN sed -i -e 's/\r$//' /bin/entrypoint.sh



#change application permission
ENV HOME=/home/app
RUN mkdir -p $HOME

RUN groupadd -r app &&\
    useradd -r -g app -d $HOME -s /sbin/nologin -c "Docker image user" app

RUN chown -R app:app $HOME

CMD ["/bin/entrypoint.sh"]
