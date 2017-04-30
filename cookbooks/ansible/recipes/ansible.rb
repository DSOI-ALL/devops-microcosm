bash "install epel-repo & ansible" do
  code <<-EOH
		yum -y install epel-release
    yum -y install ansible
  EOH
  user "root"
  action :run
end

template "/etc/ansible/hosts" do
  source "hosts.erb"
  user "root"
  group "root"
end