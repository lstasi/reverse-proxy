#!/bin/bash
if [ ! -f "/vagrant/.puppet_installed" ]
then
  echo "Install puppet repository"
	sudo rpm -ivh https://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-7.noarch.rpm
	echo "Install puppet"
	sudo yum install puppet -y
	touch /vagrant/.puppet_installed
fi
echo "Puppet already installed"

