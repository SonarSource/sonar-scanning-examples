# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
	config.vm.box = "ubuntu/xenial64"
	config.hostmanager.enabled = true
	config.hostmanager.manage_host = true
	config.hostmanager.manage_guest = true
	config.vm.provision "docker"

	config.vm.define "node1", primary: true do |node1|
		node1.vm.hostname = 'node1'
		node1.vm.network :private_network, ip: "192.168.99.101"
		node1.vm.provider :virtualbox do |v|
			v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
			v.customize ["modifyvm", :id, "--memory", 7000]
			v.customize ["modifyvm", :id, "--name", "node1"]
		end
    node1.vm.provision "docker" do |d|
      # d.run "compose",
      #   image: "docker/compose:1.17.1",
      #   cmd: "up",
      #   args: "-it -v /var/run/docker.sock:/var/run/docker.sock -v /vagrant:/compose -w /compose"
      d.run "sonarqube",
        image: "sonarqube:alpine",
        args: "-it -p 9000:9000 -p 9092:9092"
    end
	end
end
