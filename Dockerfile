# Magento and SSH installation
#
# Currently gets to fresh installation without Magento config

# Use Ubuntu as base image
FROM ubuntu:precise

MAINTAINER Mike Hughes, intermernet@gmail.com

# Create a random password for root and MySQL
RUN  < /dev/urandom tr -dc A-Za-z0-9 | head -c${1:-12} > /root/pw.txt

# Change the root password to "toor"
RUN echo "root:$(cat /root/pw.txt)" | chpasswd

# Add Ubuntu Apt mirrors
RUN echo 'deb mirror://mirrors.ubuntu.com/mirrors.txt precise main universe multiverse' > /etc/apt/sources.list

# Update package lists
RUN apt-get update

# Add MySQL root password ("toor") to deb-conf
RUN bash -c "debconf-set-selections <<< 'mysql-server mysql-server/root_password password $(cat /root/pw.txt)'"
RUN bash -c "debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password $(cat /root/pw.txt)'"

# Install Packages
RUN apt-get install -y mysql-server mysql-client apache2 php5 php5-curl php5-mcrypt php5-gd php5-mysql openssh-server

# Create the SSHd working directory
RUN mkdir /var/run/sshd

# Enable Apache Mod Rewrite
RUN a2enmod rewrite

# Add the Apache virtual host file
# ADD https://raw.github.com/dmahlow/docker-magento/master/apache_default_vhost /etc/apache2/sites-available/default
ADD apache_default_vhost /etc/apache2/sites-available/default

# Download Magento
ADD http://www.magentocommerce.com/downloads/assets/1.8.1.0/magento-1.8.1.0.tar.gz /root/

# Download Magento sample data
# ADD http://www.magentocommerce.com/downloads/assets/1.6.1.0/magento-sample-data-1.6.1.0.tar.gz /root/

# Extract files
RUN tar xzf /root/magento-1.8.1.0.tar.gz -C /root/
# RUN tar xzf /root/magento-sample-data-1.6.1.0.tar.gz -C /root/

# Clean up gzip files
RUN rm /root/magento-*.gz

# Delete old web root
RUN rm -fr /var/www

# Move Magento to web root
RUN mv /root/magento /var/www

# Add Magento sample data
# RUN mv /root/magento-sample-data-1.6.1.0/media/* /var/www/media/

# Change owner files in web root
RUN chown www-data:www-data -R /var/www

# Create "/root/run.sh" startup script
RUN bash -c "echo -e \"\x23\x21/bin/bash\nservice apache2 start\nmysqld --log --log-error \x26\n/usr/sbin/sshd -D \x26\nwait \x24\x7b\x21\x7d\n\" > /root/run.sh"

# Change "/root/run.sh" to be executable
RUN chmod +x /root/run.sh

# Create the "magento" database
RUN (mysqld &) ; sleep 5 && mysql -u root -p$(cat /root/pw.txt) -e "CREATE DATABASE magento;" ; kill -TERM $(cat /var/run/mysqld/mysqld.pid)

# Display the password
RUN echo -e "****************\nRECORD THIS\nroot / MySQL Password:";cat /root/pw.txt;echo -e "****************"

# Set the entry point to "/root/run.sh"
ENTRYPOINT ["/root/run.sh"]

# Expose HTTP port
EXPOSE 80

# Expose SSH port
EXPOSE 22
