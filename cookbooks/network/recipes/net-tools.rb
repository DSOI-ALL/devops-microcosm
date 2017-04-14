bash "install: net-tools" do
  code <<-EOH
		yum -y install net-tools
  EOH
  user "root"
  action :run
end
