# php-apache2-gd-docker

**Function**

Set up a local dockerised PHP environment:
* Apache2 webserver.
* PHP 8.1.8 + GD library support for image manipulation.
* Webroot is a bindmount to a working directory on the host machine.

Please note this is not intended for public facing / production use, as it does not support SSL (to do that properly, you need to put an NGINX reverse proxy on the host machine in front of the container to terminate SSL, which allows you to run the container as a non-root user).

**Configuration**

You must edit **docker-compose.yml** to specify the name of your user account. 

```/home/yourUserName/www:/var/www/ # change the account name to your own```

You can also change the location of the bindmounted webserver volume here by specifying a different path (preserve the indentation as it is important; note that a leading dash has been ommitted here because of a markdown conflict). 

Similarly, you can change the location of the working directory by specifying a different path in docker-compose.yml:

```working_dir: /var/www/html```

To change the PHP version, update the version number in the FROM line in the **dockerfile** and rebuild the image:

```FROM php:8.1.8-apache # Increment the version number as per valid image on dockerhub```
  
**Usage**

Run the following commands **from within the docker-php-dev directory**:

1. Build the php-dev image:

```sudo docker build . -t "phpdev"```

2. Deploy a php-dev container

```docker-compose -p yourprojectname up -d```

**Your new environment**

The host machine directory /home/yourUserName/www will be mapped to /var/www in the webserver container. Any files you place in the host directory will be available to the webserver, so you can just work from there.

The actual webroot is /home/username/www/html, which maps to /var/www/html in the container. Files you want to be publicly accessible must be placed in there. (The value of having the non-public www directory above is as a safe haven for files you don't want to put in the web root, such as libraries, configuration files and so on).

Permissions matter. The webserver container runs as the www-data user, and so the files you place in the host directory also need to be accessible to www-data. Change ownership to www-data like this:

```sudo chown -R www-data:www-data /home/username/www```

While editing files from the host machine, you will need to sudo to gain temporary privileges. Note that any new files you create will be owned by root, so you will need to chown them to www-data:www-data. Probably better ways of handling this, but I haven't got around to finding one.

**Upgrades**

You can upgrade the PHP version or edit the image configuration at any time by modifying the dockerfile, rebuilding the image and re-deploying the container via compose as above. Your data will persist even if you delete the container, as it is on a discrete bindmount volumer.
