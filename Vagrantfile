# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'vagrant-hosts'

Vagrant.configure('2') do |config|

  #config.vm.box = "ubuntu64"
  #config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
  config.vm.box_url = "https://github.com/2creatives/vagrant-centos/releases/download/v6.5.3/centos65-x86_64-20140116.box"
  config.vm.box = "centos65"

  config.vm.provider :virtualbox do |vb|
    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "512"]
    # Console for debugging if needed
    #vb.gui = true
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  config.vm.define "puppet" do |node|
    node.vm.host_name = "puppet.boxnet"
    node.vm.network :private_network, ip: "10.1.1.10"
    node.vm.network :forwarded_port, guest: 5000, host: 5000 #Puppetboard
    node.vm.provision "shell", path: "bootstrap/centos-puppetmaster.sh"
    # Populate /etc/hosts with each VM in this file
    node.vm.provision :hosts
    node.vm.provision "puppet" do |puppet|
      puppet.module_path = "puppet/modules"
      puppet.manifests_path = "puppet"
      puppet.manifest_file = "vagrant.pp"
      puppet.hiera_config_path = "puppet/hiera.yaml"
      #puppet.facter = { "vagrant" => "1" }
    end
    node.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024"]
    end
    node.vm.provision "shell", inline: "r10k deploy environment -vp"
    # Run Puppet and force exit code to 0 so Vagrant doesn't exit
    node.vm.provision "shell", inline: "puppet agent -t;true"
   end
  config.vm.define "elk" do |node|
    node.vm.host_name = "elk.boxnet"
    node.vm.network :private_network, ip: "10.1.1.11"
    node.vm.network :forwarded_port, guest: 80, host: 8080 #Kibana
    node.vm.network :forwarded_port, guest: 9200, host: 9200 #Elasticsearch
    node.vm.provision :hosts
    node.vm.provision "shell", path: "bootstrap/centos-puppet.sh"
    # Run Puppet and force exit code to 0 so Vagrant doesn't exit
    node.vm.provision "shell", inline: "puppet agent -t;true"
  end
  config.vm.define "mon" do |node|
    node.vm.host_name = "mon.boxnet"
    node.vm.network :private_network, ip: "10.1.1.12"
    node.vm.provision :hosts
    node.vm.network :forwarded_port, guest: 15672, host: 15672 #RabbitMQ
    node.vm.network :forwarded_port, guest: 3000, host: 3000 #Uchiwa
    node.vm.provision "shell", path: "bootstrap/centos-puppet.sh"
    # Run Puppet and force exit code to 0 so Vagrant doesn't exit
    node.vm.provision "shell", inline: "puppet agent -t;true"
  end
  config.vm.define "git" do |node|
    node.vm.host_name = "git.boxnet"
    node.vm.network :private_network, ip: "10.1.1.13"
    node.vm.provision :hosts
    node.vm.network :forwarded_port, guest: 9090, host: 9090 #Jenkins
    node.vm.network :forwarded_port, guest: 80, host: 9595 #Gitlab
    node.vm.provision "shell", path: "bootstrap/centos-puppet.sh"
    # Run Puppet and force exit code to 0 so Vagrant doesn't exit
    node.vm.provision "shell", inline: "puppet agent -t;true"
  end
end
