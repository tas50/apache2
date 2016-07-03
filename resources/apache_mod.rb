#
# Cookbook Name:: apache2
# Resource:: apache_mod
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
resource_name :apache_mod
provides :apache_mod

property :name, String, name_property: true

default_action :create

action :create do
  #  declare_resource(:service, 'apache2', run_context: Chef.run_context, create_if_missing: true) do
  #    action :nothing
  #  end

  template "#{node['apache']['dir']}/mods-available/#{new_resource.name}.conf" do
    source "mods/#{new_resource.name}.conf.erb"
    mode '0644'
    notifies :reload, 'service[apache2]', :delayed
  end
end
