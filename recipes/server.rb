#
# Cookbook Name:: logstash
# Recipe:: server
#
# Copyright 2012, SourceIndex IT-Serives
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

server_user                 = node['logstash']['server_user']
server_group                = node['logstash']['server_group']
server_download             = node['logstash']['server_download']
server_version              = node['logstash']['server_version']
server_file                 = node['logstash']['server_file']
server_checksum             = node['logstash']['server_checksum']
server_path                 = node['logstash']['server_path']
server_etc                  = node['logstash']['server_etc']
server_pid                  = node['logstash']['server_pid']
server_lock                 = node['logstash']['server_lock']
server_plugins              = node['logstash']['server_plugins']
server_logs                 = node['logstash']['server_logs']
server_data                 = node['logstash']['server_data']
servicewrapper_path         = node['logstash']['servicewrapper_path']
servicewrapper_download     = node['logstash']['servicewrapper_download']
servicewrapper_version      = node['logstash']['servicewrapper_version']
servicewrapper_file         = node['logstash']['servicewrapper_file']
servicewrapper_checksum     = node['logstash']['servicewrapper_checksum']

include_recipe "java"

group server_group do
  system true
end

user server_user do
  home server_data
  gid server_group
  shell "/bin/bash"
end

[server_path, server_etc, "#{server_path}/bin"].each do |folder|
  directory folder do
    owner "root"
    group "root"
    mode "0755"
  end
end

[server_pid, server_lock, server_data, server_logs].each do |folder|
  directory folder do
    owner server_user
    group server_group
    mode "0755"
  end
end

unless FileTest.exists?("#{server_path}/bin/#{server_file}")
  #remote_file "#{Chef::Config[:file_cache_path]}/#{server_file}" do
  remote_file "#{server_path}/bin/#{server_file}" do
    source server_download
    checksum server_checksum
    action :create_if_missing
  end
end

unless FileTest.exists?("#{server_path}/service/logstash")
  remote_file "#{Chef::Config[:file_cache_path]}/#{servicewrapper_file}" do
    source servicewrapper_download
    checksum servicewrapper_checksum
    action :create_if_missing
  end

  bash "extract logstash service wrapper" do
    cwd Chef::Config[:file_cache_path]
    code <<-EOH
      tar -zxf #{servicewrapper_file} 
      mv logstash-logstash-servicewrapper-#{servicewrapper_version}/service #{server_path}/bin
      chown -Rf root:root #{server_path}/bin/service
    EOH
  end
end

template "/etc/init.d/logstash" do
  source "logstash-init.erb"
  owner "root"
  group "root"
  mode 0755
end

link "#{server_path}/config" do
  to server_etc
end

link "#{server_path}/logs" do
  to server_logs
end

link "#{server_path}/data" do
  to server_data
end

link "/usr/bin/logstash-plugins" do
  to "#{server_path}/bin/plugin"
end

template "#{server_etc}/logstash.conf" do
  source "logstash.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

template "#{server_etc}/logstash.yml" do
  source "logstash.yml.erb"
  owner "root"
  group "root"
  mode 0644
end

template "#{server_etc}/logging.yml" do
  source "logging.yml.erb"
  owner "root"
  group "root"
  mode 0644
end

ruby_block "install logstash plugins" do
  block do
    plugins.split(',').each do |plugin_url|
      plugin_name = plugin_url.split('/').last.split('-').last
      plugins_installed = Dir.foreach(server_plugins)
      unless plugins_installed.any? { |plugins_any| plugins_any.include?("#{plugin_name}") }
        Chef::Log.info("install logstash plugin #{plugin_url}")
        cmd = Chef::ShellOut.new(%Q[ #{server_path}/bin/plugin -install #{plugin_url} ]).run_command
      end
    end
  end
  action :create
end

service "logstash" do
  supports :restart => true, :status => true
  action [:enable, :start]
end
