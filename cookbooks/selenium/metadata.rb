name 'selenium'
maintainer 'Dennis Hoer'
maintainer_email 'dennis.hoer@gmail.com'
license 'MIT'
description 'Installs/Configures Selenium'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url 'https://github.com/dhoer/chef-selenium'
issues_url 'https://github.com/dhoer/chef-selenium/issues'
version '5.0.0'

chef_version '>= 12.14'

supports 'centos'
supports 'debian'
supports 'fedora'
supports 'mac_os_x'
supports 'redhat'
supports 'ubuntu'
supports 'windows'

depends 'macosx_autologin', '>= 4.0'
depends 'nssm', '>= 3.0'
depends 'windows'
depends 'windows_autologin', '>= 3.0'
