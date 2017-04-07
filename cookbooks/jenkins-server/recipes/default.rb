if node['jenkins-server']['java']['install']
  include_recipe 'java'
end

if node['jenkins-server']['ant']['install']
  include_recipe 'ant'
end

if node['jenkins-server']['git']['install']
  include_recipe 'git'
end

if node['jenkins-server']['nginx']['install']
  include_recipe 'jenkins-server::nginx'
end

include_recipe 'jenkins-server::master'
include_recipe 'jenkins-server::settings'
include_recipe 'jenkins-server::plugins'
include_recipe 'jenkins-server::security'
include_recipe 'jenkins-server::views'
include_recipe 'jenkins-server::jobs'
include_recipe 'jenkins-server::composer'

if node['jenkins-server']['slaves']['enable']
  include_recipe 'jenkins-server::slaves_credentials'
  include_recipe 'jenkins-server::slaves'
end
