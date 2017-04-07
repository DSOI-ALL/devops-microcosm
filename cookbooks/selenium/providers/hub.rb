use_inline_resources

def whyrun_supported?
  true
end

def config
  config_file = "#{selenium_home}/config/#{new_resource.servicename}.json"
  template config_file do
    source 'hub_config.erb'
    cookbook 'selenium'
    variables(
      resource: new_resource
    )
    notifies :restart, "service[#{new_resource.servicename}]", :delayed unless platform_family?('windows', 'mac_os_x')
    if platform_family?('mac_os_x')
      notifies :run, "execute[reload #{selenium_mac_domain(new_resource.servicename)}]",
               :delayed
    end
  end
  config_file
end

def args
  args = []
  args << new_resource.jvm_args unless new_resource.jvm_args.nil?
  args << %W(-jar "#{selenium_jar_link}" -role hub -hubConfig "#{config}")
  args.flatten!
end

action :install do
  unless run_context.loaded_recipe? 'selenium::default'
    recipe_eval do
      run_context.include_recipe 'selenium::default'
    end
  end

  case node['platform']
  when 'windows'
    selenium_windows_service(new_resource.servicename, selenium_java_exec, args)
    selenium_windows_firewall(new_resource.servicename, new_resource.port)
  when 'mac_os_x'
    plist = "/Library/LaunchDaemons/#{selenium_mac_domain(new_resource.servicename)}.plist"
    selenium_mac_service(new_resource, selenium_java_exec, args, plist, nil)
  else
    selenium_linux_service(new_resource.servicename, selenium_java_exec, args, new_resource.port, nil)
  end
end
