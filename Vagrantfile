# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"
 
  config.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.vm.define :logstash do |config|
      config.vm.box = "logstash"
      config.vm.provision :puppet do |puppet|
          puppet.manifests_path = "puppet/manifests"
          puppet.module_path    = "puppet/modules"
          puppet.options        = "--verbose --hiera_config hiera.yaml"
          puppet.manifest_file  = "init.pp"
      end
  end
end
