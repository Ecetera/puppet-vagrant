# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'vagrant-hosts'
require 'vagrant-aws'

Vagrant.configure('2') do |config|

  config.vm.box = "ubuntu64"
  config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
  #config.vm.box_url = "https://github.com/2creatives/vagrant-centos/releases/download/v6.5.3/centos65-x86_64-20140116.box"
  #config.vm.box = "centos65"

  config.vm.provider :virtualbox do |vb|
    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "1024"]
    # Console for debugging if needed
    #vb.gui = true
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end
  config.vm.provider :digital_ocean do |provider, override|
    override.ssh.private_key_path = ENV['DO_KEYPATH']
    override.vm.box = 'digital_ocean'
    override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"
    provider.token = ENV['DO_TOKEN']
    provider.image = 'ubuntu-14-04-x64'
    provider.region = 'sgp1'
    provider.size = '1gb'
  end
  config.vm.provider :aws do |aws, override|
    aws.access_key_id = ENV['AWS_KEY']
    aws.secret_access_key = ENV['AWS_SECRET']
    aws.keypair_name = ENV['AWS_KEYNAME']
    override.ssh.private_key_path = ENV['AWS_KEYPATH']
    override.ssh.username = "ubuntu"
    #override.ssh.username = "ec2-user"
    aws.ami = "ami-abeb9e91" #Ubuntu 14.04 LTS HVM
    #aws.ami = "ami-eb2a47d1" #RHEL 6.5 PV
    #aws.ami = "ami-83e08db9" #RHEL 6.5 HVM
    aws.region = "ap-southeast-2"
    #aws.instance_type = "t1.micro"
    aws.instance_type = "t2.small"
    #aws.security_groups = ["open"]
    aws.security_groups = ["sg-a001a8c5"]
    aws.subnet_id = "subnet-12052d66"
    aws.associate_public_ip = true
    #aws.tags = { 'Name' => box[:name] }
    override.vm.box = "dummy"
    override.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
    override.ssh.pty = true
  end
  config.vm.define "puppet" do |node|
    node.vm.hostname = "puppet.eskp.net"
    node.vm.network :private_network, ip: "10.1.1.10"
    node.vm.network :forwarded_port, guest: 5000, host: 5000 #Puppetboard
    node.vm.provision "shell", path: "bootstrap/ubuntu-puppetmaster.sh"
    # Populate /etc/hosts with each VM in this file
    node.vm.provision :hosts
    node.vm.provision "puppet" do |puppet|
      puppet.module_path = "puppet/modules"
      puppet.manifests_path = "puppet"
      puppet.manifest_file = "vagrant.pp"
      puppet.hiera_config_path = "puppet/hiera.yaml"
    end
    node.vm.provision "shell", inline: "r10k deploy environment -vp"
    # Run Puppet and force exit code to 0 so Vagrant doesn't exit
    node.vm.provision "shell", inline: "puppet agent -t;true"
   end
  config.vm.define "elk" do |node|
    node.vm.host_name = "elk.eskp.net"
    node.vm.network :private_network, ip: "10.1.1.11"
    node.vm.network :forwarded_port, guest: 80, host: 8080 #Kibana
    node.vm.network :forwarded_port, guest: 9200, host: 9200 #Elasticsearch
    node.vm.provision :hosts
    node.vm.provision "shell", path: "bootstrap/ubuntu-puppet.sh"
    # Run Puppet and force exit code to 0 so Vagrant doesn't exit
    node.vm.provision "shell", inline: "puppet agent -t;true"
  end
  config.vm.define "mon" do |node|
    node.vm.host_name = "mon.eskp.net"
    node.vm.network :private_network, ip: "10.1.1.12"
    node.vm.provision :hosts
    node.vm.network :forwarded_port, guest: 15672, host: 15672 #RabbitMQ
    node.vm.network :forwarded_port, guest: 3000, host: 3000 #Uchiwa
    node.vm.provision "shell", path: "bootstrap/ubuntu-puppet.sh"
    # Run Puppet and force exit code to 0 so Vagrant doesn't exit
    node.vm.provision "shell", inline: "puppet agent -t;true"
  end
  config.vm.define "git" do |node|
    node.vm.host_name = "git.eskp.net"
    node.vm.network :private_network, ip: "10.1.1.13"
    node.vm.provision :hosts
    node.vm.network :forwarded_port, guest: 9090, host: 9090 #Jenkins
    node.vm.network :forwarded_port, guest: 80, host: 9595 #Gitlab
    node.vm.provision "shell", path: "bootstrap/ubuntu-puppet.sh"
    # Run Puppet and force exit code to 0 so Vagrant doesn't exit
    node.vm.provision "shell", inline: "puppet agent -t;true"
  end
end
