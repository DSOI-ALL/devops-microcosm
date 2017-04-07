#Core Settings
default['mediawiki']['site_home']='/var/www/mediawiki'
default['mediawiki']['data_home']='/var/lib/mysql'
default['mediawiki']['tag']='latest'
default['mediawiki']['container_name']='mediawiki'

#HHVM Settings
default['mediawiki']['hhvm']['tag']='latest'
default['mediawiki']['hhvm']['container_name']='hhvm'
default['mediawiki']['hhvm']['port']='9000:9000'
default['mediawiki']['hhvm']['user']='nginx'
default['mediawiki']['hhvm']['group']='nginx'

#MariaDB Settings
default['mediawiki']['mariadb']['port']='3306:3306'
default['mediawiki']['mariadb']['container_name']='mariadb'
default['mediawiki']['mariadb']['tag']='10.1'

#NGINX Settings
default['mediawiki']['nginx']['port']='80:80'
default['mediawiki']['nginx']['container_name']='nginx'
default['mediawiki']['nginx']['tag']='1.10'
default['mediawiki']['nginx']['home']='/etc/nginx'

