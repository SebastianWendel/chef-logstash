#
# Cookbook Name:: logstash
# Recipe:: agent
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

include_recipe "logstash::base"

template "#{node['logstash']['server_etc']}/servicewrapper.conf" do
  source "servicewrapper_agent.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

template "#{node['logstash']['server_etc']}/logstash.conf" do
  source "logstash.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

service "logstash" do
  supports :restart => true, :status => true
  action [:enable, :start]
end
