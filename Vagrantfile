# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANT_API_VERSION = '2'

VAGRANT_VM_BOX = 'boxcutter/debian82'
VAGRANT_VM_NAME_PREFIX = "machine-"

# Set how many machines to provision
VAGRANT_VM_QTY = 3

LOCAL_HOSTNAME_ALIASES = %w(
)

Vagrant.configure(VAGRANT_API_VERSION) do |config|
    # Hostmanager https://github.com/smdahlen/vagrant-hostmanager
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true

    # Using Vagrant's default ssh key
    config.ssh.insert_key = false
    # Your private key must be available to the local ssh-agent.
    # You can check with ssh-add -L
    # If your key is not listed add it with ssh-add ~/.ssh/id_rsa
    config.ssh.forward_agent = true

    (1..VAGRANT_VM_QTY).each do |vm_id|
        vm_name = "#{VAGRANT_VM_NAME_PREFIX}#{vm_id}"

        config.vm.define vm_name do |node|
            node.vm.hostname = vm_name
            node.vm.box = VAGRANT_VM_BOX
            # Hostmanager aliases
            node.hostmanager.aliases = LOCAL_HOSTNAME_ALIASES

            config.vm.provider :virtualbox do |provider, override|
              provider.memory = 2048
              provider.cpus = 4
              provider.name = vm_name

              override.vm.network :private_network, ip:  '10.0.3.33'
            end

            node.vm.provider :parallels do |pls, override|
                pls.memory = 2048
                pls.cpus = 4
                pls.name = vm_name

                override.vm.box = 'parallels/centos-7.1'
            end
        end
    end
end
