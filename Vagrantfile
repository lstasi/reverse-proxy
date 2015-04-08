Vagrant.configure(2) do |config|
  config.vm.box = "puppetlabs/centos-6.6-64-nocm"
  config.vm.provision "shell", path: "provision/install_puppet.sh"
  config.vm.provision "puppet" do |puppet|
	puppet.options = "--verbose"
    puppet.module_path = "modules"
	end
end