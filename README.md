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

## Environment Creation via IaC Using Separate VMs

	git clone https://github.com/SLS-ALL/devops-microcosm.git
	cd devops-microcosm
	vagrant box add metadata.json

- jenkins (+ owaspZAP + selenium)
- gitlab
- mediawiki (+ bugzilla + hubot)
- staging

## Dev/Build/Deploy Configuration

To get started, first bring up all  VMs (i.e. 'newJenkins', 'gitlab', 'staging', 'mediaWiki' )

	vagrant up newJenkins gitlab mediaWiki staging

When each VM is ready, proceed with the configuration steps below for each.

Note: You can also create each VM , one at a time by running  'vagrant up <VMName>' like

      vagrant up gitlab

Note: If you wish to use the Microservice (Docker-Compose) version of Microcosm, See the instructions under "Environment Creation via IaC Using Docker-Compose", below.

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

			vagrant ssh newJenkins
			sudo tail -n 30 /var/lib/jenkins/secrets/initialAdminPassword

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
	- click "Manage Plugins"
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

9. Add SonarQube Scanner build step
    - Complete the "SonarQube Integration with Jenkins Instructions" steps founds at the end of the README.md
    - Click "Add build step" and select "Execute SonarQube Scanner"
    - Under "Analysis properties" enter:

            sonar.projectKey=petclinic
            sonar.projectName=petclinic
            sonar.sources=/var/jenkins_home/workspace/petclinic/src/
            sonar.java.binaries=/var/jenkins_home/workspace/petclinic/src/

    - Click Apply and Save
    - After a successful build, the static code analysis will be available at "http://localhost:9000/dashboard/index/petclinic"


10. Add OwaspZap build step
    - Navigate to the desktop instance of the "Jenkins" VM which contains owaspZap and launch a terminal
    - Type "sudo /opt/zapproxy/ZAP_2.6.0/./zap.sh" to launch the owasZap GUI as root
    - The user will be promtped to persist the current session of ZAP
        - Click "Yes" to persist the session and specify the Jenkins workspace that was created upon the initial successful build of petclinic as the place to save the ZAP session files
        - ex: petclinicSession.session
    - Open a new terminal tab (necessary for ZAP HTML Reports)
        - Create “/var/lib/jenkins/jobs/htmlreports” directory and change ownership to jenkins user-> chown jenkins:jenkins htmlreports
        - Create “/var/lib/jenkins/workspace/petclinic/reports/html” directory and change ownership to jenkins user -> chown jenkins:jenkins html
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

Provided in this repository is one simple one-stop script to setup MediaWiki, `IaC-setup-script.sh`.  It singlehandedly automates the IaC pipeline to start up a development project, which is the MediaWiki application in this case.

The setup script operates in two layers.  Above, we used Vagrant to generate four VMs for our environment (i.e. newJenkins, gitlab, mediaWiki, and staging).  Instead, in our first layer of abstraction, we spin up two VMs, staging and docker-compose, the latter of which automatically contains six containers (e.g. mediaWiki, jenkins, gitlab, ...).  The second stage then installs MediaWiki with pre-determined settings on the mediaWiki container.

As such, the `IaC-setup-script.sh` copies `copy-to-mediawiki.sh` and `mediawiki-setup.sh` to the docker-compose VM.  Then, `copy-to-mediawiki.sh` is executed remotely, which copies `mediawiki-setup.sh` from the _docker-compose_ VM to the _somewiki_ container (with the mediaWiki image) and executes the script, installing MediaWiki.  Once MediaWiki is installed on the _somewiki_ container, users may access the application via http://localhost:8096/index.php/Main_Page .

Although this script handles all grunt work effortlessly, understanding the underlying levels of abstraction and details of the scripts is imperative.  It is also important to note IaC-setup-script.sh automatically installs the vagrant-docker-compose vagrant plugin via the command:

        vagrant plugin install vagrant-docker-compose

If necessary, one may destroy any vagrant VMs and start from scratch via the command:

        vagrant destroy -f

Finally, the "docker-compose.yml" file contains configuration specifications for each service/container in the Microcosm pipline.  Most noticeably, the _somewiki_ container lies within the specifications, utilizing the mediaWiki image.

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

        docker.vm.network :forwarded_port, guest:8080, host:8098

The Centos 7 VM re-forwards its forwarded port to the specified port on the host machine. Jenkins is therefore available at "localhost:8098" via a browser on the host machine.

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

### SonarQube Jenkins Integration Instructions

1. Install the SonarQube Scanner for Jenkins via the Jenkins Plugin Manager

2. Go to Manage Jenkins -> Configure System
    - Enter "SonarQube" in the "Name" field
    - ssh into the docker-compose VM and use the "docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' NAME_OF_CONTAINER" command to find the
      IP address of the SonarQube container. Enter the returned IP address under the "Server URL" field.

            ex: http://SonarQube_Container_IP_Address:9000
