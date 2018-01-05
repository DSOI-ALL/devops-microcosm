# Microcosm: A Secure DevOps Pipeline Example via IaC

## Prerequisites

### personal access token with github.com

- top-right menu -> Settings
- left menu (Developer Settings) -> Personal access tokens
- click 'Generate..'
- select 'Public repo'

### create free Slack workspace and add Hubot/Jenkins Slack apps

- go to "https://slack.com/get-started" and follow the instructions to creeate a new Slack workspace if you don't have one already
- once a workspace ahs been created, navigate to the "browse apps" page within your workspace
- for Hubot:
    - search for "Hubot" and fill out the appropriate fields to generate a Hubot app within slack
        - Note the "HUBOT_SLACK_TOKEN" that begins with xoxb. This will be need to be included with initiating the Hubot bot from the command line 
        to connect your local Hubot bot to the Slack workspace
- for Jenkins:    
    - follow the instructions given at "https://www.youtube.com/watch?v=TWwvxn2-J7E" to install the Jenkins Slack app
        - Note: "Team Domain" will be replaced with Jenkins Base URL
    
### Vagrant and VirtualBox recommended versions

Vagrant 1.9.3
VirtualBox 5.1.18

### Docker and Docker-Compose recommended versions

Docker 17.09.0-ce
Docker-Compose 1.16.1

## Environment Creation via IaC Using Separate VMs

	git clone https://github.com/SLS-ALL/devops-microcosm.git
	cd devops-microcosm	
	vagrant box add metadata.json

- jenkins (+ owaspZAP + selenium)
- gitlab
- mediawiki (+ bugzilla + hubot)
- staging

## Dev/Build/Deploy Configuration

To get started, first bring up all  VMs (i.e. 'jenkins', 'gitlab', 'staging', 'mediaWiki' )

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

### on 'jenkins' VM : http://localhost:8088

1. Visit http://localhost:8088
2. Validate Jenkins install, initial plugins and user account	    
	- copy administrator password from /var/log/jenkins/jenkins.log and paste into form when prompted
	
			vagrant ssh jenkins
			sudo tail -n 30 /var/log/jenkins/jenkins.log
		
	- click to install 'suggested plugins'
	- register new account
		- click 'Save and Finish'!

3. Add Maven Tool
	- click "Manage Jenkins"
	- click "Global Tool Configuration"
	- click "Add Maven"
		- the form may not expand the first time. sometimes one or more page refreshes is required before this works. 
	- enter "petclinic" as name
	- click Apply and then click Save

4. Install Additional Plugins
	- click "Manage Jenkins"
	- select 'Available' tab
	- search: "owasp"
	- select: Official OWASP ZAP Jenkins Plugin
	- search: Git Plugin
	- select Git Plugin
	- search: "maven"
	- select: Maven Integration Plugin 
	- search: "ansible"
	- select: Ansible plugin
	- seach: "custom tools"
	- select: "Custom Tools Plugin"
	- search "Summary Display"
	- select "Summary Display Plugin"
	- search: "Selenium HTML Report"
	- select "Selenium HTML Report"
	- search "HTML Publisher"
	- select "HTML Publisher Plugin"
	- search "Slack Notification Plugin"
	- select "Slack notification Plugin"
	- click "install without restart" at bottom of page
    - check box next to "Restart Jenkins when installation is complete and no jobs are running."
    - at top-left menu, click "back to Dashboard"
    - NOTE: Jenkins will restart in the background and the UI may appear to be hung - you may need to refresh the page

5. Create Custom Tool for Owasp Zap Plugin
    - click "Manage Jenkins"
    - click "Global Tool Configuration"
    - click "Custom Tool Installations"
    - click "Add Custom tool"
    - enter "ZAP_2.6.0" in the "name" field
    - click the "Install automatically" checkbox
    - enter "https://github.com/zaproxy/zaproxy/releases/download/2.6.0/ZAP_2.6.0_Linux.tar.gz" in the "Download URL for binary archive" field
    - enter "ZAP_2.6.0" in the "Subdirectory of extracted archive" field
    - click apply and then click save
    
6. Add Global Slack Notifier Configurations    
    - follow the instructions given at "https://www.youtube.com/watch?v=TWwvxn2-J7E" to enter the appropriate configuration information in Jenkins to
    link the Jenkins service to your Slack workspace

