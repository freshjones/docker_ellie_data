#Set the base image to debian
FROM debian:jessie

#File Author / Maintainer
MAINTAINER William Jones <billy@freshjones.com>

ENV TERM=xterm

#Update the repository sources list
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    curl \
    nano \
    git \
    supervisor

#install php fpm
RUN apt-get -y install -y \
    php5-fpm \
    php5-mcrypt

#php-fpm config
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini && \
    sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php5/fpm/php.ini && \
    sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php5/fpm/php.ini && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf && \
    sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php5/fpm/pool.d/www.conf

#Install composer
RUN curl -sS https://getcomposer.org/installer | php && \
mv composer.phar /usr/local/bin/composer

#copy supervisor conf
COPY supervisor/supervisor.conf /etc/supervisor/conf.d/supervisord.conf

#Create log directories
RUN mkdir -p /var/log/supervisor

#clone in the app
RUN git clone https://github.com/freshjones/ellie_webapp.git /app/laravel

#install scripts
ADD scripts/ /scripts/

#run install script
RUN chmod +x /scripts/*.sh

#run laravel install
RUN /bin/bash /scripts/composer_install.sh

# clean apt cache
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

VOLUME ["/app/laravel"]

CMD ["/bin/sh"]
