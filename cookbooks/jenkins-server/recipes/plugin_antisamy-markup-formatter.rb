plugin = node['jenkins-server']['plugins']['antisamy-markup-formatter']

if plugin['markup'] === 'safe_html'
  # Safe HTML (the name RawHtml is misleading and old but is still there for backwards compatibility)
  # Allowed HTML: https://github.com/jenkinsci/antisamy-markup-formatter-plugin/blob/master/src/main/java/hudson/markup/MyspacePolicy.java
  formatter = "new RawHtmlMarkupFormatter(#{plugin['disable_syntax_highlighting'] ? 'true' : 'false'})"
else
  # Plain text
  formatter = 'new EscapedMarkupFormatter()'
end

jenkins_script 'configure plugin antisamy-markup-formatter' do
  command <<-EOH.gsub(/^ {4}/, '')
    import jenkins.model.*
    import hudson.markup.*

    def instance = Jenkins.getInstance()

    instance.setMarkupFormatter(#{formatter})
  EOH
end




