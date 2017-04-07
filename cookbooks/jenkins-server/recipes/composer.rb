if node['jenkins-server']['composer']['install']
  include_recipe 'composer'

  composer_dir = "#{node['jenkins']['master']['home']}/.composer"

  # Create .composer directory
  directory composer_dir do
    owner node['jenkins']['master']['user']
    group node['jenkins']['master']['group']
    mode '0755'
    action :create
  end

  # Create composer.json
  template "#{composer_dir}/composer.json" do
    cookbook node['jenkins-server']['composer']['template_cookbook']
    source node['jenkins-server']['composer']['template_source']
    owner  node['jenkins']['master']['user']
    group  node['jenkins']['master']['group']
    mode   '0644'
  end

  # Install composer vendors
  composer_project composer_dir do
    dev false
    quiet false
    prefer_dist false
    action :install
  end

  # Chown composer vendors
  bash 'chown_composer_vendors' do
    user 'root'
    code <<-EOS
      chown -R #{node['jenkins']['master']['user']}:#{node['jenkins']['master']['group']} #{node['jenkins']['master']['home']}/.composer
    EOS
  end

  # Add composer vendor bin directory to the path environment variable
  bash 'add_composer_vendor_bin_dir_to_path' do
    user 'root'
    code <<-EOS
      echo 'export PATH=$PATH:$HOME/.composer/vendor/bin' >> #{node['jenkins']['master']['home']}/.bashrc
    EOS
    not_if "grep -q composer/vendor/bin #{node['jenkins']['master']['home']}/.bashrc"
  end
end
