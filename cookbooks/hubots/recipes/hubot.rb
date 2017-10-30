bash "install epel-repo" do
  code <<-EOH
		yum -y install epel-release
  EOH
  user "root"
  action :run
end

bash "install Node.js (npm is included along with http_parser.86_64 dependency)" do
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
    npm -y install -g yo generator-hubot
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