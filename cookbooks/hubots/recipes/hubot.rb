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



