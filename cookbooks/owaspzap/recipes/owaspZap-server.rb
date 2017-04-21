bash "install-java" do
  code <<-EOH
		yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel
  EOH
  user "root"
  action :run
end

bash "download Owasp Zap" do
  code <<-EOH
    mkdir /opt/zapproxy
    cd /opt/zapproxy 
    wget https://github.com/zaproxy/zaproxy/releases/download/2.6.0/ZAP_2.6.0_Linux.tar.gz
    tar -xvzf ZAP_2.6.0_Linux.tar.gz
  EOH
  user "root"
  action :run
  not_if do ::File.exists?("/opt/zapproxy/ZAP_2.6.0_Linux") end
end

bash "start owasp-zap" do
  cwd "/opt/zapproxy"
  code <<-EOH
		cd ZAP_2.6.0
    ./zap.sh -daemon &
  EOH
  user "root"
  action :run
end