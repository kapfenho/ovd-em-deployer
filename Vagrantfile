# Oracle Enterprise Manager
# CentOS 6.4 64bit
# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
oms_ip = "192.168.168.45"
ovd_ip = "192.168.168.48"
box = "centos67fusion"
box_url = "https://agoracon.at/boxes/centos67fusion.box"

hostfile = "
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
#{oms_ip}  oms.vie.agoracon.at   oms
#{ovd_ip}  ovd.vie.agoracon.at   ovd
"
$images = "10.80.1.6:/usr/export/agora/install/oracle /mnt/oracle nfs rw,bg 0 0\n"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.provision "hostsfile", type: "shell" do |s|
    s.inline = "echo '#{hostfile}' > /etc/hosts"
  end

  config.vm.provision "sysconfig", type: "shell" do |s|
    s.inline = "/vagrant/root-script.sh"
  end

  config.vm.provision "nfs", type: "shell" do |s|
    s.inline = "mkdir -p /mnt/oracle ;
    echo '#{$images}' >>/etc/fstab ;
    mount /mnt/oracle"
  end
  
  config.vm.define :oms, primary: true do |oms|
    oms.vm.hostname = "oms.vie.agoracon.at"
    oms.vm.box      = box
    oms.vm.box_url  = box_url
    oms.vm.network :private_network, ip: oms_ip

    oms.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id,
                    "--memory", 8 * 1024, 
                    "--name", "oms",
                    "--cpus", 4]
    end

    oms.vm.provision "database", type: "shell" do |s|
      s.inline = "su - oracle  -c 'DEPLOYER=/vagrant /vagrant/deploy-database.sh | /usr/bin/tee /tmp/prov-database.log'"
    end

    oms.vm.provision "oem", type: "shell" do |s|
      s.inline = "su - oem  -c 'DEPLOYER=/vagrant /vagrant/deploy-oem.sh | /usr/bin/tee /tmp/prov-oem.log'"
    end

  end

  config.vm.define :ovd do |ovd|
    ovd.vm.hostname = "ovd.vie.agoracon.at"
    ovd.vm.box      = box
    ovd.vm.box_url  = box_url
    ovd.vm.network :private_network, ip: ovd_ip

    ovd.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id,
                    "--memory", 4 * 1024,
                    "--name", "ovd",
                    "--cpus", 4]
    end

    ovd.vm.provision "ovd", type: "shell" do |s|
      s.inline = "su - fmwuser -c 'DEPLOYER=/vagrant /vagrant/deploy-ovd.sh | /usr/bin/tee /tmp/prov-ovd.log'"
    end

  end

end

