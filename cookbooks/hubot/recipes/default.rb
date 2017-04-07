#
# Cookbook Name:: hubot
# Recipe:: default
#
# Copyright (c) 2013, Seth Chisamore
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'git'

case node['platform_family']
when 'debian'
  node.set['nodejs']['install_method'] = 'package'
else
  node.set['nodejs']['install_method'] = 'source'
end

include_recipe 'nodejs'

user node['hubot']['user'] do
  comment 'Hubot User'
  home node['hubot']['install_dir']
end

group node['hubot']['group'] do
  members [node['hubot']['user']]
end

directory node['hubot']['install_dir'] do
  owner node['hubot']['user']
  group node['hubot']['group']
  recursive true
  mode '0755'
end

git ::File.join(Chef::Config[:file_cache_path], 'hubot') do
  repository node['hubot']['git_source']
  revision "v#{node['hubot']['version']}"
  notifies :install, 'nodejs_npm[hubot]', :immediately
end

nodejs_npm 'hubot' do
  path ::File.join(Chef::Config[:file_cache_path], 'hubot')
  json true
  user 'root'
  group 'root'
  action :nothing
end

template "#{node['hubot']['install_dir']}/package.json" do
  source 'package.json.erb'
  owner node['hubot']['user']
  group node['hubot']['group']
  mode '0644'
  variables node['hubot'].to_hash
  notifies :install, 'nodejs_npm[install]', :immediately
end

# Get the daemonizing server
daemon = node['hubot']['daemon']

template "#{node['hubot']['install_dir']}/hubot-scripts.json" do
  source 'hubot-scripts.json.erb'
  owner node['hubot']['user']
  group node['hubot']['group']
  mode '0644'
  variables node['hubot'].to_hash
  notifies :restart, "#{daemon}_service[hubot]", :delayed
end

template "#{node['hubot']['install_dir']}/external-scripts.json" do
  source 'external-scripts.json.erb'
  owner node['hubot']['user']
  group node['hubot']['group']
  mode '0644'
  variables node['hubot'].to_hash
  notifies :restart, "#{daemon}_service[hubot]", :delayed
end

nodejs_npm 'install' do
  path node['hubot']['install_dir']
  json true
  user node['hubot']['user']
  group node['hubot']['group']
  action :nothing
  notifies :restart, "#{daemon}_service[hubot]", :delayed
end

include_recipe "hubot::_#{daemon}"
