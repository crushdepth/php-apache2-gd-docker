## docker-php-dev ##

Function
Set up a dockerised PHP development environment:
* PHP 8.1.8 + GD support for image manipulation.
* Apache2
* Webroot is a bindmount to a working directory in your user account.

Configuration
* To change the PHP version, update the version number in the FROM line of the dockerfile
and rebuild the image:

FROM php:8.1.8-apache # Increment the version number 

* To change the location of the working directory, change the path in the volumes
section of docker-compose.yml:

volumes:
    - /home/username/www:/var/www/
  working_dir: /var/www/html

Usage
1. Build the docker-php-dev image:

Usage: sudo docker build . -t "phpdev"

2. Deploy a docker-php-dev container

Usage: docker-compose -p yourprojectname up -d 

Your new environment

1. The host machine directory /home/username/www will be mapped to /var/www in the 
container. Any files you place in the host directory will be available to the 
webserver, so you can just work from there.

2. The actual webroot is /home/username/www/html, which maps to /var/www/html in the
container. Files you want to be publicly accessible must be placed in there. (The 
value of having the non-public www directory above is as a safe haven for files you
don't want to put in the web root, such as libraries, configuration files and so on).

3. Permissions matter. The webserver container runs as the www-data user, and so the
files you place in the host directory also need to be accessible to www-data. Change
ownership to www-data like this:

sudo chown -R www-data:www-data /home/username/www

While editing files from the host machine, you will need to sudo to gain temporary
privileges. Note that any new files you create will be owned by root, so you will
need to chown them to www-data:www-data. There are probably better ways of handling
this.

4. Upgrades: You can upgrade the PHP version or edit the image configuration at
any time by modifying the dockerfile, rebuilding the image and re-deploying the
container via compose. Your data / the web root will persist as it is on a
bindmount volume, even if you delete the container.
