# Adds a shell to the Jenkins system user with home folder files
user node['jenkins']['master']['user'] do
  shell '/bin/bash'
end

# Copy home folder skeleton files from /etc/skel, because the Jenkins package install
# that creates the Jenkins user with a home directory doesn't do this.
bash 'copy_home_folder_skeleton_files' do
  cwd ::File.dirname(node['jenkins']['master']['home'])
  code <<-EOH
    cp -r /etc/skel/. #{node['jenkins']['master']['home']}
    chown #{node['jenkins']['master']['user']}:#{node['jenkins']['master']['group']} #{node['jenkins']['master']['home']}/.bash*
  EOH
  not_if { ::File.exist?("#{node['jenkins']['master']['home']}/.bashrc") }
end
