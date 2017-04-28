PREREQUISITES

	set up personal access token with github.com
		- top-right menu -> Settings
		- left menu (bottom) -> Personal access tokens
		- click 'Generate..'
		- select 'Public repo'

SETUP

	git pull voltron
	vagrant up
		- jenkins
		- gitlab
		- selenium
		- owasp 
		- mediawiki (+ bugzilla + hubot)
		- UNCOMMENT STAGING VM -> fix IP, forwarded ports, etc for Tomcat
			(DEV BOX?)

POST

	GITLAB : http://localhost:8082

		set password on gitlab 
			- username (default): root
			- password: 1amd3v0p5
		create new project on gitlab
			pull from github.com
			enter personal access token (created above)
			import spring-petclinic
			nav to project, select HTTP clone URL
		on command line in ./projects
			git clone <HTTP clone URL> 
				- if HOST, then CHANGE 'localhost' to 'localhost:8082' 
				- if in VM (STAGING VM), then CHANGE 'localhost' to '10.1.1.7' (:80)
				- NEED TO DECIDE one or the other - whichever is done, pull/push from that point forward need to be in the same environment

	JENKINS : http://localhost:8080
	
	  - Ansible playbook to deploy the built "petclinic.war" file has been placed on the VM in /home/vagrant
	
	    *Until chef template is scripted:
	    
	    -Once machine is successfully built/provisioned after vagrant up, ssh into VM using "vagrant ssh jenkins"
	    - Type "sudo vi /etc/ansible/hosts". By default, this entire file will be commented out.
	    - Define a host group (examples in the file are provided), called [DevOps] and on the next line type "10.1.1.7" (IP address of the staging VM)
	    - Save the file & exit 
	     

		Pull Jenkins administrator password from log (/var/log/jenkins) and click through configuration
		manage jenkins ->
		- click "Global Tool Configuration"
		- scroll to bottom and click "Add Maven": Enter "petclinic" as name. Click apply and save
		- click "Back to Manage Jenkins"
		-> click "Manage Plugins"
			- search: owasp
			- select: Official OWASP ZAP Jenkins Plugin
			- search: Maven Integration Plugin
			- select: Maven Integration Plugin - click "install without restart at bottom of page"
			    - check box next to "Restart Jenkins when installation is complete and no jobs are running."
		click "New Item" -> enter "petclinic" as name & choose "Maven Project"
			Add Jenkins credentials -> root:1amd3v0p5
			Repository URL: http://10.1.1.7/root/spring-petclinic.git
			Under "Build": enter "/var/lib/jenkins/workspace/petclinic/pom.xml"
			Select 'root' credentials
			click "Build Now" on left hand side of screen
			
		-Deploy created "petclinic.war" to Staging VM
		    - ssh into the jenkins vm with "vagrant ssh jenkins" (you will be in /home/vagrant where "deploy.yml" is located)
		    - from this location, run "ansible-playbook deploy.yml --ask-become-pass --ask-pass" to run the commands in the ansible playbook
		        - you should be prompted for an ssh password and for a sudo password. Enter "vagrant" for the ssh password, and press "enter" for the sudo password prompt
		        
		- To validate that "petclinic.war" deployed successfully, ssh into the Staging VM and navigate to "/var/lib/webapps". The "petclinic.war" file should be there.        

	MEDIAWIKI

		HUBOT FAILING
		APACHE ALIAS CONFIG FOR BUGZILLA/MEDIAWIKI

	OWASP 

		CONFIGURE FOR STAGING FRONT END
		FIGURE OUT HOW TO GET RESULTS IN A NICE WAY

	SELENIUM



