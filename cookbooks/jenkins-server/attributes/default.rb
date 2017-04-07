# General
default['jenkins-server']['admin']['username'] = 'admin'
default['jenkins-server']['admin']['password'] = 'admin' # only used if the security strategy is "generate"
default['jenkins-server']['security']['strategy'] = 'generate' # generate or chef-vault
default['jenkins-server']['security']['chef-vault']['data_bag'] = 'jenkins-users'
default['jenkins-server']['security']['chef-vault']['data_bag_item'] = node['jenkins-server']['admin']['username']
default['jenkins-server']['security']['notifies']['resource'] = 'jenkins_script[configure permissions]'

# Nginx
default['jenkins-server']['nginx']['install'] = true
default['jenkins-server']['nginx']['server_name'] = 'jenkins-server001.local'
default['jenkins-server']['nginx']['server_default'] = true
default['jenkins-server']['nginx']['template_cookbook'] = 'jenkins-server'
default['jenkins-server']['nginx']['template_source'] = 'nginx/jenkins.conf.erb'
default['jenkins-server']['nginx']['ssl'] = false
default['jenkins-server']['nginx']['ssl_cert_path'] = nil
default['jenkins-server']['nginx']['ssl_key_path'] = nil

# Packages
default['jenkins-server']['java']['install'] = true
default['jenkins-server']['ant']['install'] = true
default['jenkins-server']['git']['install'] = true
default['jenkins-server']['composer']['install'] = true
default['jenkins-server']['composer']['template_cookbook'] = 'jenkins-server'
default['jenkins-server']['composer']['template_source'] = 'composer/composer.json.erb'

# Settings
default['jenkins-server']['settings']['executors'] = node['cpu']['total'] < 2 ? 2 : node['cpu']['total']
default['jenkins-server']['settings']['slave_agent_port'] = 0 # Port | 0 to indicate random available TCP port | -1 to disable this service
default['jenkins-server']['settings']['global_properties']['env_vars'] = {
    'PATH' => "$PATH:/usr/local/bin:#{node['jenkins']['master']['home']}/.composer/vendor/bin",
}
default['jenkins-server']['settings']['system_email'] = 'Jenkins <jenkins@localhost.local>'
default['jenkins-server']['settings']['mailer']['smtp_host'] = ''
default['jenkins-server']['settings']['mailer']['username'] = ''
default['jenkins-server']['settings']['mailer']['password'] = ''
default['jenkins-server']['settings']['mailer']['use_ssl'] = false
default['jenkins-server']['settings']['mailer']['smtp_port'] = ''
default['jenkins-server']['settings']['mailer']['reply_to_address'] = ''
default['jenkins-server']['settings']['mailer']['charset'] = 'UTF-8'

# Node monitors
default['jenkins-server']['node_monitors']['architecture_monitor']['ignored'] = false
default['jenkins-server']['node_monitors']['clock_monitor']['ignored'] = false
default['jenkins-server']['node_monitors']['disk_space_monitor']['ignored'] = false
default['jenkins-server']['node_monitors']['disk_space_monitor']['free_space_threshold'] = '1GB'
default['jenkins-server']['node_monitors']['swap_space_monitor']['ignored'] = false
default['jenkins-server']['node_monitors']['temporary_space_monitor']['ignored'] = false
default['jenkins-server']['node_monitors']['temporary_space_monitor']['free_space_threshold'] = '1GB'
default['jenkins-server']['node_monitors']['response_time_monitor']['ignored'] = false

# Plugins
default['jenkins-server']['plugins'] = {
  # General
  'greenballs' => {'version' => '1.14'},
  'locale' => {
    'version' => '1.2',
    'configure' => 'template',
    'system_locale' => 'en',
    'ignore_accept_language' => true
  },
  'antisamy-markup-formatter' => {
    'version' => '1.1',
    'configure' => true,
    # Markup: safe_html or plain_text
    'markup' => 'safe_html',
    # Disable syntax highlighting is only available with safe_html markup
    'disable_syntax_highlighting' => false
  },
  'gravatar' => {'version' => '2.1'},
  'ws-cleanup' => {'version' => '0.26'},
  'ansicolor' => {'version' => '0.4.1'},
  'build-monitor-plugin' => {'version' => '1.6+build.150'},
  'git-client' => {'version' => '1.19.4'},
  'git' => {
    'version' => '2.4.2',
    'configure' => 'template',
    'template_path' => 'hudson.plugins.git.GitSCM.xml',
    'template_source' => 'jenkins/plugins/hudson.plugins.git.GitSCM.xml.erb',
    'global_config_name' => 'Jenkins',
    'global_config_email' => 'jenkins@localhost.local',
    'create_account_based_on_email' => false
  },
  'ant' => {'version' => '1.2'},

  # Jenkins PHP (jenkins-php.org)
  'checkstyle' => {'version' => '3.42'},
  'cloverphp' => {'version' => '0.4'},
  'crap4j' => {'version' => '0.9'},
  'dry' => {'version' => '2.41'},
  'htmlpublisher' => {'version' => '1.4'},
  'jdepend' => {'version' => '1.2.4'},
  'plot' => {'version' => '1.9'},
  'pmd' => {'version' => '3.41'},
  'violations' => {'version' => '0.7.11'},
  'warnings' => {'version' => '4.48'},
  'xunit' => {'version' => '1.96'},

  # BitBucket
  'bitbucket' => {'version' => '1.1.1'},
  'bitbucket-pullrequest-builder' => {'version' => '1.4.5'}
}

