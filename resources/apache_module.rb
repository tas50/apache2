#
# Cookbook Name:: apache2
# Resource:: apache_module
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

resource_name :apache_module
provides :apache_module

property :module_name, String, name_property: true
property :enable, kind_of: [TrueClass, FalseClass], default: true
property :conf, kind_of: [TrueClass, FalseClass], default: false
property :restart, kind_of: [TrueClass, FalseClass], default: false
property :filename, String
property :module_path, String
property :identifier, String

default_action :create

action :create do
  new_resource.filename = "mod_#{module_name}.so" unless property_is_set?(:filename)
  new_resource.module_path = "#{node['apache']['libexec_dir']}/#{new_resource.filename}" unless property_is_set?(:module_path)
  new_resource.identifier = "#{new_resource.module_name}_module" unless property_is_set?(:identifier)
  apache_mod new_resource.module_name if new_resource.conf

  #  declare_resource(:service, 'apache2', run_context: Chef.run_context, create_if_missing: true) do
  #    action :nothing
  #  end

  file "#{node['apache']['dir']}/mods-available/#{new_resource.module_name}.load" do
    content "LoadModule #{new_resource.identifier} #{new_resource.module_path}\n"
    mode 0o644
  end

  if new_resource.enable
    execute "a2enmod #{new_resource.module_name}" do
      command "/usr/sbin/a2enmod #{new_resource.module_name}"
      if new_resource.restart
        notifies :restart, 'service[apache2]', :delayed
      else
        notifies :reload, 'service[apache2]', :delayed
      end
      not_if do
        ::File.symlink?("#{node['apache']['dir']}/mods-enabled/#{new_resource.module_name}.load") &&
          (::File.exist?("#{node['apache']['dir']}/mods-available/#{new_resource.module_name}.conf") ? ::File.symlink?("#{node['apache']['dir']}/mods-enabled/#{new_resource.module_name}.conf") : true)
      end
    end
  else
    execute "a2dismod #{new_resource.module_name}" do
      command "/usr/sbin/a2dismod #{new_resource.module_name}"
      if new_resource.restart
        notifies :restart, 'service[apache2]', :delayed
      else
        notifies :reload, 'service[apache2]', :delayed
      end
      only_if { ::File.symlink?("#{node['apache']['dir']}/mods-enabled/#{new_resource.module_name}.load") }
    end
  end
end
