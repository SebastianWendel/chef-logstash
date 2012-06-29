#
# Author:: Sebastian Wendel
# Cookbook Name:: logstash
# Attribute:: default
#
# Copyright 2012, SourceIndex IT-Services
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

# SERVER BINARY
default['logstash']['server_version'] = "1.1.0.1"
default['logstash']['server_url'] = "http://semicomplete.com/files/logstash/"
default['logstash']['server_file'] = "logstash-#{node['logstash']['server_version']}-monolithic.jar"
default['logstash']['server_download'] = "#{node['logstash']['server_url']}/#{node['logstash']['server_file']}"
default['logstash']['server_checksum'] = "2a4b0aa6853e6abc1328bc7107f80cd4dcdd4ef15e88ca4d44cb0c5f8560014e"

# SERVICE-WRAPPER BINARY
default['logstash']['servicewrapper_version'] = "3.5.14"
default['logstash']['servicewrapper_url'] = "http://wrapper.tanukisoftware.com/download/#{node['logstash']['servicewrapper_version']}/"
default['logstash']['servicewrapper_file'] = "wrapper-delta-pack-#{node['logstash']['servicewrapper_version']}.tar.gz"
default['logstash']['servicewrapper_download'] = "#{node['logstash']['servicewrapper_url']}/#{node['logstash']['servicewrapper_file']}/"
default['logstash']['servicewrapper_checksum'] = "8098efc957bd94b07f7da977d946c94a167a1977b4e32aac5ca552c99fe0c173"

# SERVER CONFIG
default['logstash']['server_path'] = "/usr/share/logstash"
default['logstash']['server_etc'] = "/etc/logstash"
default['logstash']['server_pid'] = "/var/run/logstash"
default['logstash']['server_lock'] = "/var/lock/logstash"
default['logstash']['server_logs'] = "/var/log/logstash"
default['logstash']['server_data'] = "/var/lib/logstash"
default['logstash']['server_user'] = "logstash"
default['logstash']['server_group'] = "logstash"

