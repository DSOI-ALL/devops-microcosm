bash "install-java & unzip" do
  code <<-EOH
		yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel
    yum install -y unzip
  EOH
  user "root"
  action :run
end

bash "download selenium web driver & geckodriver" do
  code <<-EOH
		mkdir /opt/selenium
    cd /opt/selenium
    wget http://selenium-release.storage.googleapis.com/3.6/selenium-java-3.6.0.zip
    unzip selenium-java-3.6.0.zip
    wget https://github.com/mozilla/geckodriver/releases/download/v0.19.0/geckodriver-v0.19.0-linux64.tar.gz
    tar -xvzf geckodriver-v0.19.0-linux64.tar.gz
    rm geckodriver-v0.19.0-linux64.tar.gz
  EOH
  user "root"
  action :run
end