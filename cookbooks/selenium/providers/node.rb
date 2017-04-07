use_inline_resources

def whyrun_supported?
  true
end

def config
  config_file = "#{selenium_home}/config/#{new_resource.servicename}.json"
  template config_file do
    source 'node_config.erb'
    cookbook 'selenium'
    variables(resource: new_resource)
    if platform_family?('windows')
      notifies :request_reboot, "reboot[Reboot to start #{new_resource.servicename}]", :delayed
    end
    notifies :restart, "service[#{new_resource.servicename}]", :delayed unless platform_family?('windows', 'mac_os_x')
    if platform_family?('mac_os_x')
      notifies :run, "execute[reload #{selenium_mac_domain(new_resource.servicename)}]",
               :immediately
    end
  end
  config_file
end

def args
  args = []
  args << new_resource.jvm_args unless new_resource.jvm_args.nil?
  args << %W(-jar "#{selenium_jar_link}" -role node -nodeConfig "#{config}")
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
    selenium_windows_gui_service(new_resource.servicename, selenium_java_exec, args, new_resource.username)
    selenium_autologon(new_resource.username, new_resource.password)

    selenium_windows_firewall(new_resource.servicename, new_resource.port)

    reboot "Reboot to start #{new_resource.servicename}" do
      action :nothing
      reason 'Need to reboot when the run completes successfully.'
      delay_mins 1
    end
  when 'mac_os_x'
    plist = if new_resource.username && new_resource.password
              "/Library/LaunchAgents/#{selenium_mac_domain(new_resource.servicename)}.plist"
            else
              "/Library/LaunchDaemons/#{selenium_mac_domain(new_resource.servicename)}.plist"
            end

    selenium_mac_service(new_resource, selenium_java_exec, args, plist, new_resource.username)
    selenium_autologon(new_resource.username, new_resource.password)

    execute "Reboot to start #{selenium_mac_domain(new_resource.servicename)}" do
      command 'sudo shutdown -r +1'
      action :nothing
    end
  else
    selenium_linux_service(
      new_resource.servicename, selenium_java_exec, args, new_resource.port, new_resource.xdisplay
    )
  end
end
