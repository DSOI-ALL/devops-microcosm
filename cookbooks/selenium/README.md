# Selenium Cookbook

[![Cookbook Version](http://img.shields.io/cookbook/v/selenium.svg?style=flat-square)][cookbook]
[![linux](http://img.shields.io/travis/dhoer/chef-selenium/master.svg?label=linux&style=flat-square)][linux]
[![osx](http://img.shields.io/travis/dhoer/chef-selenium/macosx.svg?label=macosx&style=flat-square)][osx]
[![win](https://img.shields.io/appveyor/ci/dhoer/chef-selenium/master.svg?label=windows&style=flat-square)][win]

[cookbook]: https://supermarket.chef.io/cookbooks/selenium
[linux]: https://travis-ci.org/dhoer/chef-selenium/branches
[osx]: https://travis-ci.org/dhoer/chef-selenium/branches
[win]: https://ci.appveyor.com/project/dhoer/chef-selenium

This cookbook installs and configures Selenium 3+ (http://www.seleniumhq.org/).

This cookbook comes with the following recipes:

- **[default](https://github.com/dhoer/chef-selenium#default)** - Downloads and installs Selenium Standalone jar.
- **[hub](https://github.com/dhoer/chef-selenium#hub)** - Installs and configures a Selenium Hub as a service.
- **[node](https://github.com/dhoer/chef-selenium#node)** - Installs and configures a Selenium Node as service
 on Linux and a GUI service on Mac OS X and Windows.
 
Resources [selenium_hub](https://github.com/dhoer/chef-selenium#selenium_hub) and 
[selenium_node](https://github.com/dhoer/chef-selenium#selenium_node) are also available.

## Usage

See [selenium_grid](https://github.com/dhoer/chef-selenium_grid#selenium-grid-cookbook) cookbook that wraps selenium, 
browsers, drivers, and screenresolution cookbooks into one comprehensive cookbook.

## Requirements

- Java (not installed by this cookbook)
- Chef 12.6+ 

### Platforms

- CentOS, Fedora, RedHat
- Mac OS X
- Debian, Ubuntu
- Windows

### Cookbooks

- nssm - Required by Windows services only (e.g. Hub and HtmlUnit running in background)
- macosx_autologin - Required by Mac OS X GUI services 
- windows 
- windows_autologin - Required by Windows GUI service

## Recipes

## default

Downloads and installs Selenium Standalone jar.

### Attributes

- `node['selenium']['url']` - The download URL of Selenium Standalone jar. 
- `node['selenium']['windows']['home']` -  Home directory. Default `#{ENV['SYSTEMDRIVE']}/selenium`.
- `node['selenium']['windows']['java']` -  Path to Java executable. Default 
`#{ENV['SYSTEMDRIVE']}\\java\\bin\\java.exe`.
- `node['selenium']['unix']['home']` -  Home directory. Default `/opt/selenium`. 
- `node['selenium']['unix']['java']` -  Path to Java executable. Default `/usr/bin/java`.

## hub

Installs and configures a Selenium Hub as a service.

### Attributes

See [selenium_hub](https://github.com/dhoer/chef-selenium#attributes-3)
resource attributes for description.
 
## node

Installs and configures a Selenium Node as service on Linux and a GUI 
service on Mac OS X and Windows.

- Firefox browser must be installed outside of this cookbook.
- Linux nodes without a physical monitor require a headless display
(e.g., [xvfb](https://supermarket.chef.io/cookbooks/xvfb), 
[x11vnc](https://supermarket.chef.io/cookbooks/x11vnc),
etc...) and must be installed and configured outside this cookbook.
- Mac OS X/Windows nodes must run as a GUI service and that requires a 
username and password for automatic login. Note that Windows password 
is stored unencrypted under windows registry
`HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon` and 
Mac OS X  password is stored encrypted under `/etc/kcpassword` but it 
can be easily decrypted.

### Attributes

See [selenium_hub](https://github.com/dhoer/chef-selenium#attributes-4)
resource attributes for description.
    
### Example

#### Install Selenium Node with Firefox and HtmlUnit capabilities

```ruby
node.override['selenium']['node']['username'] = 'vagrant' if platform?('windows', 'mac_os_x')
node.override['selenium']['node']['password'] = 'vagrant' if platform?('windows', 'mac_os_x')

node.override['selenium']['node']['capabilities'] = [
  {
    browserName: 'firefox',
    maxInstances: 5,
    seleniumProtocol: 'WebDriver'
  },
  {
    browserName: 'htmlunit',
    maxInstances: 1,
    platform: 'ANY',
    seleniumProtocol: 'WebDriver'
  }
]
  
include_recipe 'selenium::node'
```

## Resources

## selenium_hub

Installs and configures a Selenium Hub as a service.

### Attributes

- `servicename` - Name attribute. The name of the service.
- `host` - IP or hostname. Usually determined automatically. Most 
commonly useful in exotic network configurations (e.g. network with 
VPN). Default `nil`.
- `port` - The port number the server will use. Default: `4444`.
- `jvm_args` -  JVM options, e.g., -Xms2G -Xmx2G. Default: `nil`.
- `newSessionWaitTimeout` - The time (in ms) after which a new test 
waiting for a node to become available will time out. When that happens, 
the test will throw an exception before attempting to start a browser. 
An unspecified, zero, or negative value means wait indefinitely.
Default: `-1`.
- `prioritizer` - A class implementing the Prioritizer interface. 
Specify a custom Prioritizer if you want to sort the order in which new 
session requests are processed when there is a queue. 
Default to null ( no priority = FIFO ).
- `servlets` - List of extra servlets the grid (hub or node) will make 
available. The servlet must exist in the path, e.g.,
/grid/admin/Servlet. Default: `[]`.
- `withoutServlets` - List of default (hub or node) servlets to disable. 
Advanced use cases only. Not all default servlets can be disabled. 
Default: `[]`.
- `capabilityMatcher` - A class implementing the CapabilityMatcher 
interface. Specifies the logic the hub will follow to define whether a 
request can be assigned to a node. For example, if you want to have the 
matching process use regular expressions instead of exact match when 
specifying browser version. ALL nodes of a grid ecosystem would then 
use the same capabilityMatcher, as defined here.
Default: `org.openqa.grid.internal.utils.DefaultCapabilityMatcher`
- `throwOnCapabilityNotPresent` -  If true, the hub will reject all test 
requests if no compatible proxy is currently registered. If set to 
false, the request will queue until a node supporting the capability is 
registered with the grid. Default: `true`.
- `cleanUpCycle` -  Specifies how often the hub will poll (in ms) 
running proxies for timed-out (i.e. hung) threads. Must also specify 
"timeout" option. Default: `5000`.
- `debug` -  Enables LogLevel.FINE. Default: `false`.
- `timeout` -  Specifies the timeout before the server automatically 
kills a session that hasn't had any activity in the last X seconds. 
The test slot will then be released for another test to use. This is 
typically used to take care of client crashes. For grid hub/node roles, 
cleanUpCycle must also be set. Default: `1800`.
- `browserTimeout` -  Number of seconds a browser session is allowed to 
hang while a WebDriver command is running (example: driver.get(url)). 
If the timeout is reached while a WebDriver command is still processing, 
the session will quit. Minimum value is `60`. An unspecified, zero, 
or negative value means wait indefinitely. Default: `0`.
- `maxSession` - Max number of tests that can run at the same time on 
the node, irrespective of the browser used. Default: `5`.
- `jettyMaxThreads` - Max number of threads for Jetty. An unspecified, 
zero, or negative value means the Jetty default value (200) will be 
used. Default: `-1`.
- `log` - The filename to use for logging. If omitted, will log to 
STDOUT. Default: `nil`. 

## selenium_node

Installs and configures a Selenium Node as a service.

### Attributes

- `servicename` - Name attribute. The name of the service.
- `host` - IP or hostname. Usually determined automatically. Most 
commonly useful in exotic network configurations (e.g. network with 
VPN). Default `nil`.
- `port` - The port number the server will use. Default: `5555`.
- `hub` - The url that will be used to post the registration request. 
Default: `http://localhost:4444`.
- `jvm_args` -  JVM options, e.g., -Xms2G -Xmx2G. Default: `nil`.
- `proxy` -  The class used to represent the node proxy. 
Default: `org.openqa.grid.selenium.proxy.DefaultRemoteProxy`.
- `maxSession` - Max number of tests that can run at the same time on 
the node, irrespective of the browser used. Default: `5`.
- `register` -  Node will attempt to re-register itself automatically 
with its known grid hub if the hub becomes unavailable. Default: `true`.
- `registerCycle` -  Specifies (in ms) how often the node will try to 
register itself again. Allows administrator to restart the hub without 
restarting (or risk orphaning) registered nodes. Must be specified with 
the "register" option. Default: `5000`.
- `nodeStatusCheckTimeout` -  When to time out a node status check. 
Default: `5000`.
- `nodePolling` - Specifies (in ms) how often the hub will 
poll to see if the node is still responding. Default: `5000`.
- `unregisterIfStillDownAfter` - If the node remains down for more 
than specified (in ms), it will stop attempting to re-register from the 
hub. Default: `60000`.
- `downPollingLimit` - Node is marked as "down" if the node hasn't 
responded after the number of checks specified. Default: `2`.
- `debug` -  [TrueClass, FalseClass], default: false
- `servlets` - List of extra servlets the grid (hub or node) will make 
available. The servlet must exist in the path, e.g.,
/grid/admin/Servlet. Default: `[]`.
- `withoutServlets` - List of default (hub or node) servlets to disable. 
Advanced use cases only. Not all default servlets can be disabled. 
Default: `[]`.
- `debug` -  Enables LogLevel.FINE. Default: `false`.
- `timeout` -  Specifies the timeout before the server automatically 
kills a session that hasn't had any activity in the last X seconds. 
The test slot will then be released for another test to use. This is 
typically used to take care of client crashes. For grid hub/node roles, 
cleanUpCycle must also be set. Default: `1800`.
- `browserTimeout` -  Number of seconds a browser session is allowed to 
hang while a WebDriver command is running (example: driver.get(url)). 
If the timeout is reached while a WebDriver command is still processing, 
the session will quit. Minimum value is `60`. An unspecified, zero, 
or negative value means wait indefinitely. Default: `0`.
- `jettyMaxThreads` - Max number of threads for Jetty. An unspecified, 
zero, or negative value means the Jetty default value (200) will be 
used. Default: `-1`.
- `log` - The filename to use for logging. If omitted, will log to 
STDOUT. Default: `nil`. 
- `capabilities` -  Based on 
[capabilities](https://code.google.com/p/selenium/wiki/DesiredCapabilities). Default `[]`.
- Mac OS X/Windows only - Set both username and password to run as a GUI service:
    - `username` - Default `nil`.
    - `password` - Default `nil`. Note that Windows password is stored unencrypted under windows registry
`HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon` and Mac OS X  password is stored encrypted under 
`/etc/kcpassword` but it can be easily decrypted.
    - `domain` - Optional for Windows only.  Default `nil`.

### Example

#### Install Selenium Node with Firefox and HtmlUnit capabilities

```ruby
selenium_node 'selenium_node' do
  username 'vagrant' if platform?('windows', 'mac_os_x')
  password 'vagrant' if platform?('windows', 'mac_os_x')
  capabilities [
    {
      browserName: 'firefox',
      maxInstances: 5,
      seleniumProtocol: 'WebDriver'
    },
    {
      browserName: 'htmlunit',
      maxInstances: 1,
      platform: 'ANY',
      seleniumProtocol: 'WebDriver'
    }
  ]
  action :install
end
```

## ChefSpec Matchers

This cookbook includes custom 
[ChefSpec](https://github.com/sethvargo/chefspec) matchers you can use 
to test your own cookbooks.

Example Matcher Usage

```ruby
expect(chef_run).to install_selenium_hub('resource_name').with(
  port: '4444'
)
```
      
Selenium Cookbook Matchers

- install_selenium_hub(resource_name)
- install_selenium_node(resource_name)

## Getting Help

- Ask specific questions on 
[Stack Overflow](http://stackoverflow.com/questions/tagged/selenium).
- Report bugs and discuss potential features in 
[Github issues](https://github.com/dhoer/chef-selenium/issues).

## Contributing

Please refer to [CONTRIBUTING](https://github.com/dhoer/chef-selenium/blob/master/CONTRIBUTING.md).

## License

MIT - see the accompanying 
[LICENSE](https://github.com/dhoer/chef-selenium/blob/master/LICENSE.md) 
file for details.
