bash "install epel-repo" do
  code <<-EOH
		yum -y install epel-release
  EOH
  user "root"
  action :run
end

bash "install Node.js (npm is included along with http_parser.x86_64 dependency)" do
  code <<-EOH
    yum -y install nodejs
  EOH
  user "root"
  action :run
end

bash "install/start redis" do
  code <<-EOH
    yum -y install redis
    systemctl start redis
  EOH
  user "root"
  action :run
end

bash "install Hubot" do
  code <<-EOH
    npm install -g yo generator-hubot
  EOH
  user "root"
  action :run
end

bash "create directory for hubot" do
  cwd "/home/vagrant"
  code <<-EOH
    mkdir myhubot
  EOH
  user "vagrant"
  action :run
  not_if do ::File.exists?("/home/vagrant/myhubot") end
end

bash "export hubot_jenkins url/creds" do
  code <<-EOH
    export HUBOT_JENKINS_AUTH="admin:tartans"
    export HUBOT_JENKINS_URL="http://10.1.1.8:8080/"
  EOH
  user "root"
  action :run
end

template "/home/vagrant/myhubot/jenkins.coffee" do
  source "jenkins.coffee.erb"
  user "root"
  group "root"
end

template "/home/vagrant/myhubot/hubot.coffee" do
  source "hubot.coffee.erb"
  user "root"
  group "root"
end

template "/home/vagrant/myhubot/npm_packages_install.sh" do
  source "npm_packages_install.sh.erb"
  user "root"
  group "root"
end

bash "change permission on npm package install script" do
  cwd "/home/vagrant/myhubot"
  code <<-EOH
    chmod 755 npm_packages_install.sh
  EOH
  user "root"
  action :run
end