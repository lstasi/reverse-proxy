#!/bin/bash
if [ ! -f "/.provision/.puppet_installed" ]
then
  echo "Install puppet repository"
	sudo rpm -ivh https://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-7.noarch.rpm
	echo "Install puppet"
	sudo yum install puppet -y
	mkdir -p /.provision
	touch /.provision/.puppet_installed
fi
echo "Puppet already installed"

