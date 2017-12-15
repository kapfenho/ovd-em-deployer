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


## Installation Images

The NFS mount point hosting the installation images shall shall look
like this tree (subdirectories are not shown):

```
oracle   [ -> mount point ]
├── database-ee-11.2.0.4
|   └── p13390677_112040_Linux-x86-64
|       ├── client
|       ├── database
|       ├── deinstall
|       ├── examples
|       ├── gateways
|       └── grid
├── weblogic
|   └── wls1036_generic.jar
├── em-12.1.0.5
|   ├── bipruntime
|   ├── install
|   ├── jdk
|   ├── libskgxn
|   ├── oms
|   ├── plugins
|   ├── release_notes.pdf
|   ├── response
|   ├── runInstaller
|   ├── stage
|   ├── wls
|   └── WT.zip
├── iam-11.1.1.9
|   ├── Disk1
|   │   ├── doc
|   │   ├── install
|   │   ├── runInstaller
|   │   ├── stage
|   │   └── utils
|   ├── Disk2
|   │   └── stage
|   ├── Disk3
|   │   └── stage
|   ├── Disk4
|   │   └── stage
|   ├── Disk5
|   │   └── stage
|   └── readme_fmw_ps7.htm
└── images
        java
        ├── java6
        │   └── jrockit-R28.2.8-p16863120_2828_Linux-x86-64.zip
        └── java7
            ├── jdk-7u75-linux-x64.tar.gz
            ├── jdk-7u76-linux-x64.tar.gz
            ├── jdk-7u76-macosx-x64.dmg
            ├── jdk-7u76-macosx-x86_64-demos.tar.gz
            ├── jre-7u75-linux-x64.tar.gz
            ├── server-jre-7u75-linux-x64.tar.gz
            └── server-jre-7u76-linux-x64.tar.gz

```

The exact path used in the virtual machines can be configure in the
config files in folder `user-config`.

The NFS mount is only used during deployment and can be removed
afterwards (`/etc/fstab`).
