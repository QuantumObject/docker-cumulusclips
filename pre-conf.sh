#!/bin/bash
 
 rm -R /var/www/html

 wget http://cumulusclips.org/cumulusclips.tar.gz
 tar -zxvf cumulusclips.tar.gz
 rm cumulusclips.tar.gz
 mv cumulusclips/*  /var/www
 rm -R cumulusclips
 
 cd /var/www
 chown -R www-data:www-data /var/www/

#required by cumulusclip site to be 777 but that is bad idea. 
 chmod -R 755 cc-core/logs
 chmod -R 755 cc-content/uploads/flv
 chmod -R 755 cc-content/uploads/mobile
 chmod -R 755 cc-content/uploads/temp
 chmod -R 755 cc-content/uploads/thumbs
 chmod -R 755 cc-content/uploads/avatars
 
 #to fix error relate to ip address of container apache2
 echo "ServerName localhost" | tee /etc/apache2/conf-available/fqdn.conf
 ln -s /etc/apache2/conf-available/fqdn.conf /etc/apache2/conf-enabled/fqdn.conf
 
 a2enmod rewrite
