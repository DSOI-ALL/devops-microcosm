bash "install Centos Desktop GUI" do
  code <<-EOH
		yum group install -y 'gnome desktop'
    systemctl isolate graphical.target
    systemctl set-default graphical.target
  EOH
  user "root"
  action :run
end

reboot 'app_requires_reboot' do
  action :request_reboot
  reason 'Need to reboot when the run completes successfully to complete centos 7 desktop.'
end