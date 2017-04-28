bash "install epel-repo & ansible" do
  code <<-EOH
		yum -y install epel-release
    yum -y install ansible
  EOH
  user "root"
  action :run
end
