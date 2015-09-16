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
 chmod -R 775 cc-core/logs
 chmod -R 775 cc-content/uploads/flv
 chmod -R 775 cc-content/uploads/mobile
 chmod -R 775 cc-content/uploads/temp
 chmod -R 775 cc-content/uploads/thumbs
 chmod -R 775 cc-content/uploads/avatars
 
 sed  -i 's/upload_max_filesize = 2M/upload_max_filesize = 350M/' /etc/php5/apache2/php.ini
 sed  -i 's/post_max_size = 8M/post_max_size = 350M/' /etc/php5/apache2/php.ini
 sed  -i 's/max_execution_time = 30/max_execution_time = 1500/' /etc/php5/apache2/php.ini
 sed  -i 's/short_open_tag = Off/short_open_tag = On/' /etc/php5/apache2/php.ini
 
 sed  -i 's#$pattern = '/^https?:\/\/[a-z0-9][a-z0-9\.\-\:]+.*$/i';#$pattern = '/^https?:\/\/[a-z0-9][a-z0-9\.\-\:]+.*$/i';#' /var/www/cc-admin/settings.php
 sed  -i 's#$pattern = '/^https?:\/\/[a-z0-9][a-z0-9\.\-]*[a-z0-9\/\_\.\-]*$/i';#$pattern = '/^https?:\/\/[a-z0-9][a-z0-9\.\-\:]*[a-z0-9\/\_\.\-\:]*$/i';#' /var/www/cc-install/site-details.php
 
 #to fix error relate to ip address of container apache2
 echo "ServerName localhost" | tee /etc/apache2/conf-available/fqdn.conf
 ln -s /etc/apache2/conf-available/fqdn.conf /etc/apache2/conf-enabled/fqdn.conf
 
 a2enmod rewrite
