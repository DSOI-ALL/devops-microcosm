chef_gem 'chef-helpers'
require 'chef-helpers'

# Install plugins
Chef::Log.debug '[JENKINS-SERVER] Installing plugins'

node['jenkins-server']['plugins'].each do |plugin, options|
  if options
    jenkins_plugin plugin do
      version options['version']
    end

    if !options['configure'].nil? && options['configure'].to_s == 'template'
      if options.key?('template_cookbook') && !options['template_cookbook'].nil?
        template_cookbook = options['template_cookbook']
      else
        template_cookbook = 'jenkins-server'
      end

      if options.key?('template_source') && !options['template_source'].nil?
        template_source = options['template_source']
      else
        template_source = "jenkins/plugins/#{plugin}.xml.erb"
      end

      if options.key?('template_path') && !options['template_path'].nil?
        template_path = options['template_path']
      else
        template_path = "#{plugin}.xml"
      end

      if has_template?(template_source, template_cookbook)
        template "#{node['jenkins']['master']['home']}/#{template_path}" do
          cookbook template_cookbook
          source template_source
          mode '0644'
          owner node['jenkins']['master']['user']
          group node['jenkins']['master']['group']
          action :create
        end
      else
        Chef::Log.debug "No template found for source \"#{template_source}\" in cookbook \"#{template_cookbook}\""
      end
    end
  end
end

# Restart jenkins for the first time and set a flag
unless node.attribute?('jenkins_restarted_once')
  Chef::Log.debug '[JENKINS-SERVER] First time Jenkins restart'

  service 'jenkins restart' do
    service_name 'jenkins'
    action :restart
  end

  node.set['jenkins_restarted_once'] = true

  unless Chef::Config[:solo]
    node.save
  end
end

# Configure plugins
Chef::Log.debug '[JENKINS-SERVER] Configure Jenkins plugins'

node['jenkins-server']['plugins'].each do |plugin, options|
  if !options['configure'].nil? && (options['configure'] == true || options['configure'] == 'recipe')
    cookbook = options.key?('cookbook') && !options['cookbook'].nil? ? options['cookbook'] : 'jenkins-server'
    recipe = options.key?('recipe') && !options['recipe'].nil? ? options['recipe'] : "plugin_#{plugin}"

    include_recipe "#{cookbook}::#{recipe}"
  end
end