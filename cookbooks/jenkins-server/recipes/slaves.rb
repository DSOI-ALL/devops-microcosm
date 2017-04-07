unless Chef::Config[:solo]
  managed_slaves = []

  # Search for nodes that have an attribute node['jenkins-server-slave']
  search(:node, node['jenkins-server']['slaves']['search_query'],
    :filter_result => {
      node['jenkins-server']['slaves']['search_key'] => [node['jenkins-server']['slaves']['search_key']],
    }
  ).each do |item|
    Chef::Log.debug "[JENKINS-SERVER]: Slave search result item [#{item}]"

    slave = item[node['jenkins-server']['slaves']['search_key']]
    managed_slaves << slave['name']

    # Add Jenkins SSH slave
    jenkins_ssh_slave slave['name'] do
      host        slave['host']
      credentials slave['credentials']

      if slave.key?('description') then description slave['description'] end
      if slave.key?('remote_fs') then remote_fs slave['remote_fs'] end
      if slave.key?('executors') then executors slave['executors'] end
      if slave.key?('usage_mode') then usage_mode slave['usage_mode'] end
      if slave.key?('labels') then labels slave['labels'] end
      if slave.key?('availability') then availability slave['availability'] end
      if slave.key?('in_demand_delay') then in_demand_delay slave['in_demand_delay'] end
      if slave.key?('idle_delay') then idle_delay slave['idle_delay'] end
      if slave.key?('environment') then environment slave['environment'] end
      if slave.key?('offline_reason') then offline_reason slave['offline_reason'] end
      if slave.key?('jvm_options') then jvm_options slave['jvm_options'] end
      if slave.key?('java_path') then java_path slave['java_path'] end

      only_if { slave.key?('type') && slave['type'] == 'ssh' }
    end
  end

  # Purge slaves
  if Dir.exists?("#{node['jenkins']['master']['home']}/nodes") # ~FC023
    Dir.foreach("#{node['jenkins']['master']['home']}/nodes") do |slave|
      next if slave == '.' or slave == '..'

      unless managed_slaves.include?(slave)
        Chef::Log.debug "[JENKINS-SERVER] Delete unmanaged slave [#{slave}]"

        jenkins_slave slave do
          action :delete
        end
      end
    end
  end
end