3. Select "5.3 or higher" for the "Server version" field
4. Enter the authentication token that was generated upon logging into the SonarQube web interface in the "Server authentication token" field
5. Click Apply and Save
6. Go to Manage Jenkins -> Global Tool Configuration
7. Enter "SonarQube" in the "Name" field
8. Check "Install automatically"
    - Choose the most recent version of SonarQube Scanner
9. Click Apply and Save

### SonaType Nexus Jenkins Integration Instructions

1. Install the Nexus Platform plugin via the Jenkins Plugin Manager
    - Select Manage Jenkins from the left-navigation menu
    - Select Manage Plugins from the list of configuration options
    - In the Plugin Manager window, select the Available tab and enter "nexus platform plugin" in the Filter: search box
    - Select the Install checkbox next to Nexus Platform Plugin and then click either the Install without restart or Download now and install after restart button
    
2. Modify the "settings.xml" file on the Jenkins container
    - Enter the Jenkins container as root using a bash shell:
      
              docker exec -it --user root jenkins bash 
              
    - Open the Maven "settings.xml" file located at "/var/jenkins_home/tools/hudson.tasks.Maven_MavenInstallation/petclinic/conf/settings.xml" 
        - Note: A generic successful build of 
          petclinic with Maven must be completed for the "settings.xml" file to be generated
    - Under the <servers> section, locate the following <server> xml tag definition and change the value of <username> to "admin" and <password> to "admin123":
      
           <server>
             <id>deploymentRepo</id>
             <username>admin</username>
             <password>admin123</password>
            </server> 
    
    - Write/quit "settings.xml" and exit the Jenkins container

