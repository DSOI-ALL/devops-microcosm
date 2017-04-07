if defined?(ChefSpec)
  def install_selenium_hub(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:selenium_hub, :install, resource_name)
  end

  def install_selenium_node(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:selenium_node, :install, resource_name)
  end
end
