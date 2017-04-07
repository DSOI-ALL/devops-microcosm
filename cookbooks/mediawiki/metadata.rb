name             'mediawiki'
maintainer       'Ryan Lewkowicz'
maintainer_email 'ryan.lewkowicz@spindance.com'
license          'MIT'
description      'Installs/Configures mediawiki'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.14'

depends 'docker', '>= 2.9.2'
depends 'ark'
