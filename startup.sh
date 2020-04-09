#!/bin/bash


set -e
#in case Volume are empty
if [ "$(ls -A /var/www)" ]; then
    echo "mysql folder with data"    
else
    cp -Rp cumulusclips/. /var/www/
    chown -R www-data:www-data /var/www
    chmod -R 750 /var/www/cc-core/logs
    chmod -R 750 /var/www/cc-content/uploads/{h264,webm,mobile,temp,thumbs,avatars}
fi

if [ -f /etc/configured ]; then
        echo 'already configured'
else
       
        #needed to fix problem with ubuntu ... and cron 
        update-locale
        date > /etc/configured
fi
