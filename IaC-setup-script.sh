#!/bin/bash

# Install the docker-compose plugin for vagrant
vagrant plugin install vagrant-docker-compose
vagrant plugin install vagrant-scp

# Bring up docker-compose and staging VMs
vagrant up docker-compose staging

# Required to copy both of these files; explained in documentation
vagrant scp mediawiki-setup.sh docker-compose:~/
vagrant scp copy-to-mediawiki.sh docker-compose:~/

# Execute one of the above copied scripts on the docker-compose VM
# to copy the mediawiki install script onto its respective container.
vagrant ssh docker-compose -c "bash copy-to-mediawiki.sh"
