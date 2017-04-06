Vagrant.configure("2") do |config|

  # Use SEI proxy if necessary
  if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.http     = "http://proxy.sei.cmu.edu:8080"
    config.proxy.https    = "http://proxy.sei.cmu.edu:8080"
    config.proxy.no_proxy = "localhost,127.0.0.1,localaddress,.diid.local,.cs2.local,.cert.org,.sei.cmu.edu,.perclab.local"
  end

  config.vbguest.auto_update = true
  # config.vbguest.no_remote = true

  config.vm.box = "cert/centos7_x86_64"
  config.vm.box_version = "0.4.0"

  config.ssh.pty = true
  config.ssh.insert_key = false

  config.vm.provision "shell", inline: <<-SHELL
    sudo yum install net-tools -y
  SHELL

  config.vm.define "jenkins" do |jenkins|
    jenkins.vm.network "private_network", ip: "10.1.1.2"

    jenkins.vm.provider "virtualbox" do |v|
      v.name = "voltron-jenkins"
      v.customize ["modifyvm", :id, "--memory", 1024]
      v.customize ["modifyvm", :id, "--cpus", 1]
      v.customize ["modifyvm", :id, "--groups", "/CERT"]
    end
  end

  config.vm.define "gitLab" do |gitLab|
    gitLab.vm.network "private_network", ip: "10.1.1.3"

    gitLab.vm.provider "virtualbox" do |v|
      v.name = "voltron-gitLab"
      v.customize ["modifyvm", :id, "--memory", 1024]
      v.customize ["modifyvm", :id, "--cpus", 1]
      v.customize ["modifyvm", :id, "--groups", "/CERT"]
    end
  end


  #config.vm.define "selenium" do |selenium|
  #  selenium.vm.network "private_network", ip: "10.10.0.4", auto_config: false

  #  selenium.vm.provider "virtualbox" do |v|
  #    v.name = "voltron-selenium"
  #    v.customize ["modifyvm", :id, "--memory", 1024]
  #    v.customize ["modifyvm", :id, "--cpus", 1]
  #    v.customize ["modifyvm", :id, "--groups", "/CERT"]
  #  end
  #end

  #config.vm.define "owaspZap" do |owaspZap|
  #  owaspZap.vm.network "private_network", ip: "10.10.0.5", auto_config: false

  #  owaspZap.vm.provider "virtualbox" do |v|
  #    v.name = "voltron-owaspZap"
  #    v.customize ["modifyvm", :id, "--memory", 1024]
  #    v.customize ["modifyvm", :id, "--cpus", 1]
  #    v.customize ["modifyvm", :id, "--groups", "/CERT"]
  #  end
  #end

  # mediaWiki VM also has Issue Tracking and Hubot
  #config.vm.define "mediaWiki" do |mediaWiki|
  #  mediaWiki.vm.network "private_network", ip: "10.10.0.6", auto_config: false

  #  mediaWiki.vm.provider "virtualbox" do |v|
  #    v.name = "voltron-jenkins"
  #    v.customize ["modifyvm", :id, "--memory", 1024]
  #    v.customize ["modifyvm", :id, "--cpus", 1]
  #    v.customize ["modifyvm", :id, "--groups", "/CERT"]
  #  end
  #end

  #config.vm.define "staging" do |staging|
  #  staging.vm.network "private_network", ip: "10.10.0.7", auto_config: false

  #  staging.vm.provider "virtualbox" do |v|
  #    v.name = "voltron-staging"
  #    v.customize ["modifyvm", :id, "--memory", 1024]
  #    v.customize ["modifyvm", :id, "--cpus", 1]
  #    v.customize ["modifyvm", :id, "--groups", "/CERT"]
  #  end
  #end

end
