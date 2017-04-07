# Changelog

## 5.0.0 2017-03-24

- Rename display attribute to xdisplay to be Chef 13 compatible

## 4.1.0 2017-02-27

- Selenium release 3.1.0

## 4.0.0 2017-02-17

- Support Selenium 3.0
- Log defaults to STDOUT when log attribute is nil
- Drop support for Chef 11

## 3.7.4 2016-10-29

- Fix #31 Adding support for selenium 3 in node config file

## 3.7.3 2016-08-22

- Fix #29 Error executing action run on resource 'execute[reload org.seleniumhq.selenium_hub]'

## 3.7.2 2016-08-04

- Fix #27 Cannot create directory due to insufficient permissions

## 3.7.1 2016-07-21

- Selenium release 2.53.1

## 3.7.0 2016-06-25

- Add support for systemd

## 3.6.1 2016-04-13

- No more native HtmlUnitDriver, removed integration test
- Include default recipe in provide only if required
- Include windows::bootstrap_handler recipe in provide only if required

## 3.6.0 2016-03-22

- Selenium release 2.53.0

## 3.5.0 2016-02-18

- Selenium release 2.52.0

## 3.4.0 2016-02-10

- Selenium release 2.51.0

## 3.3.1 2016-01-29

- Selenium release 2.50.1

## 3.3.0 2016-01-28

- Selenium release 2.50.0

## 3.2.1 2015-10-11

- Selenium release 2.48.2

## 3.2.0 2015-10-07

- Selenium release 2.48.0
- Fix #23 WARN: Cannot create resource windows_service with more than one argument

## 3.1.1 2015-09-27

- Fix #22 Firefox on Ubuntu fails to start 

## 3.1.0 2015-09-26

- Fix FC052: Metadata uses the unimplemented "suggests" keyword

## 3.0.0 2015-09-17

- Merge server recipe into default recipe
- Replace server_version, release_url and override attributes with just url attribute
- Replace server_name attribute and provision name attribute with just servername attribute
- Move drivers to their own cookbooks
- Remove PhantomJS 

## 2.8.1 2015-08-24

- Fix #20 Unable to set hub and node recipe attributes 

## 2.8.0 2015-08-21

- Add hub and node recipes

## 2.7.0 2015-08-21

- Allow custom arguments to be added to node service
- Allow custom download url for selenium standalone jar

## 2.6.0 2015-08-02

- Support Safari

## 2.5.2 2015-08-02

- Fix #18 Selenium iedriver does not extract 

## 2.5.1 2015-07-31

- Update Selenium and IE driver from 2.46.0 to 2.47.0
- Update ChromeDriver from 2.15 to 2.16

## 2.5.0 2015-07-29

- Deprecate PhantomJS 

## 2.4.2 2015-06-29

- Add powershell_version check

## 2.4.1 2015-06-29

- Fix #16 Errror provisioning chromedriver on centos7
- Fix #15 Drivers not copied to /selenium/drivers/ folders on Windows 7

## 2.4.0 2015-06-09

- Allow resources to be globally configured

## 2.3.3 2015-06-09

- Fix #13 org.openqa.selenium.WebDriverException: chrome not reachable on CentOS 7.0/Ubuntu 14.04

## 2.3.2 2015-06-04

- Update Selenium and IE driver from 2.45.0 to 2.46.0

## 2.3.1 2015-05-26

- Add supports 'mac_os_x' to metadata

## 2.3.0 2015-05-26

- Add support for Mac OS X (Chef 11.14 or higher required)

## 2.2.6 2015-05-26

- Fix #11 chromedriver version does not update
- Update ChromeDriver from 2.14 to 2.15

## 2.2.5 2015-05-01

- Fix #10 'failed to allocate memory' exception on Windows 2008

## 2.2.4 2015-04-12

- Fix selenium_node provider depends on windows
- Set Windows display resolution in selenium_test cookbook

## 2.2.3 2015-03-23

- Wrap host and hubHost in quotes in node config
- Update IE driver from 2.44.0 to 2.45.0

## 2.2.2 2015-02-26

- Firefox 36 breaks WebDriver 2.44.0

## 2.2.1 2015-02-18

- Update ChromeDriver from 2.12 to 2.14

## 2.2.0 2015-02-05

- Make Windows service an option for HtmlUnit and PhantomJS

## 2.1.0 2015-02-02

- Support HtmlUnit

## 2.0.0 2015-02-02

- Replace PhantomJS attributes

## 1.0.0 2015-02-01

- Initial release
