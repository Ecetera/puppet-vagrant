# -*- mode: ruby -*-
# vi: set ft=ruby :

# Requires following plugins:
#   vagrant plugin install vagrant-hosts

require 'vagrant-hosts'

Vagrant.configure('2') do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "https://github.com/2creatives/vagrant-centos/releases/download/v6.5.3/centos65-x86_64-20140116.box"

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "centos65"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
   config.vm.provider :virtualbox do |vb|
     # Don't boot with headless mode
     #vb.gui = true
     # Use VBoxManage to customize the VM. For example to change memory:
     vb.customize ["modifyvm", :id, "--memory", "1024"]
     # Console for debugging if needed
     #vb.gui = true
     vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
     vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
   end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  config.vm.define "puppet" do |node|
    node.vm.host_name = "puppet.boxnet"
    node.vm.network :private_network, ip: "10.1.1.10"
    node.vm.network :forwarded_port, guest: 5000, host: 5000 #Puppetboard
    node.vm.network :forwarded_port, guest: 9090, host: 9090 #Jenkins
    # The provisioners below will run in order
    # Install Puppet Master if it's not already installed
    node.vm.provision "shell", path: "bootstrap/centos-puppetmaster.sh"
    # Populate /etc/hosts with each VM in this file
    node.vm.provision :hosts
    # Puppet Apply Provisioner
    node.vm.provision "puppet" do |puppet|
      puppet.module_path = "puppet/modules"
      puppet.manifests_path = "puppet"
      puppet.manifest_file = "vagrant.pp"
      #puppet.facter = { "vagrant" => "1" }
    end
    node.vm.provision "shell", inline: "r10k deploy environment -vp"
  end
  config.vm.define "elk" do |node|
    node.vm.host_name = "elk.boxnet"
    node.vm.network :private_network, ip: "10.1.1.11"
    node.vm.network :forwarded_port, guest: 80, host: 8080 #Kibana
    node.vm.network :forwarded_port, guest: 9200, host: 9200 #Elasticsearch
    node.vm.provision :hosts
    node.vm.provision "shell", path: "bootstrap/centos-puppet.sh"
  end
  config.vm.define "mon" do |node|
    node.vm.host_name = "mon.boxnet"
    node.vm.network :private_network, ip: "10.1.1.12"
    node.vm.provision :hosts
    node.vm.network :forwarded_port, guest: 15672, host: 15672 #RabbitMQ
    node.vm.network :forwarded_port, guest: 3000, host: 3000 #Uchiwa
    node.vm.provision "shell", path: "bootstrap/centos-puppet.sh"
  end
end
