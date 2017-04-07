# Configure views
jenkins_script 'configure views' do
  # Set views
  views = []
  node['jenkins-server']['views'].each do |viewName, options|
    viewClass = options['class'].nil? ? 'hudson.model.ListView' : options['class']

    views << <<-EOH
      view = instance.getView('#{viewName}')
      if (!view) {
        view = new #{viewClass}('#{viewName}')
        instance.addView(view)
      }

      view.setIncludeRegex('#{options['include_regex']}')
      view.description = '#{options['description']}'
      view.filterQueue = #{!!options['filter_queue']}
      view.filterExecutors = #{!!options['filter_executors']}
      view.recurse = #{!!options['recurse']}
    EOH
  end

  command <<-EOH.gsub(/^ {4}/, '')
    import jenkins.model.*

    def instance = Jenkins.getInstance()

    // Add views
    #{views.join("\n")}

    // Purge views
    if (#{node['jenkins-server']['purge_views']}) {
      activeViews = #{node['jenkins-server']['views'].keys}

      instance.getViews().each { view ->
        if (!activeViews.contains(view.getViewName()) && view.getViewName() != 'All') {
          instance.deleteView(view)
        }
      }
    }
  EOH
end
