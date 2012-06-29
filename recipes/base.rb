#
# Cookbook Name:: logstash
# Recipe:: base
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
server_data                 = node['logstash']['server_data']
server_etc                  = node['logstash']['server_etc']
server_pid                  = node['logstash']['server_pid']
server_lock                 = node['logstash']['server_lock']
server_logs                 = node['logstash']['server_logs']
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

[server_data, server_pid, server_lock, server_logs].each do |folder|
  directory folder do
    owner server_user
    group server_group
    mode "0755"
  end
end

remote_file "#{server_path}/bin/#{server_file}" do
  source server_download
  checksum server_checksum
  mode 0755
  action :create_if_missing
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
      rm -rf wrapper-delta-pack-#{servicewrapper_version}/conf wrapper-delta-pack-#{servicewrapper_version}/src wrapper-delta-pack-#{servicewrapper_version}/jdoc wrapper-delta-pack-#{servicewrapper_version}/doc wrapper-delta-pack-#{servicewrapper_version}/logs wrapper-delta-pack-#{servicewrapper_version}/jdoc.tar.gz wrapper-delta-pack-#{servicewrapper_version}/README*.*
      cp -rf wrapper-delta-pack-#{servicewrapper_version}/* #{server_path}
      chown -Rf root:root #{server_path}
    EOH
  end
end

link "#{server_path}/config" do
  to server_etc
end

link "#{server_path}/logs" do
  to server_logs
end

template "/etc/init.d/logstash" do                                                            
  source "logstash-init.erb"
  owner "root"
  group "root"
  mode 0755
end
