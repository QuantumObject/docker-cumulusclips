#!/bin/bash
 
 rm -R /var/www/html

 wget http://cumulusclips.org/cumulusclips.tar.gz
 tar -zxvf cumulusclips.tar.gz
 rm cumulusclips.tar.gz
 mv cumulusclips/* cumulusclips/.htaccess /var/www
 rm -R cumulusclips
 
 cd /var/www
 chown -R www-data:www-data /var/www/

#required by cumulusclip site to be 777 but that is bad idea. 
 chmod -R 775 cc-core/logs
 chmod -R 775 cc-content/uploads/h264
 chmod -R 775 cc-content/uploads/webm
 chmod -R 775 cc-content/uploads/mobile
 chmod -R 775 cc-content/uploads/temp
 chmod -R 775 cc-content/uploads/thumbs
 chmod -R 775 cc-content/uploads/avatars
 
 sed  -i 's/upload_max_filesize = 2M/upload_max_filesize = 350M/' /etc/php/7.0/apache2/php.ini
 sed  -i 's/post_max_size = 8M/post_max_size = 350M/' /etc/php/7.0/apache2/php.ini
 sed  -i 's/max_execution_time = 30/max_execution_time = 1500/' /etc/php/7.0/apache2/php.ini
 sed  -i 's/short_open_tag = Off/short_open_tag = On/' /etc/php/7.0/apache2/php.ini
 
 #to fix error relate to ip address of container apache2
 echo "ServerName localhost" | tee /etc/apache2/conf-available/fqdn.conf
 ln -s /etc/apache2/conf-available/fqdn.conf /etc/apache2/conf-enabled/fqdn.conf
 
 a2enmod rewrite
