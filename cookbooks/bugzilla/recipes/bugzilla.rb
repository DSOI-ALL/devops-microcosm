bash "set SElinux to Permissive & reboot to apply" do
  code <<-EOH
    sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/g' /etc/selinux/config
    reboot
  EOH
  user "root"
  action :run
end


bash "download bugzilla" do
  code <<-EOH
    wget 'https://ftp.mozilla.org/pub/mozilla.org/webtools/bugzilla-5.0.tar.gz'
    mv bugzilla-5.0.tar.gz /var/www/html
    cd /var/www/html
    tar -xvzf bugzilla-5.0.tar.gz
    mv bugzilla-5.0 bugzilla
  EOH
  user "root"
  action :run
end

bash "create database" do
  code <<-EOH
   mysql -u root -e "CREATE DATABASE bugs;"
   mysql -u root -e "GRANT INDEX, CREATE, SELECT, INSERT, UPDATE, DELETE, ALTER, LOCK TABLES ON bugs.* TO 'bugs'@'localhost' IDENTIFIED BY 'password';"    
   mysql -u root -e "FLUSH PRIVILEGES;"
  EOH
  user "root"
  action :run
end

bash "modify 'my.cnf' to allow for greater packet size required by bugzilla" do
  code <<-EOH
   sed -i -e "\$amax_allowed_packet=4M" /etc/my.cnf
  EOH
  user "root"
  action :run
end

bash "install additional perl packages" do
  code <<-EOH
   yum -y install gcc gcc-c++ graphviz graphviz-devel patchutils gd gd-devel wget perl* -x perl-homedir
  EOH
  user "root"
  action :run
end

bash "install required missing perl modules & execute setup script" do
  code <<-EOH
   /usr/bin/perl install-module.pl --all
  EOH
  user "root"
  action :run
end

bash "modify './localconfig' to apply proper database credentials" do
  code <<-EOH

  EOH
  user "root"
  action :run
end

template "/etc/httpd/conf.d/bugzilla.conf" do
  source "bugzilla.erb"
  user "root"
  group "root"
end



