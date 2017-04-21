bash "install and start httpd and mariaDB" do
  code <<-EOH
    yum -y install httpd 
    systemctl start httpd.service
    systemctl enable httpd.service
    yum -y install mariadb-server mariadb 
    systemctl start mariadb
    systemctl enable mariadb.service
  EOH
  user "root"
  action :run
end

bash "install php and specific php modules" do
  code <<-EOH
    yum -y install php php-mysql 
    systemctl restart httpd.service
  EOH
  user "root"
  action :run
end

bash "allow http/https traffic" do
  code <<-EOH
    firewall-cmd --permanent --zone=public --add-service=http
    firewall-cmd --permanent --zone=public --add-service=https
    firewall-cmd --reload
  EOH
  user "root"
  action :run
end