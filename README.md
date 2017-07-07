# Microcosm: A Secure DevOps Pipeline Example via IaC

## Prerequisites

### personal access token with github.com

- top-right menu -> Settings
- left menu (bottom) -> Personal access tokens
- click 'Generate..'
- select 'Public repo'

### Vagrant and VirtualBox recommended versions

Vagrant 1.9.3
VirtualBox 5.1.18

## Environment Creation via IaC

	git clone https://github.com/SLS-ALL/devops-microcosm.git
	cd devops-microcosm	
	vagrant box add metadata.json

- jenkins
- gitlab
- selenium
- owasp 
- mediawiki (+ bugzilla + hubot)
- staging

## Dev/Build/Deploy Configuration

To get started, first bring up all  VMs (i.e. 'jenkins', 'gitlab', 'staging', 'selenium', 'owaspZap', 'mediaWiki' )

	vagrant up 

When each VM is ready, proceed with the configuration steps below for each.

Note: You can also create each VM , one at a time by running  'vagrant up <VMName>' like 

      vagrant up gitlab 

      
### on 'gitlab' VM : http://localhost:8083

1. Visit http://localhost:8083
2. set root password on gitlab 
	- username (default): root
	- password: 1amd3v0p5 (or your own choice)
3. register new account
4. add `spring-petclinic` project
	1. on GitLab dashboard, click 'new project'
	2. click 'import project from github'
	3. enter personal access token (created above)
	2. click 'import' next to 'spring-petclinic' to import
	3. nav to project and select HTTP clone URL for the next step
5. clone project into dev box
	- on your host command line in ./projects - NOTE: you must change 'localhost' to 'localhost:8083' in the HTTP clone URL
	
			git clone <HTTP clone URL> 
		
6. (optional) add 'github' as additional remote for upstream changes

	This local clone is connected to your GitLab VM and simulates the ability to collaborate changes with your development team, however the real 'spring-petclinic' repository at GitHub.com may undergo real changes. Adding this remote enables you to sync upstream changes:	

		cd spring-petclinic
		git remote add github https://github.com/SLS-ALL/spring-petclinic.git
		
	After this, sync upstream changes with:
	
		git pull github master # - pull github changes to this checkout
		git pull # - ensure you are synced with your gitlab VM repo 
		git push # - push any commits that were pulled from the github repo to your gitlab VM repo

That's it! You now have a local GitLab server running and holding your project code. You also have a clone of your project checked-out and ready for development.

### on 'jenkins' VM : http://localhost:8082

1. Visit http://localhost:8082
1. Validate Jenkins install, initial plugins and user account	    
	- copy administrator password from /var/log/jenkins/jenkins.log and paste into form when prompted
	
			vagrant ssh jenkins
			sudo tail -n 30 /var/log/jenkins/jenkins.log
		
	- click to install 'suggested plugins'
	- register new account
		- click 'Save and Finish'!

2. Add Maven Tool
	- click "Manage Jenkins"
	- click "Global Tool Configuration"
	- click "Add Maven"
		- the form may not expand the first time. sometimes one or more page refreshes is required before this works. 
	- enter "petclinic" as name
	- click Apply and then click Save

3. Install Additional Plugins
	- click "Manage Jenkins"
	- click "Manage Plugins"
	- select 'Available' tab
	- search: "owasp"
	- select: Official OWASP ZAP Jenkins Plugin
	- search: "maven"
	- select: Maven Integration Plugin 
	- search: "ansible"
	- select: Ansible plugin
	- click "install without restart" at bottom of page
    - check box next to "Restart Jenkins when installation is complete and no jobs are running."
    - at top-left menu, click "back to Dashboard"
    - NOTE: Jenkins will restart in the background and the UI may appear to be hung - you may need to refresh the page

4. Add spring-petclinic project
	- click "New Item", enter "petclinic" as name, choose "Freestyle", and click OK
	- under Source Code Management, select 'git'
	- beside Credentials, click Add -> Jenkins
	- select "Username with password"
	- enter your GitLab credentials (see 'gitlab' VM instructions above) and click Add
	- enter repository URL: http://<username>@<gitlab VM private network IP>/<username>/spring-petclinic.git
		- NOTE: this is the HTTP URL from the GitLab project page where 'localhost' is replaced by the 'gitlab' VM's private network IP (in this case 10.1.1.3)
	- select appropriate credentials 
	- Add build step -> Invoke top-level Maven targets
		- Leave default values
	- Add build step -> Invoke Ansible Playbook
		- Playbook path: deploy.yml
		- Inventory: File or host list: /etc/ansible/hosts
		- beside Credentials, click Add -> Jenkins
			- select "SSH Username with private key"
			- Username: vagrant
			- Private Key: "From a file on Jenkins master": /etc/ansible/vagrant_id_rsa
		- Credentials: select 'vagrant'
	- click Apply and then click Save

## Workflow

1. Develop!
2. Build and Deploy!
	- In the Jenkins UI project view, click "Build Now" on left hand side of screen, or on the main dashboard click the icon to schedule a build
3. Visit http://localhost:8087/petclinic/

## Document/Test Configuration

### on 'selenium' VM: http://localhost:4444/wd/hub

##### - Documentation for Selenium Standalone Server

1. Login to the Desktop VirtualBox instance of the selenium VM created upon a "vagrant up" with default vagrant credentials.

2. Open a terminal and escalate to root.

3. Type "java -jar /opt/selenium/2.53/selenium-server-standalone-2.53.0.jar &" to run the Selenium standalone server as a background process.

4. Enter "localhost:4444/wd/hub" in the browser to access the Selenium Standalone Server web interface.

### on 'owaspZap' VM:

##### - Documentation for Owasp Zap

1. Login to the Desktop VirtualBox instance of the owaspZap VM created upon a "vagrant up" with default vagrant credentials.

2. Open a terminal and escalate to root.
  
3. Type "/opt/zapproxy/ZAP_2.6.0/./zap.sh" to launch the Owasp Zap application.  

### on 'mediaWiki' VM: http://localhost:8086

#### Wiki (Mediawiki), Issue Tracker (Bugzilla), Chat Server (Hubot)

##### - Documentation for MediaWiki

1. Browse to "http://localhost:8086/wiki" to access the MediaWiki web interface.

2. Login with the administrator credentials specified in the MediaWiki cookbook to begin customization.

##### - Documentation for Bugzilla

1. Type "http://localhost:8086/bugzilla-5.0/" in your browser to access the Bugzilla web interface.

2. Login to the administrator account with the credentials used in the "checksetup_config.erb" recipe template to configure your issue tracking service.

##### -  Manual configuration steps for Hubot

1. Upon a successful "vagrant up", ssh into the VM using "vagrant ssh mediaWiki".

2. Navigate to "/home/vagrant/myhubot" as the vagrant user.

3. Type "yo hubot --defaults" to create a hubot with the default settings.

4. Type "bin/hubot" while in the hubot directory to start your hubot bot.

5. The "myhubot>" prompt should appear. Type "myhubot help" for a list of available commands.
