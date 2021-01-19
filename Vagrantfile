default_box = 'ubuntu/focal64'
host_ip = '10.10.10.100'
master_ip = '10.10.10.101'
nodes_ip = ['10.10.10.102', '10.10.10.103']
nodes_name_maps = {'10.10.10.102'=>'node-1', '10.10.10.103'=>'node-2'}
user = 'vagrant'
bashrc_location = '/home/'+ user +'/.bashrc'

Vagrant.configure("2") do |config|
    config.vm.define "k3sup-host" do |host|
        host.vm.provision "file", source: "keys/id_rsa.pub", destination: ".ssh/id_rsa.pub"
        host.vm.provision "file", source: "keys/id_rsa", destination: ".ssh/id_rsa"
        host.vm.provision "file", source: "k3sup-cluster.sh", destination: "k3sup-cluster.sh"

        host.vm.box = default_box
        host.vm.synced_folder ".", "/vagrant", type:"virtualbox"
        host.vm.network "private_network", ip: host_ip, virtualbox__intnet: true
        host.vm.network "public_network", type: "dhcp", bridge: "eth0"
        host.vm.provider "virtualbox" do |v|
            v.memory = 1024
            v.cpus = 2
            v.name =  "k3sup-host"
        end

        host.vm.provision "shell", inline: <<-SHELL
            chmod 700 /home/vagrant/.ssh/id_rsa
            echo "export SERVER_IP=#{master_ip}" >> #{bashrc_location}
            echo "export NODE1_IP=#{nodes_ip[0]}" >> #{bashrc_location}
            echo "export NODE2_IP=#{nodes_ip[1]}" >> #{bashrc_location}
            echo "export KUBECONFIG=`pwd`/kubeconfig" >> #{bashrc_location}
        SHELL
    end

    config.vm.define "k3sup-master" do |master|
        master.vm.provision "file", source: "keys/id_rsa.pub", destination: "id_rsa.pub"
        master.vm.box = default_box
        master.vm.hostname = "k3sup-master"
        master.vm.synced_folder ".", "/vagrant", type:"virtualbox"
        master.vm.network "private_network", ip: master_ip,  virtualbox__intnet: true
        master.vm.network "forwarded_port", guest: 6443, host: 6443 # ACCESS K8S API
        for p in 30000..30100 # PORTS DEFINED FOR K8S TYPE-NODE-PORT ACCESS
            master.vm.network "forwarded_port", guest: p, host: p, protocol: "tcp"
        end
        master.vm.provider "virtualbox" do |v|
            v.memory = "1024"
            v.cpus = 1
            v.name = "k3sup-master"
        end

        master.vm.provision "shell", inline: <<-SHELL
            cat /home/vagrant/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
        SHELL
    end

    nodes_ip.each do |ip|
        config.vm.define nodes_name_maps[ip] do |node|
            node.vm.provision "file", source: "keys/id_rsa.pub", destination: "id_rsa.pub"
            node.vm.box = default_box
            node.vm.hostname = nodes_name_maps[ip]
            node.vm.synced_folder ".", "/vagrant", type:"virtualbox"
            node.vm.network 'private_network', ip: ip,  virtualbox__intnet: true
            node.vm.provider "virtualbox" do |v|
                v.memory = "1024"
                v.cpus = 1
                v.name = nodes_name_maps[ip]
            end

            node.vm.provision "shell", inline: <<-SHELL
                cat /home/vagrant/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
            SHELL
        end
    end
end