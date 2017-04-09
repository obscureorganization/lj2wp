# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# Adapted from https://gist.github.com/danielpataki/0861bf91430bf2be73da#file-way-sh

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.network :private_network, ip: "192.168.33.21"
  config.vm.provision :shell, :path => "install.sh"
  # Let web server write to /var/www so WordPress uploads work
  # Thanks for the tip http://jeremykendall.net/2013/08/09/vagrant-synced-folders-permissions/
  config.vm.synced_folder ".", "/var/www", owner: "vagrant", group: "www-data", mount_options: ["dmode=775,fmode=664"]
end
