# Nginx + HHVM docker container
[![Circle CI](https://circleci.com/gh/million12/docker-nginx-hhvm.svg?style=svg)](https://circleci.com/gh/million12/docker-nginx-hhvm)

This is a [million12/nginx-hhvm](https://registry.hub.docker.com/u/million12/nginx-hhvm/) docker image with Nginx and HHVM.

Things included:

##### - HHVM

HHVM version 3.6-dev (the next LTS - long term support) build from the source, on CentOS-7. Note: if you want to build it on your own, it takes a while... (hour(s)).

HHVM server is up & running and it's configured for default vhost. As soon as .php (or .hh) file is requested, the request will be redirected to HHVM upstream. See [/etc/nginx/conf.d/php-location.conf](container-files/etc/nginx/conf.d/php-location.conf).

File [/etc/nginx/fastcgi_params](container-files/etc/nginx/fastcgi_params) has improved configuration to avoid repeating same config options for each vhost. This config works well with most PHP applications (e.g. Symfony2, TYPO3, Flow, Neos, Wordpress, Drupal etc).

Custom PHP.ini settings are inside [/etc/hhvm/php.ini](container-files/etc/hhvm/php.ini).

##### - HHVM as PHP CLI

There's a handy script ([/usr/local/bin/php](container-files/usr/local/bin/php)) which gives you `php` command.

Custom PHP.ini settings for CLI mode are inside [/etc/hhvm/php-cli.ini](container-files/etc/hhvm/php-cli.ini).

##### - directory structure
```
/data/www # meant to contain web content
/data/www/default # default vhost directory
/data/logs/ # Nginx, PHP logs
```

##### - default vhost

Default vhost is configured and served from `/data/www/default`. Add .php|.hh file to that location to have it executed with HHVM.

##### - error logging

See `/data/logs/`.


## Usage

```
docker run -d -v /data --name=web-data busybox
docker run -d --volumes-from=web-data -p=80:80 --name=hhvm million12/nginx-hhvm
```

After that you can see the default vhost content (something like: '*default vhost created on [timestamp]*') when you open http://CONTAINER_IP:PORT/ in the browser.

Currently HHVM doesn't output anything useful for phpinfo(). To see **HHVM configuration**, you can use [hhvminfo script](http://tiny.cc/hhvminfo). Enter to the running HHVM container (`docker exec -ti CONTAINER_NAME /bin/bash`), run `curl -sSL http://tiny.cc/hhvminfo -o /data/www/default/hhvminfo.php` and then browse http://CONTAINER_IP:PORT/hhvminfo.php .


## Customise

There are several ways to customise this container, both in a runtime or when building new image on top of it:

* See [million12:nginx](https://github.com/million12/docker-nginx) for info regarding Nginx customisation, adding new vhosts etc.
* Override `/etc/nginx/fastcgi_params` if needed.
* Add custom PHP config values to `/etc/hhvm/php.ini` or `/etc/hhvm/php-cli.ini`.


## Authors

Author: ryzy (<marcin@m12.io>)  
Author: pozgo (<linux@ozgo.info>)

---

**Sponsored by** [Typostrap.io - the new prototyping tool](http://typostrap.io/) for building highly-interactive prototypes of your website or web app. Built on top of TYPO3 Neos CMS and Zurb Foundation framework.
