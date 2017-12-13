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

  config.vm.define "docker-compose" do |docker|

    docker.vm.network "private_network", ip: "10.1.1.10"

    # Two levels of port forwarding occur. The inital port forward from the docker container to the host Centos 7 VM,
    # then the port forward from the Centos 7 VM to the user's host machine
    # Port forward for jenkins service
    docker.vm.network :forwarded_port, guest:8080, host:8088
    # Port forward for GitLab service
    docker.vm.network :forwarded_port, guest:80, host:8083
    # Port forward for OwaspZAP service
    docker.vm.network :forwarded_port, guest:8081, host:8081
    # Port forward for Bugzilla service
    docker.vm.network :forwarded_port, guest:82, host:8082
    # Port forward for MediaWiki service
    docker.vm.network :forwarded_port, guest:8084, host:8084
    # Port forward for Selenium Grid Hub service
    docker.vm.network :forwarded_port, guest:4444, host:4444

    docker.vm.provider "virtualbox" do |v|
      v.name = "microcosm-docker-compose"
      v.customize ["modifyvm", :id, "--memory", 4096]
      v.customize ["modifyvm", :id, "--cpus", 1]
      v.customize ["modifyvm", :id, "--groups", "/CERT"]
    end

    docker.vm.provision :docker
    docker.vm.provision :docker_compose, yml: "/vagrant/docker-compose.yml", command_options: {up: "-d"}, run: "always"
  end
end