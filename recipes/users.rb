#
# Cookbook Name:: base2
# Recipe:: users
#
# Copyright (C) 2014 base2Services
#
# All rights reserved - Do Not Redistribute
#

base2_user_create = true
base2_user_name = node['common']['user']
base2_user_home_dir = "/home/#{base2_user_name}"
base2_user_shell = '/bin/bash'
base2_user_sudoer = true
base2_user_ssh_dir = "#{base2_user_home_dir}/.ssh"

# Create SOE user necessary?
if !base2_user_create
  return
end

# Validate specified shell
if !File.exist?(base2_user_shell)
  Chef::Application.fatal!("Invalid shell (#{base2_user_shell}) provided for '#{base2_user_name}' user.", 1)
end

# Create SOE user
log "Creating the '#{base2_user_name}' user..."
user "#{base2_user_name}" do
  home "#{base2_user_home_dir}"
  shell "#{base2_user_shell}"
  supports :manage_home => true
  action :create
end

# SSH dir
if !File.directory?("#{base2_user_ssh_dir}")
  directory "#{base2_user_ssh_dir}" do
    owner "#{base2_user_name}"
    group "#{base2_user_name}"
    mode 00700
    action :create
  end
end

# Authorized keypairs configuration
cookbook_file "#{base2_user_ssh_dir}/authorized_keys" do
  source "home/#{base2_user_name}/.ssh/authorized_keys"
  mode 00600
  owner "#{base2_user_name}"
  group "#{base2_user_name}"
  action :create
end

# SOE sudoer configuration
if base2_user_sudoer
  log "Creating the '#{base2_user_name}' sudoers partial..."
  cookbook_file "/etc/sudoers.d/#{base2_user_name}" do
    source "etc/sudoers.d/#{base2_user_name}"
    mode 00440
    owner 'root'
    group 'root'
    action :create_if_missing
  end
end