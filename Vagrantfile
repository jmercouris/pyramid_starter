# -*- mode: ruby -*-
# vi: set ft=ruby :
################################################################################
# Command line parsing and defaults
################################################################################
require 'getoptlong'

# Retrieve Arguments from the Command line
opts = GetoptLong.new(
                      [ '--webserver-machine-name', GetoptLong::OPTIONAL_ARGUMENT ], 
                      [ '--deploy-mode', GetoptLong::OPTIONAL_ARGUMENT ],
                      [ '--provider', GetoptLong::OPTIONAL_ARGUMENT ]
                      )

# Sensible Defaults for Inputted parameters
webserver_machine_name = 'webserver'
deploy_mode = 'development'

opts.each do |opt, arg|
  case opt
  when '--webserver-machine-name'
    webserver_machine_name=arg
  when '--deploy-mode'
    deploy_mode=arg
  end
end

################################################################################
# Vagrant box definition begin
################################################################################
# Vagrantfile API/syntax version.
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  ################################################################################
  # Virtualbox
  ################################################################################
  # Prefer VirtualBox before digital_ocean, providers are used in the order listed
  # https://docs.vagrantup.com/v2/providers/basic_usage.html
  config.vm.provider "virtualbox"
  # Define machine type and box image
  config.vm.box = "ubuntu/trusty64"
  config.vm.box_url = "https://atlas.hashicorp.com/ubuntu/boxes/trusty64"

  ################################################################################
  # Digital Ocean
  ################################################################################
  config.vm.provider :digital_ocean do |provider, override|
    override.ssh.private_key_path = '~/.ssh/id_rsa'
    override.vm.box = 'digital_ocean'
    override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"
    provider.token = 'INSERT_YOUR_PROVIDER_TOKEN_HERE'
    provider.name = 'instance'
    provider.image = 'ubuntu-14-04-x64'
    provider.region = 'nyc2'
    provider.size = '512mb'
  end

  # Web Server VM Configuration
  config.vm.define "#{webserver_machine_name}" do |web|
    web.ssh.forward_agent = true

    # If Development, forward port 6543, need root to use port below 1024
    if deploy_mode == "development" then
      web.vm.network :forwarded_port, host: 4567, guest: 6543
    end
    # If Production forward port 80
    if deploy_mode == "production" then
      web.vm.network :forwarded_port, host: 4567, guest: 80
    end

    web.vm.network "private_network", ip: "10.10.10.10"
    # web.vm.synced_folder "salt", "/srv/salt"

    # # Salt Provisioner
    # web.vm.provision :salt do |salt|
    #   # Relative location of configuration file to use for minion
    #   salt.minion_config = "salt/etc/webserver_#{deploy_mode}.conf"
    #   # Highstate basicly means "comapre the VMs current machine state against 
    #   # what it should be and make changes if necessary".
    #   salt.run_highstate = true
    #   # Vagrant 1.7.4 Fix - alternatively use 1.7.2 and comment out the line below
    #   salt.bootstrap_options = '-F -c /tmp/ -P'
    #   # Run in verbose mode, so it will output all debug info to the console.
    #   # salt.verbose = true
    # end
  end
end
