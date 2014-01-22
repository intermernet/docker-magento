__Dockerfile to install Magento and OpenSSH__

Currently installs Apache, MySQL, OpenSSH and Magento but does not configure Magento.

Example usage:

Build the Dockerfile:

    docker build -t docker-magento github.com/Intermernet/docker-magento

Towards the end of the output it will display the randomly generated root / MySQL password for the Docker image. Be sure to record this somewhere.

Run the image:

    docker run -d -t -i -h "host.name" -p 22 -p 80 docker-magento

To force which ports get NATed you can use something like (SSH on Docker host 2222 and HTTP on Docker host 80):

    docker run -d -t -i -h "host.name" -p 2222:22 -p 80:80 docker-magento

You should then be able to connect to the HTTP port and configure Magento. Use username `root` and the password recorded earlier to connect to the `magento` database.

Very loosely based on [dmahlow/docker-magento](https://github.com/dmahlow/docker-magento)
