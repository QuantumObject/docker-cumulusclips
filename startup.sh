#!/bin/bash


set -e

if [ -f /etc/configured ]; then
        echo 'already configured'
else
       
        #needed to fix problem with ubuntu ... and cron 
        update-locale
        date > /etc/configured
fi