7. Add spring-petclinic project 
	- click "New Item", enter "petclinic" as name, choose "Freestyle", and click OK
	- under Source Code Management, select 'git'
	- beside Credentials, click Add -> Jenkins
	- select "Username with password"
	- enter your GitLab credentials (see 'gitlab' VM instructions above) and click Add
	- enter repository URL: http://<username>@<gitlab VM private network IP>/<username>/spring-petclinic.git
		- NOTE: this is the HTTP URL from the GitLab project page where 'localhost' is replaced by the 'gitlab' VM's private network IP (ex: http://10.1.1.3/root/spring-petclinic.git)
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
    - Click Apply and then click Save
8. Build and Deploy!
    - In the Jenkins UI project view, click "Build Now" on left hand side of screen, or on the main dashboard click the icon to schedule a build
        - NOTE: One initial build must be completed in order to create the appropriate Jenkins workspace. This is workspace will be the home of the ZAP session files generated through 
        ZAP GUI, as well as the ZAP vulnerability Reports.
    
9. Add OwaspZap build step
    - Navigate to the desktop instance of the "Jenkins" VM which contains owaspZap and launch a terminal
    - Type "sudo /opt/zapproxy/ZAP_2.6.0/./zap.sh" to launch the owasZap GUI as root
    - The user will be promtped to persist the current session of ZAP
        - Click "Yes" to persist the session and specify the Jenkins workspace that was created upon the initial successful build of petclinic as the place to save the ZAP session files
        - ex: petclinicSession.session 
    - click "add build step" and select "Execute ZAP"
    - Under "Admin Configurations" enter:
        - localhost in the "Override Host" field
        - 8090 in the "Override Port" field 
    - Under "Java" "InheritFromJob" should automatically be chosen in the JDK field
    - Under "Installation Method" choose "Custom Tools Installation"
        - Choose "ZAP_2.6.0" (the name of the custom tool that was created in step 5)
    - Under "ZAP Home Directory" enter:
        - "~/.ZAP" for Linux
        - "~/Library/Application Support/ZAP" for Mac OS
        - "C:\Users\<username>\OWASP ZAP" for Windows 7/8
        - "C:\Documents and Settings\<username>\OWASP ZAP" for Windows XP
    - Under "Session Management" select "Persist Session"
        - Enter the name of the ZAP session file created after choosing to persist the session upon launching ZAP (petclinicSession)
    - Under "Session Properties" enter:
        - "myContext" in the "Context Name" field
        - "http://10.1.1.7:8080/petclinic/*" in the "Include in Context" field
    - Under "Attack Mode" enter "http://10.1.1.7:8080/petclinic/" in the "Starting Point" field
        - click the "Spider Scan" and "Recurse" checkboxes
    - Under "Finalize Run" click the "Generate Reports", "Clean Workdpsave Reports", and "Generate Report" radio butotns
        - Enter JENKINS_ZAP_VULNERABILITY_REPORT in the "Filename" field
        - Select "html" under the "Format" field
    - Click "Add post-built action" and select "Publish HTML reports"
    - Under "Publish HTML reports" enter:
        - "/var/lib/jenkins/workspace/petclinic/" in the "HTML directory to archive" field
        - "JENKINS_ZAP_VULNERABILITY_REPORT.html" in the "Index page[s]" field
        - "Last ZAP Vulnerability Report" in the "Report title" field
    - Click Apply and then click Save

## Workflow

1. Develop!
2. Build and Deploy!
	- In the Jenkins UI project view, click "Build Now" on left hand side of screen, or on the main dashboard click the icon to schedule a build
3. To view the most recent ZAP Vulnerability Report, click "Last ZAP Vulnerability report" 	
4. Visit http://localhost:8087/petclinic/

## Document/Test Configuration

### on 'mediaWiki' VM: http://localhost:8086

#### Wiki (Mediawiki), Issue Tracker (Bugzilla), Chat Bot (Hubot)

##### - Documentation for MediaWiki

1. Browse to "http://localhost:8086/wiki" to access the MediaWiki web interface.

2. Login with the administrator credentials specified in the MediaWiki cookbook to begin customization.

##### - Documentation for Bugzilla

1. Type "http://localhost:8086/bugzilla-5.0.3/" in your browser to access the Bugzilla web interface.

2. Login to the administrator account with the credentials used in the "checksetup_config.erb" recipe template to configure your issue tracking service.

##### -  Manual configuration steps for Hubot bot creation and to Integrate Hubot with Jenkins via Slack

1. Upon a successful "vagrant up", ssh into the VM using "vagrant ssh mediaWiki".

