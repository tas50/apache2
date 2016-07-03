if defined?(ChefSpec)
  ChefSpec.define_matcher :apache_conf

  def create_apache_conf(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:apache_conf, :create, resource_name)
  end

  def delete_apache_conf(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:apache_conf, :delete, resource_name)
  end

  ChefSpec.define_matcher :apache_config

  def create_apache_config(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:apache_config, :create, resource_name)
  end

  def delete_apache_config(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:apache_config, :delete, resource_name)
  end

  ChefSpec.define_matcher :apache_mod

  def create_apache_mod(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:apache_mod, :create, resource_name)
  end

  def delete_apache_mod(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:apache_mod, :delete, resource_name)
  end

  ChefSpec.define_matcher :apache_module

  def create_apache_module(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:apache_module, :create, resource_name)
  end

  def delete_apache_module(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:apache_module, :delete, resource_name)
  end

  ChefSpec.define_matcher :apache_site

  def create_apache_site(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:apache_site, :create, resource_name)
  end

  def delete_apache_site(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:apache_site, :delete, resource_name)
  end

  ChefSpec.define_matcher :web_app

  def create_web_app(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:web_app, :create, resource_name)
  end

  def delete_web_app(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:web_app, :delete, resource_name)
  end
end
