include_recipe 'runit'

runit_service 'hubot' do
  options node['hubot'].to_hash
  env node['hubot']['config']
  default_logger node['hubot']['runit']['default_logger']
end
