bash "download and install/configure the necessary dependencies" do
  code <<-EOH
    yum install -y curl policycoreutils openssh-server openssh-clients
    systemctl enable sshd
    systemctl start sshd
    yum install -y postfix
    systemctl enable postfix
    systemctl start postfix
    service firewalld start
    firewall-cmd --permanent --add-service=http
    systemctl reload firewalld
  EOH
  user "root"
  action :run
end

bash "Add the GitLab package server and install the package" do
  code <<-EOH
    curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | bash
    yum -y install gitlab-ce
  EOH
  user "root"
  action :run
end

bash "Configure and start GitLab" do
  code <<-EOH
   gitlab-ctl reconfigure
  EOH
  user "root"
  action :run
end




