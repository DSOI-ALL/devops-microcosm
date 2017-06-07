bash "install epel-repo" do
  code <<-EOH
		yum -y install epel-release
  EOH
  user "root"
  action :run
end

bash "install Node.js" do
  code <<-EOH
    yum -y install nodejs
  EOH
  user "root"
  action :run
end

bash "install npm" do
  code <<-EOH
    yum -y install npm
    yum -y install http-parser.x86_64
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