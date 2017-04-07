# 0.7.5 (2016-03-17)

- Moved views configuration to a separate recipe so that views provided by plugins can be used

# 0.7.4 (2016-03-17)

- Views are managed

# 0.7.3 (2016-03-15)

- All JIRA groups that are allowed to authenticate get the overall read permission
- Global security is set every run instead of only the first run

# 0.7.2 (2016-03-09)

- Added slave purge

# 0.7.1 (2016-02-16)

- Updated slaves search key in the jenkins_slave recipe

# 0.7.0 (2016-02-16)

- BC break: Changed search key so that it's easy to configure

# 0.6.0 (2016-01-27)

- Fixed some foodcritic rules
- Set Jenkins to the latest LTS version
- Node monitors can be configured
- Added Chef Solo support
- Basic authentication header must not be disabled

# 0.5.5 (2015-12-11)

- Fixes "undefined method `[]' for nil:NilClass" error introduced in 0.5.4

# 0.5.4 (2015-12-10)

- Added jenkins_script "configure crowd permissions" for Jenkins authentication with a JIRA account
- Added documentation about the ssh_identity recipe

# 0.5.3 (2015-12-03)

- Made executed resource after admin user creation configurable
- Added security strategy with "generate" as default instead of "chef-vault"

# 0.5.2 (2015-10-28)

- Implemented alternative plugin configuration with a template. This fixes the flapping locale plugin configuration on jenkins restart.
- Set mailer defaults to use the local system mail by default
- Set ProjectMatrixAuthorizationStrategy instead of GlobalMatrixAuthorizationStrategy
- Added ssh_identity recipe to generate a SSH identity with Ruby in the Jenkins home folder

# 0.5.1 (2015-10-02)

- Fixes: Jenkins is not restarted after installing plugins for the first time
- Added type.chef_environment so that environment is not empty in production
- Set Nginx default_site_enabled to false
- Added chef-vault dependency

# 0.5.0 (2015-09-06)

- BC break: SSH slaves are found with a search on a node attribute instead of a data bag. The creation of a
  data bag item from a recipe requires admin permissions which is not desirable.

# 0.4.0 (2015-08-28)

- Added support for SSH slaves

# 0.3.2 (2015-08-22)

- Added an attribute to configure global properties in Jenkins
- Fixes bug: Nginx server block for Jenkins is not default

# 0.3.1 (2015-07-24)

- Updated changelog

# 0.3.0 (2015-07-24)

- Added Nginx
- Added composer
- Added composer vendor install for jenkins-php packages
- Added jobs recipe
- Added user settings recipe that fixes missing home folder files and shell 
- Added more Jenkins settings

# 0.2.0 (2015-07-19)

- Added configurable plugins
- Added configurable Jenkins settings
- Added Java, Ant and Git package

# 0.1.1 (2015-07-13)

- Documentation improvements
- Better attribute defaults

# 0.1.0 (2015-07-12)

Initial release of jenkins-server
