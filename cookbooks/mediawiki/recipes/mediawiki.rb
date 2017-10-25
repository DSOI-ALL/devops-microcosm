bash "set up server and disable apache welcome page" do
  code <<-EOH
    sed -i '8,22 s/^/#/' /etc/httpd/conf.d/welcome.conf 
    systemctl restart httpd.service
  EOH
  user "root"
  action :run
end

bash "download mediawiki" do
  code <<-EOH
    wget http://releases.wikimedia.org/mediawiki/1.29/mediawiki-1.29.0.tar.gz
    mv mediawiki-1.29.0.tar.gz /var/www/html
    cd /var/www/html
    tar -xvzf mediawiki-1.29.0.tar.gz
    rm -f mediawiki-1.29.0.tar.gz
    mv mediawiki-1.29.0 wiki
    rm -rf mediawiki-1.29.0
  EOH
  user "root"
  action :run
end

bash "create database" do
  code <<-EOH
   mysql -u root -e "CREATE DATABASE my_wiki;"
   mysql -u root -e "GRANT INDEX, CREATE, SELECT, INSERT, UPDATE, DELETE, ALTER, LOCK TABLES ON my_wiki.* TO 'tartan'@'localhost' IDENTIFIED BY 'password';"    
   mysql -u root -e "FLUSH PRIVILEGES;"
  EOH
  user "root"
  action :run
end


bash "modify-mediawiki-settings" do
  cwd "/var/www/html/wiki"
  code <<-EOH
    php maintenance/install.php --dbname my_wiki --dbpass password --dbserver localhost --dbuser tartan --dbtype mysql --installdbpass password --pass password --installdbuser tartan "mediawiki-1.29.0" "admin"
  EOH
  action :run
  user "root"
  not_if do ::File.exists?("/var/html/www/wiki/mediawiki-1.29.0") end
end
