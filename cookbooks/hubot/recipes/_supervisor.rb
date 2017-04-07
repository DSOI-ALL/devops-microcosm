include_recipe 'supervisor'

hubot_name = node['hubot']['name']
hubot_bin = File.join(node['hubot']['install_dir'], 'node_modules', '.bin', 'hubot')
hubot_adapter = node['hubot']['adapter']

node.default['hubot']['config']['PATH'] = "#{node['hubot']['install_dir']}/node_modules/.bin:%(ENV_PATH)s"

supervisor_service 'hubot' do
  action [:enable, :start]
  autostart true
  autorestart true
  directory node['hubot']['install_dir']
  command "#{hubot_bin} -n \"#{hubot_name}\" -a #{hubot_adapter}"
  stopsignal 'TERM'
  user node['hubot']['user']
  startretries 3
  stdout_logfile node['hubot']['supervisor']['stdout_logfile']
  stdout_logfile_maxbytes node['hubot']['supervisor']['stdout_logfile_maxbytes']
  stdout_logfile_backups node['hubot']['supervisor']['stdout_logfile_backups']
  stderr_logfile node['hubot']['supervisor']['stderr_logfile']
  stderr_logfile_maxbytes node['hubot']['supervisor']['stderr_logfile_maxbytes']
  stderr_logfile_backups node['hubot']['supervisor']['stderr_logfile_backups']
  environment node['hubot']['config']
end
