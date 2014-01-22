__Dockerfile to install Magento and OpenSSH__

Currently installs Apache, MySQL, OpenSSH and Magento but does not configure Magento.

Example usage:

Build the Dockerfile:

    docker build -t docker-magento github.com/Intermernet/docker-magento

Towards the end of the output it will display the randomly generated root / MySQL password for the Docker image. _*Be sure to record this somewhere!*_.

Run the image:

    docker run -d -t -i -h "host.name" -p 2222:22 -p 80:80 docker-magento

This will force the ports to be NATed as SSH on Docker host port 2222 and HTTP on Docker host port 80. *This will fail if a web server is already running on port 80 on the Docker host*.

You should then be able to connect to the HTTP port and configure Magento. Use username `root` and the password recorded earlier to connect to the `magento` database.

If the HTTP port is not NATed to port 80 on the Docker host, you may need some proxying (haproxy or nginx) to configure Magento correctly due to Magento's page rewrite rules, as well as the various `url` variables in the configuration db tables. *This is outside the scope of this README!*

You should also be able to connect to the instance via SSH using root and the password recorded earlier.

Very loosely based on [dmahlow/docker-magento](https://github.com/dmahlow/docker-magento)
