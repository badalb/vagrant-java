# Single box with VirtualBox provider and Puppet provisioning.
#
# NOTE: Make sure you have the precise32 base box installed...
# vagrant box add precise32 http://files.vagrantup.com/precise32.box

# ------------------------------ #
#         Config Values
# ------------------------------ #
#
# If you wish to override the default config values, create a JSON
# file called Vagrantfile.json on the same folder as this file
#

configValues = {
  # box to build from
  "box" => "Official Ubuntu 14.04 daily Cloud Image amd64 " +
           "(Development release, No Guest Additions)",

  # the url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system
  "box_url" => "https://cloud-images.ubuntu.com/vagrant/trusty/"    +
               "current/trusty-server-cloudimg-amd64-vagrant-disk1" +
               ".box",

  # private IP address for the VM
  "ip" => '192.168.60.22',

  # hostname for the VM
  "hostname" => "dev.homeunion"
}

if File.exist?('./Vagrantfile.json')
  begin
    configValues.merge!(JSON.parse(File.read('./Vagrantfile.json')))
  rescue JSON::ParserError => e
    puts "Error Parsing Vagrantfile.json", e.message
    exit 1
  end
end

# ------------------------------ #
#        Start Vagrant
# ------------------------------ #

Vagrant.configure("2") do |config|
  config.vm.box = configValues["box"]
  config.vm.box_url = configValues["box_url"]
  config.vm.network "private_network", ip: configValues['ip']
  config.vm.hostname = configValues['hostname']

  # Forward ports
  #config.vm.network :forwarded_port, guest: 8080, host: 8080    # Java app server; jetty
  #config.vm.network :forwarded_port, guest: 5432, host: 5432    # Postgres DB
  #config.vm.network :forwarded_port, guest: 3306, host: 3306 

  # Share the working dir - host, guest
  config.vm.synced_folder "project", "/vagrant"
  config.vm.synced_folder "puppet/modules", "/puppet"

 # config.vm.provision "shell", inline: "apt-get update --fix-missing"

  config.vm.provision :puppet do |puppet|
     puppet.manifests_path  = "puppet/manifests"
     puppet.manifest_file   = "default.pp"
     puppet.module_path     = "puppet/modules"
     puppet.options         = "--verbose"
  end
end
