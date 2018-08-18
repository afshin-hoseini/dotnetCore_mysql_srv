#!/bin/bash

dbRootPass="${LGV_DB_ROOT_PASS:-root}"
currentDbRootPass="${LGV_DB_ROOT_CUR_PASS:-root}"

#Removes the repo config file if exists
[ -f /repo.cnf ] && rm /repo.cnf

#Starts up the the services
echo -e "----> Starting up services\n"
service mysql start
service nginx start
service php7.0-fpm start

#Saves the database root user's password
echo "LGV_DB_ROOT_PASS=${dbRootPass}" >> /repo.cnf

#Changes the database password if requested. This must get done after that mysql service is started.
if [ "$dbRootPass" != "" ]; then
    echo "CREATE USER 'master'@'localhost' IDENTIFIED BY '$dbRootPass'; GRANT ALL PRIVILEGES ON *.* TO 'master'@'localhost'; FLUSH PRIVILEGES;" | mysql -uroot --password="${currentDbRootPass}"

"ALTER USER 'root'@'localhost' IDENTIFIED BY '';"
fi

#Changes the ownership to www-data
#chown -R www-data /var/www/html/app
#chown www-data /var/www/html/web_hook.sh

if [ -d /var/www/data ]; then
    chown -R www-data /var/www/data
fi

echo -e "**** SERVER STARTED SUCCESSFULLY ****"

tail -f /dev/null
