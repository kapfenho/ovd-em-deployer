Oracle Enterprise Manager 12c and OVD Agent
===========================================

A showcase for the EM12c management features for Oracle Virtual Directory.

This vagrant project provisions two virtual CentOS machines, one running 
EM12 and the other OVD.  The OVD instance will be monitored by the EM12 
agent.


## Versions

- Enterprise Manager 12.1.0.5
- Virtual Directory 11.1.1.9
- Enterprise Database 11.2.0.4

## Usage

Before running the deploment you need to get the Oracle installation
images in the stated version.  Extract the images and make them available
by NFS. You can customize the client mount options in the `Vagrantfile`.

You'll also need virtualization solution installed and
[Vagrant](https://www.vagrantup.com).  The `Vagrantfile` is using the 
[VirtualBox](https://www.virtualbox.org) provider, but this can be
adapted easily. The VM NIC will use a private network (host only
adapters). Adapt the IP adresses in the `Vagrantfile` if necessary.

To start the deployment process (including VM creation):

    $ vagrant up [ oms | ovd ]

The deployment took on my machine around two to three hours.

In case you are not familiar with Vagrant and its features check the
[Vagrant documentation](https://www.vagrantup.com/docs/index.html).

