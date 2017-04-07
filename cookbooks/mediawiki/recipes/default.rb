#
# Cookbook Name:: mediawiki
# Recipe:: default
#
# Maintainer: ryan.lewkowicz@spindance.com
#

package 'git'

#Initialize some varibles
def random_password
  require 'securerandom'
  SecureRandom.base64
end

password = random_password
datadir = node['mediawiki']['data_home']
sitehome = node['mediawiki']['site_home']

#create user for nginx/hhvm
user node['mediawiki']['hhvm']['user']

#create base dirs
directory datadir do
  recursive true
end

directory '/var/www' do
  recursive true
end

#Set up Docker
docker_installation 'default' do
  repo 'main'
  action :create
end

service "docker" do
  action [ :enable, :start ]
end

docker_service 'default' do
  daemon
  action [:create, :start]
end

#Set up Maria 
file '/root/.my.cnf' do
  if !node['mycnf_set']
    content lazy { "[mysql]\nuser=root\npassword=#{password}\n\n[mysqldump]\nuser=root\npassword=#{password}\n[client]\nprotocol=tcp" }
    mode 0600
    sensitive true
  end
end

#Setup Site Home files
git '/var/www/mediawiki' do
  repository 'https://github.com/spindance/mediawiki.git'
  revision 'master'
  action :checkout
  not_if {node['mediawiki_init']}
  #user 'nginx'
  #group 'nginx'
end

execute 'chown mediawiki' do
  command 'chown -R nginx.nginx /var/www/mediawiki'
end

ruby_block 'mycnf_set' do
  block do
    node.normal['mycnf_set'] = true
    node.save
  end
end 

docker_image "mariadb" do
  action :pull
  tag "#{node['mediawiki']['mariadb']['tag']}"
end

docker_container node['mediawiki']['mariadb']['container_name'] do
  repo 'mariadb'
  tag "#{node['mediawiki']['mariadb']['tag']}"
  action :redeploy 
  tty true
  network_mode 'host'
  env ["MYSQL_ROOT_PASSWORD=#{password}", "MYSQL_USER=root@#{node['ipaddress']}", "MYSQL_PASSWORD=#{password}"]
  volumes [ "#{datadir}:#{datadir}", '/root/.my.cnf:/etc/mysql/conf.d/.my.cnf' ]
  ignore_failure true
end

#Setup Nginx
remote_directory '/etc/nginx'

docker_image "nginx" do
  action :pull
  tag node['mediawiki']['nginx']['tag']
end

docker_container node['mediawiki']['nginx']['container_name'] do
  repo 'nginx'
  tag node['mediawiki']['nginx']['tag']
  network_mode 'host'
  volumes [ "#{sitehome}:#{sitehome}", '/etc/nginx:/etc/nginx', '/etc/passwd:/etc/passwd:ro', '/etc/shadow:/etc/shadow:ro', '/etc/group:/etc/group:ro' ]
  action :redeploy
  ignore_failure true
end

#Setup php-fpm

remote_directory '/etc'

docker_image 'fpm' do
  repo 'rlewkowicz/php-fpm'
  action :pull
  tag 'latest'
end

docker_container 'fpm' do
  repo 'rlewkowicz/php-fpm'
  tag 'latest'
  action :redeploy
  network_mode 'host'
  volumes [ "#{sitehome}:#{sitehome}", '/etc:/usr/local/etc', '/etc/passwd:/etc/passwd:ro', '/etc/shadow:/etc/shadow:ro', '/etc/group:/etc/group:ro' ]
  command 'php-fpm'
  ignore_failure true
  signal 'SIGKILL'
end

#Setup Parsoid
remote_directory '/etc/parsoid'

docker_image "rlewkowicz/parsoid" do
  action :pull
  tag 'latest'
end

docker_container "parsoid" do
  repo 'rlewkowicz/parsoid'
  tag 'latest'
  action :redeploy
  network_mode 'host'
  working_dir '/etc/parsoid'
  command 'node /parsoid/bin/server.js'
  ignore_failure true
  volumes [ '/etc/parsoid:/etc/parsoid' ]
end

#Setup Plugins

require 'mixlib/shellout'
vedit = Mixlib::ShellOut.new("curl -s https://extdist.wmflabs.org/dist/extensions/ | grep -Eo VisualE.*tar.gz | awk -F'>' '{print $2}' | grep 1_27")
vedit.run_command


ark 'VisualEditor' do
  url "https://extdist.wmflabs.org/dist/extensions/#{vedit.stdout}"
  path '/var/www/mediawiki/extensions/'
  owner 'nginx'
  action :put
end

#Setup local config Gen.
cookbook_file '/var/www/mediawiki/includes/installer/LocalSettingsGenerator.php' do
  mode '0644'
  owner 'nginx'
  group 'nginx'
  end

ruby_block 'mediawiki_init_set' do
  block do
    node.normal['mediawiki_init'] = true
    node.save
  end
end