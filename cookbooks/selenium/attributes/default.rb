default['selenium']['url'] =
  'https://selenium-release.storage.googleapis.com/3.1/selenium-server-standalone-3.1.0.jar'

default['selenium']['windows']['home'] = "#{ENV['SYSTEMDRIVE']}/selenium"
default['selenium']['windows']['java'] = "#{ENV['SYSTEMDRIVE']}\\java\\bin\\java.exe"

# used by both macosx and linux platforms
default['selenium']['unix']['home'] = '/opt/selenium'
default['selenium']['unix']['java'] = '/usr/bin/java'

if platform?('windows')
  default['selenium']['home'] = node['selenium']['windows']['home']
  default['selenium']['java'] = node['selenium']['windows']['java']
else
  default['selenium']['home'] = node['selenium']['unix']['home']
  default['selenium']['java'] = node['selenium']['unix']['java']
end