2. Use the following instructions to configure Jenkins to connect to Nexus Repository Manager:
    1. Select Manage Jenkins from the Dashboard’s left-navigation menu
    2. Select Configure System from the list of configuration options
    3. In the Sonatype Nexus section, click the Add Nexus Repository Manager Server dropdown menu and then select Nexus Repository Manager 2.x Server. Enter the following:
        - Display Name: Name of the server you want shown when selecting Nexus Repository Manager instances for build jobs
        - Server ID: A unique ID used to reference Nexus Repository Manager in Build Pipeline scripts. It should be alphanumeric without spaces
        - Server URL: Location of your Nexus Repository Manager server (ex: http://NEXUS_IP_ADDRESS:8081/nexus)
        - Credentials: Select the Add button to enter your Nexus Repository Manager username and password (defaults = admin/admin123) using the Jenkins Provider Credentials: Jenkins modal window. 
          Once added, select your Nexus Repository Manager username and password from the Credentials dropdown list
    4. Click the Test Connection button
    5. After a successful connection to Nexus Repository Manager, click the Save button
    
3.  Add Nexus Repository Manager Publisher as a build step in the freestyle project Jenkins job
    1. In the Build section of the configuration screen, click the Add Build Step dropdown button and then select Nexus Repository Manager Publisher, after you have added the "Invoke
       lop-level Maven Targets step. Enter the following parameters:
       - Nexus Instance: Enter "Nexus"
       - Nexus Repository: Select the "Releases" repository
       - Packages: Select packages to publish to Nexus Repository Manager during your freestyle build. For this example, use the Add Package dropdown to select a Maven Package
            - For Group enter: "petclinic-main"
            - For Artifact enter: "petclinic.war"
            - For Version enter: 2.3
            - For Packaging enter: "war"
            - Click "Add Artifact Path" and choose "Maven Artifact"
            - For Filepath enter: "/var/jenkins_home/workspace/petclinic/target/petclinic.war"
       - Complete your freestyle build as desired and click Save
       
4. After a successful Jenkins build, view your selected packages in the Nexus Repository manager web UI under the "Releases" repository
   
### Hubot Container Notes

The environment arguments for the Hubot container defined in "docker-compose.yml" will change.

- HUBOT_JENKINS_URL=http://IP_ADDRESS_OF_JENKINS_CONTAINER:8080
    - Print IP address of container while in "docker-compose" VM with:

            docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' NAME_OF_CONTAINER

- HUBOT_JENKINS_AUTH=JENKINS_USERNAME:PASSWORD

### OwaspZap Container Notes

- The ZAP web interface is available at: http://localhost:8081/?anonym=true&app=ZAP
- In order to integrate with jenkins, a ZAP session must be created in the same manner described above in the "Add OwasZap build step" section.
- Once a Zap session is created, the "petclinic.Session" file must be secure copied from the ZAP container to the Jenkins container, in the petclinic workspace

## Environment Creation Using Kubernetes with Minikube

### Prerequisites

- Download and install kubectl for your appropriate operating system: https://kubernetes.io/docs/tasks/tools/install-kubectl/
    - Verify install with: 

                kubectl version 

- Download and install Minikube for your appropriate OS: https://github.com/kubernetes/minikube/releases
    - Verify install with: 
    
                minikube version
    
### Creation of Minikube VM to Host Local Kubernestes Cluster

1. Create the Minikube VM using:
        
        minikube start --memory 6144
        
    The minikube start command creates a “kubectl context” called “minikube”. This context contains the configuration to communicate with your minikube cluster.
        
2. Upon successful creeation of the minikube VM and local Kubernetes cluster, type:
     
       kubectl cluster-info
       
   This will displayer the URL's and IP addresses/ports that the Kubernetes master and KubeDNS services are listening on.
   
3. All of the definitions for each service in the Microcosm pipeline are defined in the "deployment.yml" file. 
 Each service has a corresponding "deployment" and "service" definition that are required by Kubernetes. Below is
 an example of the deployment and service definitions for Jenkins in the "deployment.yml" file:
 
        apiVersion: extensions/v1beta1
        kind: Deployment
        metadata:
          name: jenkins
        spec:
          replicas: 1
          template:
            metadata:
              labels:
                app: jenkins
            spec:
              containers:
              - name: jenkins
                image: jenkins:2.60.3
                ports:
                - containerPort: 8080
        ---
        apiVersion: v1
        kind: Service
        metadata:
          name: jenkins
        spec:
          type: NodePort
          ports:
            - port: 8080
              targetPort: 8080
          selector:
            app: jenkins
 
    The explanations of how deployments and services work within Kubernetes can be found here: 
    - https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
    - https://kubernetes.io/docs/concepts/services-networking/service/
    
4. To create a node with separate pods for each service in the Microcosm pipeline, type:
    
        kubectl create -f deployment.yml
        
    The following output should be displayed to verify each deployment and service was successfully created:
    
        deployment.extensions "jenkins" created
        service "jenkins" created
        deployment.extensions "gitlab" created
        service "gitlab" created
        deployment.extensions "sonarqube" created
        service "sonarqube" created
        deployment.extensions "bugzilla" created
        service "bugzilla" created
        deployment.extensions "mediawiki" created
        service "mediawiki" created
        deployment.extensions "nexus" created
        service "nexus" created
        deployment.extensions "owaspzap" created
        service "owaspzap" created
        
5. The command "kubectl get" allows for easy, readable configuration information about your Kubernetes cluster.
For example, see the following output below for displayed information about the cluster's nodes, pods, deployments,
and services:

    - kubectl get nodes
    
          NAME       STATUS    ROLES     AGE       VERSION
          minikube   Ready     master    1h        v1.10.0  
          
    - kubectl get pods 
    
           bugzilla-79dc49848d-l7757    1/1       Running   0          10m
           gitlab-77cbfb478d-w7lhv      1/1       Running   0          10m
           jenkins-85c7b4dd5-nt6q8      1/1       Running   0          10m
           mediawiki-7cd77758c6-c7qbs   1/1       Running   0          10m
           nexus-7fbc798674-fl7nt       1/1       Running   0          10m
           owaspzap-95964c559-ncqr2     1/1       Running   0          10m
           sonarqube-5fb87cb946-xv2gt   1/1       Running   0          10m 
           
    - kubectl get deployments
    
            NAME        DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
            bugzilla    1         1         1            1           10m
            gitlab      1         1         1            1           10m
            jenkins     1         1         1            1           10m
            mediawiki   1         1         1            1           10m
            nexus       1         1         1            1           10m
            owaspzap    1         1         1            1           10m
            sonarqube   1         1         1            1           10m
            
    - kubectl get services
    
            NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
            bugzilla     NodePort    10.101.28.145   <none>        80:30482/TCP     10m
            gitlab       NodePort    10.105.19.60    <none>        80:30616/TCP     10m
            jenkins      NodePort    10.108.138.95   <none>        8080:32608/TCP   10m
            kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP          50m
            mediawiki    NodePort    10.102.13.181   <none>        80:32168/TCP     10m
            nexus        NodePort    10.111.48.107   <none>        8081:32540/TCP   10m
            owaspzap     NodePort    10.108.136.62   <none>        8090:31022/TCP   10m
            sonarqube    NodePort    10.110.146.33   <none>        9000:30611/TCP   10m
            
6. To acess these services via a web browser on the host machine, the IP address of the minikube VM must be used.
The "CLUSTER IP" of each service shown in the results of "kubectl get services" is the corresponding IP address of
each pod within the Kubernetes node (the minikube VM). The appropriate service definition exposes the port that 
the container is listening on inside of the pod (8080 for Jenkins), and allows it to be accessible from an 
external source outside of the node.

    - For example, use:
    
            minikube ip
            
        to display the IP address of the minikube VM. This displays "192.168.99.100", so therefore the Jenkins
        service is available in a browser at http://192.168.99.100:32608.
        
        

       

         