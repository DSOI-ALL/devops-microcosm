GitHub: https://github.com/spindance-ops/sd.chef.mediawiki

#####Don't have a chef server? Ubuntu/Redhat Installer: https://raw.githubusercontent.com/spindance-ops/sd.chef.mediawiki/master/MediaWikiInstaller.bash

Containerized Mediawiki 
=======================
###Known Issues and Todos (the short list I'm sure):
* My semver usage is probably terrible. It's all a patch! 
* I don't know why I don't have exposed confs for php-fpm. An oversight worth fixing. 
* The value of node attributes is dubious at best. Somethings are hard coded, somethings are attributes. 
* Following the prior, conf files need better templatization (any templatization?). 
* I have small changes I make to the mediawiki code base to allow for auto generation of LocalSettings in the base dir. May be a security risk in one form or another. 
* Following the prior, should those changes be maintained in a mediawiki fork, or in this cookbooks files?
* Right now, docker start/stop container is your init scripts. I'd like to change this. 
* Need to create a build pipeline for releases of various versions of things. 
* Release all the docker files used to build fpm and parsoid (the fpm build is kind of opinionated at the moment). 


###What is it? 
Installing mediawiki is a bit of a pain (especially with the visual editor). The directions are sometimes unclear on which packages are required for the php compile. At the very least in a platform agnostic manner. As it stands it should work with either debian or redhat based systems that docker supports (at this very moment only tested on Centos 7.2.)

###Why it's better than the mediawiki sponsored docker setup. 
The official mediawiki docker image doesn’t really subscribe to the docker ideology. It’s all blob’d into one container. This follows the one service per container concept and is built in a way that that allows for agnostic immutable system setup. I’ll touch on this in the setup section.

Setup
=======================
There are three folders of interest, these will be configured on system initialization by chef:

```
/var/lib/mysql (Can use existing installation. See Caveat Emptor)
/var/www/mediawiki (This will be initialized only once. See Caveat Emptor)
/etc/parsoid (This I think is going to be overridden each time. Todo:fix)
```

The following is not required, just a suggestion.

So ideally your data is on designated data volumes. Our setup is such that there is a mounted data volume mounted on let’s say /app. Then you have all your folders in this folder so:

```
/app/
  mediawiki/
  mysql/
  parsoid/
```

From here, you’ll use bind mounts because docker doesn’t like symlinks. 

```
mount -o bind /app/parsoid /etc/parsoid
mount -o bind /app/mysql/ /var/lib/mysql
mount -o bind /app/mediawiki/ /var/www/mediawiki
```

This is nice, because now your system can be truly ephemeral and your data can live wherever.

Usage and Common Tasks
=======================
####Starting and Stopping Services 

docker stop CONTAINER_NAME; docker start CONTAINER_NAME

####Accessing Daemon Logs

docker logs [ -f ] CONTAINER_NAME

####Accessing a Shell

docker exec -ti CONTAINER_NAME /bin/sh

####Managing the Database

docker exec -ti mariadb mysql

Caveat Emptor
=======================
Per the usual, this is an open source project maintained by some random guy on the internet. Use at your own risk.  

###Things
The mariadb container will not reinitialize an existing mysql directory. I have not reviewed their code on how that works. I think I grabbed the latest mariadb image (drop in mysql replacement) so if you have an old mysql and use it as your base dir it may try to upgrade things. I don’t know, I have not tried it. So just be aware and use at your own risk if you’re trying to use and existing mysql install. 


Mediawiki is pulled from git using the chef git resource provider. It does a checkout and only does it once based on a set attribute. Still make backups of important things. It should go without saying. 


Requirements
------------
Chef 12+ (probably the latest chef 12 would be best)

Attributes
----------
Nope, don't use em. You can go poke a bit if you want, but it works out of the box. It'll get better in terms of customization. 

Contributing
------------
Feel free to sumbit bugs, and submit pulls. I'll try to be as engaged as possible. This is my first community project so bear with me. 

License and Authors
-------------------
Authors: Ryan Lewkowicz 
