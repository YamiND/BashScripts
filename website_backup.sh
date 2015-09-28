#!/bin/bash
MYSQL_PASS=""

mysqldump -u root -p$MYSQL_PASS --all-databases > ~/backup/mysql/backup.sql

cp /etc/apache2/sites-enabled/* backup/apache2/
sudo cp -R /var/www/* backup/www/

tar -zcvf backup.tar.gz -C  ~/backup .

scp -r backup.tar.gz lakertech@35.58.0.104:/home/lakertech
