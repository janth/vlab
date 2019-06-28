A repo using packer to create VirtualBox images, then using Vagrant to set the images up as Puppet PE server with clients,

| vbox/host name | OS | Function |
----------------------------------
| master  | CentOS7 | PE master, with PuppetDB, Bolt, CD4PE, ... |
| client1 | RHEL8 | client |
| client2 | RHEL7 | client |
| client3 | RHEL6 | client |
| client4 | RHEL5 | client |
| client4 | RHEL4 | client |