2. Navigate to "/home/vagrant/myhubot" as the vagrant user.

3. Type "yo hubot --adapter slack" to create a Hubot bot that can integrate with your Slack workspace

4. While in the "/home/vagrant/myhubot" directory, execute the "npm_packages_install.sh" script to install the necessary npm packages to allow your
 hubot to integrate with Jenkins and Slack
    - This must be done BEFORE launching the Hubot bot
 
5. Export HUBOT_JENKINS_AUTH, HUBOT_JENKINS_URL, and HUBOT_SLACK_TOKEN variables
    - HUBOT_JENKINS_AUTH should be in "username:password" format (use jenkins account credentials)
6. Launch the previously created Hubot by passing all of the appropriate command line flags
    - ex: HUBOT_SLACK_TOKEN=$HUBOT_SLACK_TOKEN HUBOT_JENKINS_URL=$HUBOT_JENKINS_URL 
    HUBOT_JENKINS_AUTH=$HUBOT_JENKINS_AUTH ./bin/hubot --adapter slack
7. You will now be able to chat with your Hubot via your Slack workspace, as well as kick off Jenkins builds of the petclinic application

## Environment Creation via IaC Using Docker-Compose

To get started, bring up the "docker-compose" VM. Upon the creation of the VM through Vagrant, Docker and Docker-Compose will automatically be installed 
through the Docker-Compose Vagrant Provisioner (vagrant-docker-compose vagrant plugin). 

Through the Docker-Compose Vagrant Provisioner a "docker-compose.yml" file, 
which contains the configuration specifications for each service/container in the Microcosm pipeline, is specified.
 

        vagrant plugin install vagrant-docker-compose
        vagrant up docker-compose

### Port Forwarding Explanation

It is important to understand the port forwarding that is going on behind the scenes with the Dockerized version of Microcosm. As opposed to the "strictly VM" version of Microcosm,
there are two levels of port forwarding that occur.

At the service level, the initial layer of port forwarding occurs between each container and the Centos 7 VM that is running Docker-Compose. This can be seen for each container definition 
in the "docker-compose.yml" file, as shown below for the Jenkins container:

        jenkins:
            image: h1kkan/jenkins-docker:lts
            container_name: jenkins
            ports:
              - "8080:8080"
            volumes:
              - jenkins_home:/var/jenkins_home
            extra_hosts:
             - "staging:10.1.1.7"
             
Note the values assigned to the "ports" argument: 8080:8080. The port to the right of the colon specifies the port in which the service is listening on within the container. 
The port to the left of the colon specifies forwarded port in which the Centos 7 VM is listening on.

The second layer of port forwarding now occurs between the Centos 7 VM and the host machine that is running Vagrant. This takes place in the VM definition within the Vagrantfile:

        docker.vm.network :forwarded_port, guest:8080, host:8088
        
The Centos 7 VM re-forwards its forwarded port to the specified port on the host machine. Jenkins is therefore available at "localhost:8088" via a browser on the host machine.

### Additional Instructions for Jenkins Container (providing a future workaround to avoid manual steps)

The Jenkins Docker imaged used is fortunately packaged with Ansible pre-installed, but a few steps must be taken to create the "/etc/ansible/hosts" file for remote deployment, as well
as the /etc/ansible/vagrant_id_rsa" key to allow jenkins to ssh into the Staging server during the execution of the Ansible playbook.

1. SSH into the VM using "vagrant ssh docker-compose"
2. Enter the Jenkins container as root using a bash shell:
        
        docker exec -it --user root jenkins bash
        
3. Update apt-get with:

        apt-get update
        
4. Install VIM to author the "/etc/ansible/hosts" file:

        apt-get install vim
        
5. Create the "/etc/ansible" directory:

        mkdir /etc/ansible
        
6. Author the "/etc/ansible/hosts" file

        vi /etc/ansible/hosts
        
        Inside the file:
        
       [DevOps]
       10.1.1.7
       
7. While in the "/etc/ansible/" directory, download the Vagrant RSA key needed for deployment:

        curl -o vagrant_id_rsa https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant

        
### Hubot Container Notes

The environment arguments for the Hubot container defined in "docker-compose.yml" will change.

- HUBOT_JENKINS_URL=http://IP_ADDRESS_OF_JENKINS_CONTAINER:8080
    - Print IP address of container while in "docker-compose" VM with:
            
            docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' NAME_OF_CONTAINER

- HUBOT_JENKINS_AUTH=JENKINS_USERNAME:PASSWORD

       

             
