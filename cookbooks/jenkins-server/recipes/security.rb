if node['jenkins-server']['security']['strategy'] == 'generate'
  if node.attribute?('jenkins_security_enabled')
    ssh_private_key = nil
    ssh_public_key = nil
  else
    # Install sshkey gem into Chef
    chef_gem 'sshkey'
    require 'sshkey'

    # Generate a keypair with Ruby
    sshkey = SSHKey.generate(
      type: 'RSA',
      bits:  4096,
      comment: 'jenkins-security'
    )

    ssh_private_key = sshkey.private_key
    ssh_public_key = sshkey.ssh_public_key
  end

  jenkins_user = {
    'password' => node['jenkins-server']['admin']['password'],
    'private_key' => ssh_private_key,
    'public_key' => ssh_public_key
  }
else
  if node['dev_mode']
    jenkins_user = {
      'password' => node['jenkins-server']['dev_mode']['security']['password'],
      'private_key' => node['jenkins-server']['dev_mode']['security']['private_key'],
      'public_key' => node['jenkins-server']['dev_mode']['security']['public_key']
    }
  else
    jenkins_user = chef_vault_item(
      node['jenkins-server']['security']['chef-vault']['data_bag'],
      node['jenkins-server']['security']['chef-vault']['data_bag_item']
    )
  end
end

# Set the private key in the run state only if security was enabled in a previous chef run
if node.attribute?('jenkins_security_enabled')
  Chef::Log.debug '[JENKINS] Security is enabled in a previous run'

  node.run_state[:jenkins_private_key] = File.read("#{Chef::Config[:file_cache_path]}/jenkins-key") # ~FC001
end

# Add the admin user, but only the first run
jenkins_user node['jenkins-server']['admin']['username'] do
  password jenkins_user['password']
  public_keys [jenkins_user['public_key']]
  not_if { node.attribute?('jenkins_security_enabled') }
end

ruby_block 'init permission configuration' do
  block do end
  notifies :execute, node['jenkins-server']['security']['notifies']['resource'], :immediately
  action :run
end

# By default Jenkins allows everybody. Configure "Project Matrix Authorization" and
# give the admin user the "administrator" permission. If you want to further customize this resource,
# copy it into your own recipe and name it "configure custom permissions" for example. And set
# default['jenkins-server']['security']['notifies']['resource'] = 'jenkins_script[configure custom permissions]'.
jenkins_script 'configure permissions' do
  command <<-EOH.gsub(/^ {4}/, '')
    import jenkins.model.*
    import hudson.security.*

    def instance = Jenkins.getInstance()

    def hudsonRealm = new HudsonPrivateSecurityRealm(false)
    instance.setSecurityRealm(hudsonRealm)

    def strategy = new ProjectMatrixAuthorizationStrategy()
    strategy.add(Jenkins.ADMINISTER, "#{node['jenkins-server']['admin']['username']}")
    instance.setAuthorizationStrategy(strategy)

    instance.save()
  EOH
  notifies :create, 'ruby_block[set jenkins_security_enabled flag]', :immediately
  action :nothing
end

# By default Jenkins allows everybody. Configure "Project Matrix Authorization", the CrowdSecurityRealm
# for authentication with a JIRA account and give the admin user the "administrator" permission. If you want
# to further customize this resource, copy it into your own recipe and name it "configure custom crowd permissions"
# for example. And set default['jenkins-server']['security']['notifies']['resource'] =
# 'jenkins_script[configure custom crowd permissions]'.
jenkins_script 'configure crowd permissions' do
  if node['jenkins-server']['plugins']['crowd2']
    # Give all groups that are allowed to authenticate the overall read permission
    strategies = []
    node['jenkins-server']['plugins']['crowd2']['group'].split(',').each do |group|
      strategies << "strategy.add(Jenkins.READ, \"#{group.strip}\")"
    end

    command <<-EOH.gsub(/^ {4}/, '')
      import jenkins.model.*
      import hudson.security.*

      def instance = Jenkins.getInstance()

      def url = '#{node['jenkins-server']['plugins']['crowd2']['url']}'
      def applicationName = '#{node['jenkins-server']['plugins']['crowd2']['applicationName']}'
      def password = '#{node['jenkins-server']['plugins']['crowd2']['password']}'
      def group = '#{node['jenkins-server']['plugins']['crowd2']['group']}'
      def nestedGroups = #{node['jenkins-server']['plugins']['crowd2']['nestedGroups']}
      def sessionValidationInterval = #{node['jenkins-server']['plugins']['crowd2']['sessionValidationInterval']}
      def useSSO = #{node['jenkins-server']['plugins']['crowd2']['useSSO']}
      def cookieDomain = '#{node['jenkins-server']['plugins']['crowd2']['cookieDomain']}'
      def cookieTokenkey = '#{node['jenkins-server']['plugins']['crowd2']['cookieTokenKey']}'
      def useProxy = #{node['jenkins-server']['plugins']['crowd2']['useProxy']}
      def httpProxyHost = '#{node['jenkins-server']['plugins']['crowd2']['httpProxyHost']}'
      def httpProxyPort = '#{node['jenkins-server']['plugins']['crowd2']['httpProxyPort']}'
      def httpProxyUsername = '#{node['jenkins-server']['plugins']['crowd2']['httpProxyUsername']}'
      def httpProxyPassword = '#{node['jenkins-server']['plugins']['crowd2']['httpProxyPassword']}'
      def socketTimeout = '#{node['jenkins-server']['plugins']['crowd2']['socketTimeout']}'
      def httpTimeout = '#{node['jenkins-server']['plugins']['crowd2']['httpTimeout']}'
      def httpMaxConnections = '#{node['jenkins-server']['plugins']['crowd2']['httpMaxConnections']}'

      def crowdRealm = new de.theit.jenkins.crowd.CrowdSecurityRealm(
        url,
        applicationName,
        password,
        group,
        nestedGroups,
        sessionValidationInterval,
        useSSO,
        cookieDomain,
        cookieTokenkey,
        useProxy,
        httpProxyHost,
        httpProxyPort,
        httpProxyUsername,
        httpProxyPassword,
        socketTimeout,
        httpTimeout,
        httpMaxConnections
      )

      instance.setSecurityRealm(crowdRealm)

      def strategy = new ProjectMatrixAuthorizationStrategy()
      strategy.add(Jenkins.ADMINISTER, "#{node['jenkins-server']['admin']['username']}")
      #{strategies.join("\n")}
      instance.setAuthorizationStrategy(strategy)

      instance.save()
    EOH
  end
  notifies :create, 'ruby_block[set jenkins_security_enabled flag]', :immediately
  action :nothing
end

# Set the jenkins_security_enabled flag and set run_state to use the configured private key
ruby_block 'set jenkins_security_enabled flag' do
  block do
    node.run_state[:jenkins_private_key] = jenkins_user['private_key'] # ~FC001
    node.set['jenkins_security_enabled'] = true

    unless Chef::Config[:solo]
      node.save
    end
  end
  not_if { node.attribute?('jenkins_security_enabled') }
  action :nothing
end
