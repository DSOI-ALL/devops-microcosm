bash "install-java" do
  code <<-EOH
		yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel
  EOH
  user "root"
  action :run
end

bash "download selenium standalone server" do
  code <<-EOH
		mkdir /opt/selenium
    mkdir /opt/selenium/2.53
    cd /opt/selenium/2.53
    wget http://selenium-release.storage.googleapis.com/2.53/selenium-server-standalone-2.53.0.jar
  EOH
  user "root"
  action :run
end