bash "install-java" do
  code <<-EOH
		yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel
  EOH
  user "root"
  action :run
end

bash "download and start selenium server" do
  code <<-EOH
		mkdir /opt/selenium/2.53
    cd /opt/selenium/2.53
    wget http://selenium-release.storage.googleapis.com/2.53/selenium-server-standalone-2.53.0.jar
    ln -s /opt/selenium/2.53/selenium-server-standalone-2.53.0.jar /opt/selenium/selenium
    java -jar /opt/selenium/selenium &
  EOH
  user "root"
  action :run
  not_if do ::File.exists?("/opt/selenium/2.53/selenium-server-standalone-2.53.0.jar") end
end
