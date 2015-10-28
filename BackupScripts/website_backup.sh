#!/bin/bash
MYSQL_PASS=""

mysqldump -u root -p$MYSQL_PASS --all-databases > ~/backup/mysql/backup.sql

cp /etc/apache2/sites-available/* ~/backup/httpd/sites-available/
sudo cp -R /var/www/* ~/backup/www/html/

tar -zcvf backup.tar.gz -C  ~/backup .

scp -r backup.tar.gz lakertech@35.58.0.108:/home/lakertech
