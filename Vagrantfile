Vagrant.configure("2") do |config|

    config.vm.provider "virtualbox" do |v|
      v.memory = 4096
      v.cpus = 2
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end

    config.vm.box = "CentOS-6.5-x86_64"
    config.vm.synced_folder ".", "/home/vagrant/git/cpp-makefile"
    config.vm.network "forwarded_port", guest: 8080, host: 8080
end
