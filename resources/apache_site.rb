#
# Cookbook Name:: apache2
# Definition:: apache_site
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
resource_name :apache_site
provides :apache_site

property :site_name, String, name_property: true
property :enable, kind_of: [TrueClass, FalseClass], default: true
property :conf_name, String

default_action :create

action :create do
  new_resource.conf_name = "#{new_resource.site_name}.conf" unless property_is_set?(:conf_name)

  #  declare_resource(:service, 'apache2', run_context: Chef.run_context, create_if_missing: true) do
  #    action :nothing
  #  end

  if new_resource.enable
    execute "a2ensite #{new_resource.conf_name}" do
      command "/usr/sbin/a2ensite #{new_resource.conf_name}"
      notifies :reload, 'service[apache2]', :delayed
      not_if do
        ::File.symlink?("#{node['apache']['dir']}/sites-enabled/#{new_resource.conf_name}") ||
          ::File.symlink?("#{node['apache']['dir']}/sites-enabled/000-#{new_resource.conf_name}")
      end
      only_if { ::File.exist?("#{node['apache']['dir']}/sites-available/#{new_resource.conf_name}") }
    end
  else
    execute "a2dissite #{new_resource.conf_name}" do
      command "/usr/sbin/a2dissite #{new_resource.conf_name}"
      notifies :reload, 'service[apache2]', :delayed
      only_if do
        ::File.symlink?("#{node['apache']['dir']}/sites-enabled/#{new_resource.conf_name}") ||
          ::File.symlink?("#{node['apache']['dir']}/sites-enabled/000-#{new_resource.conf_name}")
      end
    end
  end
end
