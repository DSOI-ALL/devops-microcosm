bash "download and install jenkins" do
  code <<-EOH
    wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
    rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
    yum install -y jenkins
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

bash "start jenkins service" do
  code <<-EOH
		service jenkins start
  EOH
  user "root"
  action :run
end