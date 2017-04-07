# Configure Jenkins jobs
Chef::Log.debug '[JENKINS-SERVER] Configure Jenkins jobs'

node['jenkins-server']['jobs'].each do |job, options|
  file = File.join(Chef::Config[:file_cache_path], "#{job}.xml")

  # Create the job template in the Chef cache directory
  template file do
    cookbook options.key?('cookbook') ? options['cookbook'] : 'jenkins-server'
    source options.key?('source') ? options['source'] : "jobs/#{job}.xml.erb"
  end

  # Create the Jenkins job
  jenkins_job job do
    config file
  end
end
