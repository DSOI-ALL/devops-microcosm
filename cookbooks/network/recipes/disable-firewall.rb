bash "disable firewall for jenkins" do
  code <<-EOH
		firewall-cmd --zone=public --add-port=8080/tcp --permanent
    firewall-cmd --zone=public --add-service=http --permanent
    firewall-cmd --reload
  EOH
  user "root"
  action :run
end
