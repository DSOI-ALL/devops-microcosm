bash "download and install Owasp Zap" do
  code <<-EOH
    cd /etc/yum.repos.d/
    wget http://download.opensuse.org/repositories/home:cabelo/CentOS_7/home:cabelo.repo
    yum install -y owasp-zap
  EOH
  user "root"
  action :run
end

bash "install-java" do
  code <<-EOH
		yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel
  EOH
  user "root"
  action :run
end

bash "start owasp-zap service" do
  code <<-EOH
		service owasp-zap start
  EOH
  user "root"
  action :run
end