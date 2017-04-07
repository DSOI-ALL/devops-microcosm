#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
python -mplatform | grep -qvi 'Ubuntu\|debian' && sudo yum groupinstall -y "Development tools"&&yum install -y git curl
python -mplatform | grep -qi 'Ubuntu\|debian' && sudo apt-get update && sudo apt-get install -y build-essential git curl
export PATH=/opt/chef/embedded/bin:$PATH
curl -L https://omnitruck.chef.io/install.sh | sudo bash -s -- -v 12.12.15
mkdir /cookbooks
cd /cookbooks
knife cookbook site download mediawiki
tar -xzf mediawiki*
cd mediawiki 
bundle install
$(find /opt/chef/embedded/lib/ruby/gems/ | grep bin | grep berks$ | head -1) vendor /cookbooks
chef-client --local-mode -o recipe['mediawiki']



