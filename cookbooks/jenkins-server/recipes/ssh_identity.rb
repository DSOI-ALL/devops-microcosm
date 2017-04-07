# Generates a SSH identity file in the Jenkins home folder

# Install sshkey gem into chef
chef_gem 'sshkey'
require 'sshkey'

# Base location of ssh key
id_key_path = node['jenkins']['master']['home'] + '/.ssh/id_rsa'
id_key_comment = "#{node['jenkins']['master']['user']}@#{node['fqdn']}"

# Generate a SSH key pair
sshkey = SSHKey.generate(
  type: 'RSA',
  bits:  4096,
  comment: id_key_comment
)

# Create ~/.ssh directory
directory "#{node['jenkins']['master']['home']}/.ssh" do
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode '0700'
end

# Store private key on disk
file id_key_path do
  content sshkey.private_key
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode '0600'
  action :create_if_missing
end

# Store public key on disk
file "#{id_key_path}.pub" do
  content sshkey.ssh_public_key
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode '0644'
  action :create_if_missing
end
