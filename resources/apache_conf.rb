#
# Cookbook Name:: apache2
# Definition:: apache_conf
#
# Copyright 2008-2013, Chef Software, Inc.
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

resource_name :apache_conf
provides :apache_conf

property :name, String, name_property: true
property :conf_path, String
property :enable, kind_of: [TrueClass, FalseClass], default: true
property :source, String
property :cookbook, String

default_action :create

action :create do
  conf_name = "#{new_resource.name}.conf"
  new_resource.conf_path = new_resource.conf_path || "#{node['apache']['dir']}/conf-available"

  #  declare_resource(:service, 'apache2', run_context: Chef.run_context, create_if_missing: true) do
  #    action :nothing
  #  end

  file "#{new_resource.conf_path}/#{new_resource.name}" do
    action :delete
  end

  has_cookbook_property = property_is_set?(:cookbook)

  template "#{new_resource.conf_path}/#{conf_name}" do
    source new_resource.source || "#{conf_name}.erb"
    cookbook new_resource.cookbook if has_cookbook_property
    owner 'root'
    group node['apache']['root_group']
    backup false
    mode '0644'
    notifies :restart, 'service[apache2]', :delayed
  end

  if new_resource.enable
    apache_config new_resource.name do
      enable true
    end
  end
end
