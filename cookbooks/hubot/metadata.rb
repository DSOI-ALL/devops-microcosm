name             'hubot'
maintainer       'Tim Smith'
maintainer_email 'tsmith84@gmail.com'
license          'Apache 2.0'
description      "Deploys and manages an instance of Github's Hubot."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.6'

supports 'ubuntu', '>= 10.04'
supports 'centos', '>= 6.0'
supports 'redhat', '>= 6.0'

depends 'git'
depends 'nodejs'
depends 'runit'
depends 'supervisor'
