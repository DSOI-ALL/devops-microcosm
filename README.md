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
		- owasp (DEV BOX?)
		- mediawiki (+ bugzilla + hubot)
		- UNCOMMENT STAGING VM -> fix IP, forwarded ports, etc for Tomcat

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
				- if in VM, then CHANGE 'localhost' to '10.1.1.3' (:80)
				- NEED TO DECIDE one or the other - whichever is done, pull/push from that point forward need to be in the same environment

	JENKINS : http://localhost:8080

		pull Jenkins administrator password from log (/var/log/jenkins) and click through configuration
		manage jenkins -> manage plugins
			- search: owasp
			- select: Official OWASP ZAP Jenkins Plugin
		create new project -> spring-petclinic
			Add Jenkins credentials -> root:1amd3v0p5
			Repository URL: http://10.1.1.3/root/spring-petclinic.git
			Select 'root' credentials
			Build: Execute shell
				PUT CORRECT COMMAND HERE TO BUILD WAR
				DEPLOY TO STAGING SERVER
					- provisioning - Java / Tomcat

	MEDIAWIKI

		HUBOT FAILING
		APACHE ALIAS CONFIG FOR BUGZILLA/MEDIAWIKI

	OWASP 

		CONFIGURE FOR STAGING FRONT END
		FIGURE OUT HOW TO GET RESULTS IN A NICE WAY

	SELENIUM



