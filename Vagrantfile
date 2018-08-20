# -*- mode: ruby -*-
# vi: set ft=ruby :


# https://github.com/hashicorp/vagrant/issues/1874#issuecomment-165904024
# not using 'vagrant-vbguest' vagrant plugin because now using bento images which has vbguestadditions preinstalled.
def ensure_plugins(plugins)
  logger = Vagrant::UI::Colored.new
  result = false
  plugins.each do |p|
    pm = Vagrant::Plugin::Manager.new(
      Vagrant::Plugin::Manager.user_plugins_file
    )
    plugin_hash = pm.installed_plugins
    next if plugin_hash.has_key?(p)
    result = true
    logger.warn("Installing plugin #{p}")
    pm.install_plugin(p)
  end
  if result
    logger.warn('Re-run vagrant up now that plugins are installed')
    exit
  end
end

required_plugins = ['vagrant-hosts', 'vagrant-share', 'vagrant-vbox-snapshot', 'vagrant-host-shell', 'vagrant-reload']
ensure_plugins required_plugins



Vagrant.configure(2) do |config|
  config.vm.define "routingvm" do |routingvm_config|
    #routingvm_config.vm.box = "bento/centos-7.3"
    routingvm_config.vm.box = "bento/centos-7.5"
    routingvm_config.vm.hostname = "routingvm.local"
    # https://www.vagrantup.com/docs/virtualbox/networking.html
    routingvm_config.vm.network "private_network", ip: "192.168.10.100", :netmask => "255.255.255.0", virtualbox__intnet: "intnet1"
    routingvm_config.vm.network "private_network", ip: "10.0.0.10", :netmask => "255.255.255.0", virtualbox__intnet: "intnet2"

    routingvm_config.vm.provider "virtualbox" do |vb|
      vb.gui = true
      vb.memory = "2048"
      vb.cpus = 2
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.name = "centos7_routingvm"
    end

    routingvm_config.vm.provision "shell", path: "scripts/install-rpms.sh", privileged: true
    routingvm_config.vm.provision "shell", path: "scripts/router-setup.sh", privileged: true
    routingvm_config.vm.provision :reload
  end



  config.vm.define "box1" do |box1_config|
    box1_config.vm.box = "bento/centos-7.5"
    box1_config.vm.hostname = "box1.local"
    box1_config.vm.network "private_network", ip: "192.168.10.101", :netmask => "255.255.255.0", virtualbox__intnet: "intnet1"

    box1_config.vm.provider "virtualbox" do |vb|
      vb.gui = true
      vb.memory = "1024"
      vb.cpus = 2
      vb.name = "centos7_box1"
    end

    box1_config.vm.provision "shell", path: "scripts/install-rpms.sh", privileged: true
    box1_config.vm.provision "shell", path: "scripts/source-setup.sh", privileged: true
  end

  config.vm.define "box2" do |box2_config|
    box2_config.vm.box = "bento/centos-7.5"
    box2_config.vm.hostname = "box2.local"
    box2_config.vm.network "private_network", ip: "10.0.0.11", :netmask => "255.255.255.0", virtualbox__intnet: "intnet2"

    box2_config.vm.provider "virtualbox" do |vb|
      vb.gui = true
      vb.memory = "1024"
      vb.cpus = 2
      vb.name = "centos7_box2"
    end

    box2_config.vm.provision "shell", path: "scripts/install-rpms.sh", privileged: true
  end


end
