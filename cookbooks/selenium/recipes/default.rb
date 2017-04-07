package 'unzip' unless platform?('windows', 'mac_os_x')

dirs = %w(config server)
dirs.push('bin', 'log') if platform?('windows')

dirs.each do |dir|
  directory "#{selenium_home}/#{dir}" do
    recursive true
    action :create
  end
end

url = node['selenium']['url']
target = "#{selenium_home}/server/#{url.split('/')[-1]}"

remote_file target do
  source url
  mode '0775'
  not_if { ::File.exist?(target) }
end

link selenium_jar_link do
  to target
end
