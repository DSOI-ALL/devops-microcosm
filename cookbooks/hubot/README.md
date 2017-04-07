hubot cookbook
================
[![Build Status](https://travis-ci.org/tas50/hubot.svg)](https://travis-ci.org/tas50/hubot)

Deploys and manages an instance of [GitHub's Hubot](http://hubot.github.com/).

# Usage

Include `recipe[hubot]` in your run_list and override the defaults you want
changed. See [below](#attributes) for more details. Hubot instances are
configured using environment variables passed to the Hubot process. These
environment variables can be set using the `node['hubot']['config']` attribute.

I hightly recommend integrating this cookbook into your own infrastruce using
the
[library/application cookbook pattern](http://devopsanywhere.blogspot.com/2012/11/how-to-write-reusable-chef-cookbooks.html).
You would start by creating a `YOURCOMPANY-hubot` cookbook with a proper
metadata depedency on the `hubot` (this) cookbook. A concrete example can be
found [on this gist](https://gist.github.com/schisamo/46eafba27d43c4a1e026)
which was created from bits of the internal `opscode-hubot` cookbook which we
use to deploy, Paula Deen, Opscode's hubot instance.

One important item to note is the use of the
[remote_directory](http://docs.opscode.com/resource_remote_directory.html)
resource to distribute our internal hubot scripts to the install:

```ruby
remote_directory "#{node['hubot']['install_dir']}/scripts" do
  source "scripts"
  files_backup 0
  files_owner node['hubot']['user']
  files_group node['hubot']['group']
  files_mode '0644'
  owner node['hubot']['user']
  group node['hubot']['group']
  overwrite true
  mode '0755'
  notifies :restart, "service[hubot]", :delayed
end
```

# Requirements

## Chef

Tested on Chef 11/12

## Platform

The following platforms have been tested with this cookbook, meaning that the
recipes and LWRPs run on these platforms without error:

* Ubuntu 10.04+
* RHEL/Centos 6

## Cookbooks

This cookbook depends on the following external cookbooks:

* [nodejs](https://supermarket.chef.io/cookbooks/nodejs)
* [git](https://supermarket.chef.io/cookbooks/git)
* [runit](https://supermarket.chef.io/cookbooks/runit)
* [supervisor](https://supermarket.chef.io/cookbooks/supervisor)

# Recipes

## default

* Ensures that Node.js is installed and available using the
  [nodejs cookbook](http://community.opscode.com/cookbooks/nodejs).
* Ensures git is installed and available using the
  [git cookbook](http://community.opscode.com/cookbooks/git).
* Ensures runit is installed and available using the
  [runit cookbook](http://community.opscode.com/cookbooks/runit).
* Creates a user and group to install and run the Hubot instance under.
* Installs the specified Hubot version from git.
* Renders instance-specific `package.json`, `external-scripts.json`, `hubot-scripts.json`, and
 `hubot.conf` files.
* Creates and enables a `hubot` runit service to run the Hubot instance under.
  The runit service reads the `hubot.conf` file and passes the contents onto
  the underlying hubot process as configuraiton.

# Attributes

Attribute       | Description |Type | Default
----------------|-------------|-----|--------
version         | Hubot version to install. | String  | 2.11.0      |
scripts_version | Version of [hubot-scripts](https://github.com/github/hubot-scripts) (community collection of hubot scripts) to install. | String | 2.5.16
install_dir     | Directory the Hubot instance will be installed to. | String | /opt/hubot
user            | The user to install and run the Hubot instance under. | String | hubot
group           | The group to install and run the Hubot instance under. | String | hubot
name            | The name of the robot in chat. | String | hubot
adapter         | The [Hubot adapter](https://github.com/github/hubot/blob/master/docs/adapters.md) to use. | String | campfire
config          | Hash of values that will be converted into environment variables and passed to the Hubot process. | Hash | Hash.new
dependencies    | Hash in form `dep_name => dep_version` that will be rendered into Hubot instance's `package.json`. A common dep to set in this attribute is non-Campfire adapters. | Hash | Hash.new
hubot_scripts   | Scripts to enable from the [community collection of hubot scripts](https://github.com/github/hubot-scripts). | Array | Array.new
external_scripts| External scripts to enable. | Array | Array.new

# Testing

This cookbook ships with full support for the new alpha version of Opscode's
`test-kitchen`. [Fletcher Nichol's](https://github.com/fnichol) excellent Jamie
integration test runner was
[recently merged into the test-kitchen codebase](http://lists.opscode.com/sympa/arc/chef-dev/2013-01/msg00038.html).
This merge and all new feature work are now taking place in the
[1.0 branch of test-kitchen](https://github.com/opscode/test-kitchen/tree/1.0).
Even though many community members have been dogfooding the new `test-kitchen`
codebase and it has proven quite stable, it should still be regarded as
pre-release code and YMMV.

Running integration with test-kitchen is easy. First we'll assume you have a
sane cookbook development toolchain installed which includes:

* Git
* Ruby 1.9.x
* Bundler
* VirtualBox 4.x

If you need help setting up this toolchain, take a read through the
"[System Setup](http://vialstudios.com/guide-authoring-cookbooks.html#system_setup)"
section of [Jamie Winsor's](https://github.com/reset) excellent cookbook
authoring guide.

First install all gem dependencies with Bundler:

```shell
$ bundle install --binstubs
```

Bundler will install all of the dependent RubyGems and guarantee that you have
the right versions. Now it's time to get your test on:

```shell
$ bundle exec kitchen test
```

This command will do the following across every platform/version this cookbook
supports:

* Use Vagrant to provision a platform-specific VM.
* Add a `recipe[hubot]` entry to the instance's run_list.
* Converge the VM with `chef-solo`.

By default, any VM that successfully converges will automaticallly be cleaned
up. The full set of `kitchen` subcommands can be viewed by running:

```shell
$ bundle exec kitchen help
```

# Development

* Source hosted at [GitHub][repo]
* Report issues/Questions/Feature requests on [GitHub Issues][issues]

I <3 pull requests! Make sure your patches are well tested. Ideally create a
topic branch for every separate feature/fix you make.

# License and Author

Author:: [Seth Chisamore][schisamo] (<schisamo@gmail.com>)

Author:: [Tim Smith][tas50] (<tsmith84@gmail.com>)

Copyright (c) 2013-2015, Seth Chisamore

Copyright (c) 2015, Tim Smith

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

