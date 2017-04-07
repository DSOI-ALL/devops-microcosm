# NOTE: Include or copy this recipe to a cookbook that is in the run list
# of each server that you want to be a Jenkins slave

slave_id = node['fqdn'].gsub(/\./, '_')

Chef::Log.debug "[JENKINS_SLAVE]: [#{slave_id}]"

fqdn_parts = node['fqdn'].split('.')
environment = node.chef_environment == 'production' ? '' : ".#{node.chef_environment}"

# Find the last part when split on a dash and remove all digits
type = fqdn_parts[0].split('-').last.gsub!(/[^a-z]/i, '').to_s

data = {
  'id' => slave_id,
  'type' => 'ssh',
  'name' => "#{fqdn_parts[0]}#{environment}",
  'host' => node['fqdn'],
  'credentials' => 'deployer',
  'remote_fs' => '/tmp',
  'executors' => 10,
  'labels' => [
    node['fqdn'],
    fqdn_parts[0],
    "#{type}.#{node.chef_environment}",
    type
  ],
  'usage_mode' => 'exclusive',
  'availability' => 'always'
}

# Set a Jenkins slave attribute that the Jenkins master server will find with a search
node.default['jenkins-server-slave'] = data
