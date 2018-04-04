#!/bin/bash

# Copy the mediawiki setup script to the somewiki container (found in docker-compose.yml)
docker cp mediawiki-setup.sh somewiki:/var/www/html
echo "Copied mediawiki-setup.sh to 'somewiki' docker container"

# Provide permissions to run the mediawiki install script on the container
docker exec --user root somewiki bash chmod +x mediawiki-setup.sh
echo "Gave permission to 'somewiki' docker container to run mediawiki-setup.sh script"

# Execute the mediawiki installation script
docker exec --user root somewiki ./mediawiki-setup.sh
echo "Finishing installing MediaWiki on 'somewiki' docker container"
