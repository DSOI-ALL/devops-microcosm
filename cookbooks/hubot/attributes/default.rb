#
# Cookbook Name:: hubot
# Attributes:: default
#
# Copyright (c) 2013, Seth Chisamore
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['hubot']['git_source'] = 'https://github.com/github/hubot.git'
default['hubot']['version'] = '2.12.0'
default['hubot']['scripts_version'] = '2.5.16'
default['hubot']['install_dir'] = '/opt/hubot'
default['hubot']['user'] = 'hubot'
default['hubot']['group'] = 'hubot'
default['hubot']['private'] = true

default['hubot']['name'] = 'hubot'
default['hubot']['adapter'] = 'campfire'
default['hubot']['config'] = {}
default['hubot']['dependencies'] = {}
default['hubot']['hubot_scripts'] = []
default['hubot']['external_scripts'] = []

# Choose daemonize program: 'runit' or 'supervisor'
default['hubot']['daemon'] = 'runit'

# runit stuff
default['hubot']['runit']['default_logger'] = false # Use true to log to /var/log/hubot

# supervisor stuff
default['hubot']['supervisor']['stdout_logfile'] = '/var/log/hubot.log'
default['hubot']['supervisor']['stdout_logfile_maxbytes'] = '10MB'
default['hubot']['supervisor']['stdout_logfile_backups'] = 10
default['hubot']['supervisor']['stderr_logfile'] = '/var/log/hubot_error.log'
default['hubot']['supervisor']['stderr_logfile_maxbytes'] = '10MB'
default['hubot']['supervisor']['stderr_logfile_backups'] = 10
