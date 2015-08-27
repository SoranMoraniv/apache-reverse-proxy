FROM ubuntu

MAINTAINER Hauke Mettendorf <hauke.mettendorf@iteratec.de>

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

# Update repositories and install apache and nano
# After that apt status information
RUN apt-get update && \
apt-get install -y apache2 nano && \
rm -rf /var/lib/apt/lists/*

# Set ServerName
RUN echo "ServerName localhost" >> /etc/apache2/conf-enabled/hostname.conf

# Enable mods
RUN a2enmod ssl proxy proxy_http proxy_html xml2enc rewrite usertrack

# Deactivate default sites
RUN a2dissite 000-default default-ssl

# Create certificate directories
RUN mkdir -p /etc/ssl/apache/keys && \
mkdir -p /etc/ssl/apache/certs && \
mkdir -p /etc/ssl/apache/intermediates

# Create pid directory
RUN mkdir -p /var/run/apache2

# Set permissions
RUN chmod -R 700 /etc/ssl/apache

VOLUME ["/etc/ssl/apache2", "/etc/apache2/sites-enabled", "/var/log/apache2", "/etc/apache2/authentication"]

CMD ["apache2ctl" , "-D", "FOREGROUND"]

EXPOSE 80 443