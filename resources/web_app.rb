#
# Cookbook Name:: apache2
# Resource:: web_app
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

resource_name :web_app
provides :web_app

property :application_name, String, name_property: true
property :template, String, default: 'web_app.conf.erb'
property :local, kind_of: [TrueClass, FalseClass], default: false
property :enable, kind_of: [TrueClass, FalseClass], default: true
property :server_port, Integer, default: 80
property :cookbook, String
property :params, kind_of: Hash, default: {}

default_action :create

action :create do
  #  declare_resource(:service, 'apache2', run_context: Chef.run_context, create_if_missing: true) do
  #    action :nothing
  #  end

  template "#{node['apache']['dir']}/sites-available/#{application_name}.conf" do
    source new_resource.template
    local new_resource.local
    owner 'root'
    group node['apache']['root_group']
    mode 0o644
    cookbook new_resource.cookbook if property_is_set?(:cookbook)
    variables(
      :application_name => application_name,
      :params           => params
    )
    if ::File.exist?("#{node['apache']['dir']}/sites-enabled/#{application_name}.conf")
      notifies :reload, 'service[apache2]', :delayed
    end
  end

  apache_site new_resource.application_name do
    enable new_resource.enable
  end
end
