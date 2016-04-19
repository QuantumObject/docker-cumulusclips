#name of container: docker-cumulusclips
#versison of container: 0.1.1
FROM quantumobject/docker-baseimage:15.10
MAINTAINER Angel Rodriguez  "angelrr7702@gmail.com"

#add repository and update the container
#Installation of nesesary package/software for this containers...
RUN echo "deb http://archive.ubuntu.com/ubuntu `cat /etc/container_environment/DISTRIB_CODENAME`-backports main restricted " >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y -q php5 \
                    libapache2-mod-php5 \
                    apache2 \
                    php5-mysql \
                    php5-gd \
                    php5-curl \
                    python \
                    && apt-get clean \
                    && rm -rf /tmp/* /var/tmp/*  \
                    && rm -rf /var/lib/apt/lists/*

# to add apache2 deamon to runit
RUN mkdir -p /etc/service/apache2  /var/log/apache2 ; sync 
RUN mkdir /etc/service/apache2/log
COPY apache2.sh /etc/service/apache2/run
COPY apache2-log.sh /etc/service/apache2/log/run
RUN chmod +x /etc/service/apache2/run /etc/service/apache2/log/run \
    && cp /var/log/cron/config /var/log/apache2/ \
    && chown -R www-data /var/log/apache2

##startup scripts  
#Pre-config scrip that maybe need to be run one time only when the container run the first time .. using a flag to don't 
#run it again ... use for conf for service ... when run the first time ...
RUN mkdir -p /etc/my_init.d
COPY startup.sh /etc/my_init.d/startup.sh
RUN chmod +x /etc/my_init.d/startup.sh

#some configuration for apache and drupal
COPY apache2.conf /etc/apache2/apache2.conf
RUN sed  -i 's/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www/' /etc/apache2/sites-available/000-default.conf

#pre-config scritp for different service that need to be run when container image is create 
#maybe include additional software that need to be installed ... with some service running ... like example mysqld
COPY pre-conf.sh /sbin/pre-conf
RUN chmod +x /sbin/pre-conf; sync \
    && /bin/bash -c /sbin/pre-conf \
    && rm /sbin/pre-conf
    
# to allow access from outside of the container  to the container service
# at that ports need to allow access from firewall if need to access it outside of the server. 
EXPOSE 80

#creatian of volume 
VOLUME /var/www/

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
