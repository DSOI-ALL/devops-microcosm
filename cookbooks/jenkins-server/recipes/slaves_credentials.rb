# You must add a private/public key pair (id_rsa and id_rsa.pub) in the jenkins home dir (/var/lib/jenkins/.ssh)
# with a wrapper cookbook or manually

# Add a global jenkins credential that will use the private key of the jenkins home dir.
# Jenkins slaves can use this credential.

username = node['jenkins-server']['slaves']['credential']['username']

if username # ~FC023
  # Add this credential only once
  unless node.attribute?("jenkins-server_add_credential_#{username}_done")
    jenkins_script "add_credential_#{username}" do
      command <<-EOH.gsub(/^ {4}/, '')
    import jenkins.model.*
    import com.cloudbees.plugins.credentials.*
    import com.cloudbees.plugins.credentials.common.*
    import com.cloudbees.plugins.credentials.domains.*
    import com.cloudbees.jenkins.plugins.sshcredentials.impl.*
    import hudson.plugins.sshslaves.*;

    def global_domain = Domain.global()
    def credentials_store = Jenkins.instance.getExtensionList(
        'com.cloudbees.plugins.credentials.SystemCredentialsProvider'
    )[0].getStore()

    def credentials = new BasicSSHUserPrivateKey(
      CredentialsScope.GLOBAL,
      null,
      '#{node['jenkins-server']['slaves']['credential']['username']}',
      new BasicSSHUserPrivateKey.UsersPrivateKeySource(),
      '',
      '#{node['jenkins-server']['slaves']['credential']['description']}'
    )

    credentials_store.addCredentials(global_domain, credentials)
      EOH
    end

    node.set["jenkins-server_add_credential_#{username}_done"] = true

    unless Chef::Config[:solo]
      node.save
    end
  end
end
