## [1.0.6] (https://github.com/tas50/hubot/compare/1.0.5...1.0.6)
* Allowing runit to use default log template (logging into /var/log/hubot)
* Rubocop & Foocritic compliance
* Chef & npm dependencies updated
* Now using hubot 2.12.0 in defaults
* Allowing to choose Hubot git source repo ('v' is still appended in the version tag)
* Using nodejs_npm LWRP (from nodejs cookbook) instead of execute resources
* Adding supervisor init system capability (runit is still the default one)
* No longer using --create for new versions of Hubot
* Updated base dependencies for the latest Hubot releases
* Added a new attribute for managing external scripts file
* Remove the chmod of the hubot bin file
* Fixes to the Readme to properly document attributes and requirements

## [1.0.4](https://github.com/tas50/hubot/compare/1.0.3...1.0.4)
Many thanks to Seth for creating this cookbook and for being kind enough to pass the cookbook maintenance onto me. I hope to keep things up to date for all the Hubot users out there.

* Updated Gem dependencies to the latest releases of upstream projects
* Removed Ubuntu 12.10 from test kitchen
* Added a Rubocop config and resolved all rubocop warnings
* Removed the use of Thor
* Use strings for file modes to ensure that the leading 0 is respected
* Don't set nodejs install attributes based on platform. Let users decide how to install NodeJS
* Use https for the git checkout not GIT to work around strict firewalls
* Defaulting package.json "private": true with a new attribute: default['hubot']['private']
* Quote all config vars so that spaces don't cause kabooms
* Use runit's env param so that environment variables can handle numeric values and values with spaces
* Use standard OS baseboxes in kitchen.yml


## [1.0.2](https://github.com/tas50/hubot/compare/1.0.1...1.0.2)

### Bug Fixes

* recursively create the install dir
* install exact version of hubot and hubot-scripts

### New features

* Add `kitchen-ec2` to the Gemfile (allows testing against EC2)

### Improvements

* Sort and append newline to the entries in hubot-scripts.json
* Flesh out the 'Usage' section of the README
* Silence `:rubygems` Bundler deprecation notice.
* Download Ubuntu base boxes from cloud-images.ubuntu.com. Thanks
  [@jeremiahsnapp]!

## [1.0.1](https://github.com/tas50/hubot/compare/1.0.0...1.0.1)

### Bug Fixes

* Install node.js from source on all platform families except Debian. This is
a workaround for issue mdxp/nodejs-cookbook#19 in the upstream `nodejs`
cookbook. Installing node.js from RPM is no longer possible on
Fedora/RHEL/CentOS as the packages are no longer maintained.

### New features

* test-kitchen 1.0 support

### Improvements

* A CHANGELOG!
* Pull request [#1](https://github.com/tas50/hubot/pull/1): Fix typo in README. ([@streeter])
* Remove references to CentOS 5.5 support
* Add proper supports fields to metadata

## 1.0.0

* The initial release. Cookbooks was inspired by internal cookbook Opscode uses to
deploy our instance of `hubot`, but refactored/modenerized based on current
cookbook development best practices.

[@schisamo]: https://github.com/schisamo
[@streeter]: https://github.com/streeter
[@jeremiahsnapp]: https://github.com/jeremiahsnapp
