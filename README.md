__Dockerfile to install Magento and OpenSSH__

Currently installs Apache, MySQL, OpenSSH and Magento but does not configure Magento.

Usage:
    docker build -t docker-magento github.com/Intermernet/docker-magento
    docker run -d -t -i -h "*host.name*" -p 22 -p 80 docker-magento

Loosely based on [dmahlow/docker-magento](https://github.com/dmahlow/docker-magento)

