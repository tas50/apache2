#
# Cookbook Name:: apache2
# Resource:: apache_config
#
# Copyright 2016, Alexander van Zoest
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
resource_name :apache_config
provides :apache_config

property :conf_name, String, name_property: true
property :conf_path, String, default: "#{node['apache']['dir']}/conf-available"
property :enable, kind_of: [TrueClass, FalseClass], default: true

default_action :create

action :create do
  #  declare_resource(:service, 'apache2', run_context: Chef.run_context, create_if_missing: true) do
  #    action :nothing
  #  end

  if new_property.enable
    execute "a2enconf #{conf_name}" do
      command "/usr/sbin/a2enconf #{conf_name}"
      notifies :restart, 'service[apache2]', :delayed
      not_if do
        ::File.symlink?("#{node['apache']['dir']}/conf-enabled/#{conf_name}") &&
          (::File.exist?(conf_path) ? ::File.symlink?("#{node['apache']['dir']}/conf-enabled/#{conf_name}") : true)
      end
    end
  else
    execute "a2disconf #{conf_name}" do
      command "/usr/sbin/a2disconf #{conf_name}"
      notifies :reload, 'service[apache2]', :delayed
      only_if { ::File.symlink?("#{node['apache']['dir']}/conf-enabled/#{conf_name}") }
    end
  end
end

action :delete do
  #  declare_resource(:service, 'apache2', run_context: Chef.run_context, create_if_missing: true) do
  #    action :nothing
  #  end

  execute "a2disconf #{conf_name}" do
    command "/usr/sbin/a2disconf #{conf_name}"
    notifies :reload, 'service[apache2]', :delayed
    only_if { ::File.symlink?("#{node['apache']['dir']}/conf-enabled/#{conf_name}") }
  end
end
