#!/bin/bash -x
# For Tomcat AMI from marketplace | Linux/Unix, Ubuntu 16.04 | 64-bit (x86) Amazon Machine Image (AMI)
# Debug with logs at /var/log/cloud-init-output.log
# TODO "When a user data script is processed, it is copied to and executed from a directory in /var/lib/cloud. The script is not deleted after it is run. Be sure to delete the user data scripts from /var/lib/cloud before you create an AMI from the instance. Otherwise, the script will exist in this directory on any instance launched from the AMI and will be run when the instance is launched."
apt-get -y update
apt-get -y install ruby
apt-get -y install wget
cd /home/ubuntu
wget https://aws-codedeploy-us-east-2.s3.amazonaws.com/latest/install
chmod +x ./install
./install auto
apt-get -y install python
wget https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py
wget https://s3.amazonaws.com/aws-codedeploy-us-east-2/cloudwatch/codedeploy_logs.conf
chmod +x ./awslogs-agent-setup.py
python awslogs-agent-setup.py -n -r REGION -c s3://aws-codedeploy-us-east-2/cloudwatch/awslogs.conf
mkdir -p /var/awslogs/etc/config
cp codedeploy_logs.conf /var/awslogs/etc/config/
service awslogs restart
service codedeploy-agent start