# Crowd 2 (Jenkins authentication with Jira accounts)
if node['jenkins-server']['security']['notifies']['resource'] == 'jenkins_script[configure crowd permissions]'
  default['jenkins-server']['plugins']['crowd2'] = {
    'version' => '1.8',
    'url' => 'https://example.com/jira',
    'applicationName' => 'Jenkins',
    'password' => 'changethis',
    'group' => 'stash-users', # JIRA groups that are allowed to login into Jenkins
    'nestedGroups' => false,
    'sessionValidationInterval' => 480, # minutes
    'useSSO' => false,
    'cookieDomain' => '',
    'cookieTokenkey' => 'crowd.token_key',
    'useProxy' => false,
    'httpProxyHost' => '',
    'httpProxyPort' => '',
    'httpProxyUsername' => '',
    'httpProxyPassword' => '',
    'socketTimeout' => '20000',
    'httpTimeout' => '5000',
    'httpMaxConnections' => '20'
  }
end

# Jobs
default['jenkins-server']['jobs']['php-template'] = {}

# Views
default['jenkins-server']['views'] = {}
default['jenkins-server']['purge_views'] = true

# Slaves
default['jenkins-server']['slaves']['enable'] = false
default['jenkins-server']['slaves']['credential']['username'] = 'deployer' # The Jenkins master will login as this user on slaves
default['jenkins-server']['slaves']['credential']['description'] = 'Deployer'
default['jenkins-server']['slaves']['search_key'] = 'jenkins-server-slave'
default['jenkins-server']['slaves']['search_query'] = "#{node['jenkins-server']['slaves']['search_key']}:* AND chef_environment:#{node.chef_environment} AND NOT fqdn:#{node['fqdn']}"

# Dev_mode attributes
default['jenkins-server']['dev_mode']['security']['password'] = 'admin'
default['jenkins-server']['dev_mode']['security']['public_key'] = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDn23T41ZUS5PVhkns4+kf0nFoH2UoxHlpc5O3zAFOssBRbVcfGVdQk9MYSA8upeVQr1p3ccgOdDivpYx+Cg2oTATnQHJCHihzueMxsIxmVOm7b78MF8IWIXWzdxsZMbjInhTFuEC4I2wWg1BCxottWzqgDLYt753KdW1+D7i7MaJIBB4sJ9PLx3MgHnsTiAB5BDIVtkJUM2q3UTszV3RMa8gbb0QkCjamTypKoeTjM/rTQQLIOH79yvVSv2FRlcGzwpsAnZT46T9K+AyrEcAlH5Eo2Bk92xbcHhGnoGlzOBAgxqLJ3v6pDVnUefRiqjxZ7N+tPbbhzeaD0pWQe99GmKAuBMfFfbDzA/Q7DIhRQ8ddVs9Ol7iNNp1xkxksgO1GekwxbrDBkIO4olxEzATCLkvDLLREQ2DtWeOQN5P0U3HR5q2Kf8qCl4vniDc72QJTxE4KG2KHrgXiuFn3poc9k6RkI076nTY0N5mXKd/lEze+3xVxBBnHe/a0ibWG08FMuh4TDkzX459PW0xIWmXVt2OCtisZOSs0JG7E0Qo6ymIFcHpfROvH/FYxDorWJdvRq23K2Zok97b83jh7W7FjEnrJyyT9OiaJcW3fUcrJvlvvxrjAFmeRiUgXnmSqfCRLsDiRQ4mgfnJ7dZYSD+RYSiiiOb+79TJTihw+jDoADOQ== jenkins-security'
default['jenkins-server']['dev_mode']['security']['private_key'] =
'-----BEGIN RSA PRIVATE KEY-----
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
-----END RSA PRIVATE KEY-----'