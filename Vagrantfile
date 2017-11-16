Vagrant.configure("2") do |config|

  # config.vbguest.auto_update = true
  # config.vbguest.no_remote = true

  config.vm.box = "cmu/centos72_x86_64"
  config.vm.box_version = "0.1.0"

  config.ssh.pty = true
  config.ssh.insert_key = false

  config.vm.define "newJenkins" do |jenkins|
    jenkins.vm.network "private_network", ip: "10.1.1.8"
    jenkins.vm.network :forwarded_port, guest:8080, host:8088

    jenkins.vm.provider "virtualbox" do |v|
      v.name = "microcosm-newJenkins"
      v.gui = true
      v.customize ["modifyvm", :id, "--memory", 2048]
      v.customize ["modifyvm", :id, "--cpus", 1]
      v.customize ["modifyvm", :id, "--groups", "/CERT"]
    end

    jenkins.vm.provision :chef_zero do |chef|

      chef.cookbooks_path = "cookbooks"
      chef.nodes_path = "./nodes"
      chef.roles_path = "./roles"

      chef.add_role "jenkins"
      chef.add_role "owaspZap"
      chef.add_role "selenium"
    end
  end

  config.vm.define "gitlab" do |gitlab|
    gitlab.vm.network "private_network", ip: "10.1.1.3"
    gitlab.vm.network :forwarded_port, guest:80, host:8083

    gitlab.vm.provider "virtualbox" do |v|
      v.name = "microcosm-gitlab"
      v.customize ["modifyvm", :id, "--memory", 1024]
      v.customize ["modifyvm", :id, "--cpus", 1]
      v.customize ["modifyvm", :id, "--groups", "/CERT"]
    end

    gitlab.vm.provision :chef_zero do |chef|

      chef.cookbooks_path = "cookbooks"
      chef.nodes_path = "./nodes"
      chef.roles_path = "./roles"
      #chef.environments_path = "./environments"

      chef.add_role "gitlab"
    end
  end

   #mediaWiki VM also has Issue Tracking and Hubots
  config.vm.define "mediaWiki" do |mediaWiki|
    mediaWiki.vm.network "private_network", ip: "10.1.1.6"
    mediaWiki.vm.network :forwarded_port, guest:80, host:8086

    mediaWiki.vm.provider "virtualbox" do |v|
      v.name = "microcosm-mediaWiki"
      v.customize ["modifyvm", :id, "--memory", 1024]
      v.customize ["modifyvm", :id, "--cpus", 1]
      v.customize ["modifyvm", :id, "--groups", "/CERT"]
    end

    mediaWiki.vm.provision :chef_zero do |chef|

      chef.cookbooks_path = "cookbooks"
      chef.nodes_path = "./nodes"
      chef.roles_path = "./roles"
      #chef.environments_path = "./environments"

      chef.add_role "mediaWiki"
      chef.add_role "bugzilla"
      chef.add_role "hubot"

    end
  end

  config.vm.define "staging" do |staging|
  
    staging.vm.network "private_network", ip: "10.1.1.7"
    staging.vm.network :forwarded_port, guest:8080, host:8087

    staging.vm.provider "virtualbox" do |v|
      v.name = "microcosm-staging"
      v.customize ["modifyvm", :id, "--memory", 1024]
      v.customize ["modifyvm", :id, "--cpus", 1]
      v.customize ["modifyvm", :id, "--groups", "/CERT"]
    end
  end

  config.vm.define "docker" do |docker|

    docker.vm.network "private_network", ip: "10.1.1.9"
    docker.vm.network :forwarded_port, guest:8080, host:8088
    docker.vm.network :forwarded_port, guest:80, host:8083
    docker.vm.network :forwarded_port, guest:8081, host:8081
    docker.vm.network :forwarded_port, guest:82, host:8082
    docker.vm.network :forwarded_port, guest:8084, host:8084

    docker.vm.provider "virtualbox" do |v|
      v.name = "microcosm-docker"
      v.customize ["modifyvm", :id, "--memory", 2048]
      v.customize ["modifyvm", :id, "--cpus", 1]
      v.customize ["modifyvm", :id, "--groups", "/CERT"]
    end

    docker.vm.provision "docker" do |d|
      d.run "jenkins/jenkins",
          args: "-p 8080:8080 -v jenkins_home:/var/jenkins_home"
      d.run "gitlab/gitlab-ce",
          args: " --detach \
                  --hostname gitlab.example.com \
                  --publish 443:443 --publish 80:80 \
                  --name gitlab \
                  --restart always \
                  --volume /srv/gitlab/config:/etc/gitlab \
                  --volume /srv/gitlab/logs:/var/log/gitlab \
                  --volume /srv/gitlab/data:/var/opt/gitlab \
                "
      d.run "owasp/zap2docker-stable",
          args: "-u zap -p 8081:8080 -p 8090:8090 -i owasp/zap2docker-stable zap-webswing.sh"
      d.run "bugzilla/bugzilla-dev",
          args: " -d \ -p 82:80 -p 5900:5900 --name bugzilla \
                "
      d.run "mediawiki",
          args: "--detach \
                 --name somewiki \
                 -p 8084:80 \
                "
      # d.run "mysql",
      #     args: " --name some-mysql -e MYSQL_ROOT_PASSWORD=tartans --restart always -d mysql:8.0.3"
    end
  end
end