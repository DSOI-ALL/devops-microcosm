# jenkins-server
[![Cookbook Version](https://img.shields.io/cookbook/v/jenkins-server.svg)](https://supermarket.chef.io/cookbooks/jenkins-server) [![Code Climate](https://codeclimate.com/github/pietervogelaar/chef-cookbook-jenkins-server/badges/gpa.svg)](https://codeclimate.com/github/pietervogelaar/chef-cookbook-jenkins-server)

This cookbook installs a complete Jenkins server with plugins and is highly configurable with attributes in this cookbook. It configures settings, plugins, security, slaves and depends on the [Jenkins](https://supermarket.chef.io/cookbooks/jenkins) cookbook that is used as foundation. It also installs (can be disabled) the Jenkins plugins, php-template job and required PHP tools as described on [jenkins-php.org](http://jenkins-php.org).

## Supported Platforms

- CentOS >= 6.6
- RHEL >= 6.6
- Ubuntu >= 12.04
- Debian >= 7.0

These platforms are officially supported, but it will probably also work on other platforms.

## Attributes

### General

* `default['jenkins-server']['admin']['username']` - Sets the username for the administrator user. Default "admin"
* `default['jenkins-server']['admin']['password']` - Sets the password for the administrator user. Default "admin". Only used if the security strategy is "generate"
* `default['jenkins-server']['security']['strategy']` - Sets the security strategy. "generate" (default) or "chef-vault"
* `default['jenkins-server']['security']['chef-vault']['data_bag']` - Name of the data bag for jenkins users
* `default['jenkins-server']['security']['chef-vault']['data_bag_item']` - ID of the data bag to use as administrator user. This data bag must contain a password, private_key and public_key property
* `default['jenkins-server']['security']['notifies']['resource']` - Sets the resource that must be executed after admin user creation. By default "jenkins_script[configure permissions]", but use "jenkins_script[configure crowd permissions]" for Jenkins authentication with a JIRA account.

### Nginx

* `default['jenkins-server']['nginx']['install']` - Default `true`. Jenkins is proxied behind Nginx. If you want to disable this, set this attribute to `false` and `default['jenkins']['master']['listen_address']` to `0.0.0.0`. Jenkins will then be reachable on port 8080.
* `default['jenkins-server']['nginx']['server_name']` - Server name / hostname. Default "jenkins-server001.local"
* `default['jenkins-server']['nginx']['server_default']` - If the Jenkins server block must be the default/catch all. Default `true`
* `default['jenkins-server']['nginx']['template_cookbook']` - The cookbook for the Nginx server template. Default "jenkins-server"
* `default['jenkins-server']['nginx']['template_source']` - The source for the Nginx server template. Default "nginx/jenkins.conf.erb"
* `default['jenkins-server']['nginx']['ssl']` - If a SSL connection must be used and forced. Default `false`
* `default['jenkins-server']['nginx']['ssl_cert_path']` - Path to the SSL certificate. Default `nil`
* `default['jenkins-server']['nginx']['ssl_key_path']` - Path to the SSL private key. Default `nil`

### Packages

* `default['jenkins-server']['java']['install']` - Installs Java with the [Java cookbook](https://supermarket.chef.io/cookbooks/java)
* `default['jenkins-server']['ant']['install']` - Installs Ant with the [Ant cookbook](https://supermarket.chef.io/cookbooks/ant)
* `default['jenkins-server']['git']['install']` - Installs Git with the [Git cookbook](https://supermarket.chef.io/cookbooks/git)
* `default['jenkins-server']['composer']['install']` - Installs Composer with the [Composer cookbook](https://supermarket.chef.io/cookbooks/composer). If `true`, the composer_vendors recipe will install the required [Jenkins-php.org](http://jenkins-php.org) vendors "squizlabs/php_codesniffer", "phploc/phploc", "pdepend/pdepend", "phpmd/phpmd", "sebastian/phpcpd" and "theseer/phpdox" 
* `default['jenkins-server']['composer']['template_cookbook']` - Template cookbook for composer.json. Default "jenkins-server" 
* `default['jenkins-server']['composer']['template_source']` - Template source for composer.json. Default "composer/composer.json.erb" 

### Settings

* `default['jenkins-server']['settings']['executors']` - Number of executors. Default the number of cores with a minimum of 2
* `default['jenkins-server']['settings']['slave_agent_port']` - Port number, or 0 to indicate random available TCP port (default) or -1 to disable this service
* `default['jenkins-server']['settings']['system_email']` - System email address
* `default['jenkins-server']['settings']['mailer']['smtp_host']` - Mailer SMTP host. Default "localhost"
* `default['jenkins-server']['settings']['mailer']['username']` - Mailer username. Default "mailer"
* `default['jenkins-server']['settings']['mailer']['password']` - Mailer password. Default "mailer"
* `default['jenkins-server']['settings']['mailer']['use_ssl']` - If the mailer must use SSL. Default `true`
* `default['jenkins-server']['settings']['mailer']['smtp_port']` - SMTP port. Default "25"
* `default['jenkins-server']['settings']['mailer']['reply_to_address']` - Reply to address. Default `node['jenkins-server']['settings']['system_email']`
* `default['jenkins-server']['settings']['mailer']['charset']` - Mail charset. Default "UTF-8"

### Node monitors

Preventive node monitoring, configures the page http://your-jenkins-host/computer/configure.

* `default['jenkins-server']['node_monitors']['architecture_monitor']['ignored']` - This monitor just shows the architecture of the slave for your information. It never marks the slave offline. Default `false`
* `default['jenkins-server']['node_monitors']['clock_monitor']['ignored']` - This monitors the clock difference between the master and nodes. Default `false`
* `default['jenkins-server']['node_monitors']['disk_space_monitor']['ignored']` - This monitors the available disk space of $JENKINS_HOME on each slave, and if it gets below a threshold, the slave will be marked offline. Default `false`
* `default['jenkins-server']['node_monitors']['disk_space_monitor']['free_space_threshold']` - If a slave is found to have less free disk space than this amount, it will be marked offline. Default "1GB"
* `default['jenkins-server']['node_monitors']['swap_space_monitor']['ignored']` - This monitors the available virtual memory space of the computer (commonly known as "swap space"), and if it goes below a threshold, the slave is marked offline. Default `false`
* `default['jenkins-server']['node_monitors']['temporary_space_monitor']['ignored']` - This monitors the available disk space of the temporary directory, and if it gets below a certain threshold the node will be made offline. Default `false`
* `default['jenkins-server']['node_monitors']['temporary_space_monitor']['free_space_threshold']` - If a slave is found to have less free disk space than this amount, it will be marked offline. Default "1GB"
* `default['jenkins-server']['node_monitors']['response_time_monitor']['ignored']` - This monitors the round trip network response time from the master to the slave, and if it goes above a threshold repeatedly, it marks the slave offline. Default `false`

### Plugins

These plugins are configured by default. See the attributes/default.rb for more details. Read for how to add a plugin the section "Adding plugins" further on.

- **General:** greenballs, locale, antisamy-markup-formatter, gravatar, ws-cleanup, ansicolor, build-monitor-plugin, git and ant
- **Version control:** bitbucket, bitbucket-pullrequest-builder
- **[Jenkins-php.org](http://jenkins-php.org):** checkstyle, cloverphp, crap4j, dry, htmlpublisher, jdepend, plot, pmd, violations, warnings and xunit

### Jobs

Jenkins jobs can be specified with attributes like:

    default['jenkins-server']['jobs']['myjob'] = {
      'cookbook' => 'mycookbook',
      'source' => 'jobs/myjob.xml.erb'
    }
    
By default the "php-template" job is installed from [Jenkins-php.org](http://jenkins-php.org). 

### Views

Jenkins views can be specified with attributes like:

    default['jenkins-server']['views']['myview'] = {
      'class' => 'com.smartcodeltd.jenkinsci.plugins.buildmonitor.BuildMonitorView', # A ListView is default if no class is defined  
      'include_regex' => '.*',
      'description' => 'My view'
    }

* `default['jenkins-server']['views']` - A hash that contains views
* `default['jenkins-server']['purge_views']` - If views must be purged. Default `true`

### Slaves

* `default['jenkins-server']['slaves']['enable']` - If slaves must be enabled. Default `false`
* `default['jenkins-server']['slaves']['credential']['username']` - The Jenkins master will login as this user on slaves. Default "deployer"
* `default['jenkins-server']['slaves']['credential']['description']` - Description. Default "Deployer"
* `default['jenkins-server']['slaves']['search_key']` - Attribute that contains slave settings on a slave node. Default "jenkins-server-slave"
* `default['jenkins-server']['slaves']['search_query']` - The search query for finding slaves. Default `jenkins-server-slave:* AND chef_environment:#{node.chef_environment} AND NOT fqdn:#{node['fqdn']}`

Include or copy the **jenkins_slave** recipe to a cookbook that is in the run list of each server that you want to be a Jenkins slave.

### Dev mode

If you are developing/testing your (wrapper) cookbook locally, chef-vault communication will be very difficult. If you set an attribute `default['dev_mode']` to `true` then these attributes
will be used to setup Jenkins security.

* `default['jenkins-server']['dev_mode']['security']['password']` - This password is used for the GUI login. Default "admin"
* `default['jenkins-server']['dev_mode']['security']['public_key']` - This public key (paired with the private key) is used for Jenkins CLI authentication
* `default['jenkins-server']['dev_mode']['security']['private_key']` - This private key (paired with the public key) is used for Jenkins CLI authentication

### Jenkins

Some attributes that overwrite the [Jenkins cookbook](https://supermarket.chef.io/cookbooks/jenkins) attributes:

* `default['jenkins']['master']['version']` - Jenkins version. Default 1.642-1.1
* `default['jenkins']['master']['jvm_options']` - JVM options. Default "-Xms256m -Xmx256m" which sets the memory usage to 256 MB
* `default['jenkins']['master']['listen_address']` - Listen address. Default "127.0.0.1". So the Jenkins application is only reachable from localhost or through Nginx.

### Java

Some attributes that overwrite the [Java cookbook](https://supermarket.chef.io/cookbooks/java) attributes:

* `default['java']['jdk_version']` - Version. Default 7

## Adding plugins

You can add plugins to the `default['jenkins-server']['plugins']` array.

Add a Jenkins plugin "myplugin" like below. You can specify a version. If you want to configure it, set configure to `true`
and specify a cookbook and recipe. Use the `jenkins_script` resource to configure your plugin with a groovy script.
Take a look at the plugin recipes in this cookbook for examples. 

    default['jenkins-server']['plugins']['myplugin'] = {
      'version' => '1.0',
      'configure' => true,
      'cookbook' => 'mycookbook',
      'recipe' => 'myrecipe_plugin_example'
    }

Plugins can be configured with groovy scripts. Test them at your Jenkins instance:
`http://<host>:8080/script`

With the [doInspector method from javaworld.com](http://www.javaworld.com/article/2073679/detecting-class-innards-in-groovy.html)
you can figure out the properties and methods of your plugin. The Jenkins core API documentation
can be found at [http://javadoc.jenkins-ci.org](http://javadoc.jenkins-ci.org).   

    def doInspector(obj) {
      def inspector = new groovy.inspect.Inspector(obj)
      def inspectorReport = new StringBuilder()
      inspectorReport << "Object under inspection "
      inspectorReport << (inspector.isGroovy() ? "IS" : "is NOT") << " Groovy!\n"
      inspectorReport << "METHODS\n"
      def methods = inspector.methods
      methods.each {
        inspectorReport << "\t" << it.toString() << "\n"
      }
      inspectorReport << "\nMETA METHODS\n"
      def metaMethods = inspector.metaMethods
      metaMethods.each {
        inspectorReport << "\t" << it.toString() << "\n"
      }
      inspectorReport << "\nPROPERTY INFO\n"
      def properties = inspector.propertyInfo
      properties.each {
        inspectorReport << "\t" << it.toString() << "\n"
      }
      println inspectorReport
    }

## Usage

### jenkins-server::default

Include `jenkins-server` in your node's `run_list`:

    json
    {
      "run_list": [
        "recipe[jenkins-server::default]"
      ]
    }

The default recipe includes the following recipies:

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
    include_recipe 'jenkins-server::jobs'
    include_recipe 'jenkins-server::composer'
    
    if node['jenkins-server']['slaves']['enable']
      include_recipe 'jenkins-server::slaves_credentials'
      include_recipe 'jenkins-server::slaves'
    end

### jenkins-server::ssh_identity

If SSH connections are made to other servers during a job, then Jenkins uses by default the private key in
`#{default['jenkins']['master']['home']}/.ssh/id_rsa`. A private/public key pair can be generated with this recipe.

## License

The MIT License (MIT)
 
## Authors

Author:: Pieter Vogelaar (pieter@pietervogelaar.nl) - Freelancer
