# Configure settings
jenkins_script 'configure settings' do
  # Collect a list of envVars strings
  env_vars = []
  node['jenkins-server']['settings']['global_properties']['env_vars'].each do |name, value|
    env_vars << "envVars.put('#{name}', '#{value}')"
  end

  command <<-EOH.gsub(/^ {4}/, '')
    import jenkins.model.*

    def instance = Jenkins.getInstance()

    // General
    instance.setNumExecutors(#{node['jenkins-server']['settings']['executors']})
    instance.setSlaveAgentPort(#{node['jenkins-server']['settings']['slave_agent_port']})

    instance.save()

    // Global properties
    def globalNodeProperties = instance.getGlobalNodeProperties()
    def environmentVariablesNodePropertyList = globalNodeProperties.getAll(hudson.slaves.EnvironmentVariablesNodeProperty.class)

    def envVars = null

    if (environmentVariablesNodePropertyList == null || environmentVariablesNodePropertyList.size() == 0) {
        def newEnvironmentVariablesNodeProperty = new hudson.slaves.EnvironmentVariablesNodeProperty();

        globalNodeProperties.add(newEnvironmentVariablesNodeProperty)
        envVars = newEnvironmentVariablesNodeProperty.getEnvVars()
    } else {
        envVars = environmentVariablesNodePropertyList.get(0).getEnvVars()
    }

    #{env_vars.join("\n")}

    instance.save()

    // Admin address
    def jenkinsLocationConfiguration = JenkinsLocationConfiguration.get()

    jenkinsLocationConfiguration.setAdminAddress('#{node['jenkins-server']['settings']['system_email']}')
    jenkinsLocationConfiguration.save()

    // Mailer
    def descriptor = instance.getDescriptor('hudson.tasks.Mailer')

    descriptor.setSmtpHost('#{node['jenkins-server']['settings']['mailer']['smtp_host']}')
    descriptor.setSmtpAuth('#{node['jenkins-server']['settings']['mailer']['username']}', '#{node['jenkins-server']['settings']['mailer']['password']}')
    descriptor.setUseSsl(#{node['jenkins-server']['settings']['mailer']['use_ssl']})
    descriptor.setSmtpPort('#{node['jenkins-server']['settings']['mailer']['smtp_port']}')
    descriptor.setReplyToAddress('#{node['jenkins-server']['settings']['mailer']['reply_to_address']}')
    descriptor.setCharset('#{node['jenkins-server']['settings']['mailer']['charset']}')

    descriptor.save()
  EOH
end

# Configure node monitors
template "#{node['jenkins']['master']['home']}/nodeMonitors.xml" do
  source 'jenkins/nodeMonitors.xml.erb'
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode '0644'
end
