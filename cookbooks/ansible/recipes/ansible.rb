bash "install epel-repo & ansible" do
  code <<-EOH
	yum -y install epel-release
    yum -y install ansible
  EOH
  user "root"
  action :run
end

bash "disable-host-key-checking" do
	code <<-EOH
		sed -i "s/#host_key_checking = False/host_key_checking = False/" /etc/ansible/ansible.cfg
	EOH
	user "root"
	action :run
end

template "/etc/ansible/hosts" do
  source "hosts.erb"
  user "root"
  group "root"
end

remote_file "/etc/ansible/vagrant_id_rsa" do 
  source "https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant"
  mode '0400'
  owner 'jenkins'
  group 'jenkins'
  action :create
end
