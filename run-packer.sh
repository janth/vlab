#/bin/bash

vbox=packer-vbox.json

cat << X
packer validate ${vbox}
packer inspect ${vbox}
packer build ${vbox}
packer build --force ${vbox}

./jsonpp.pl ${vbox} | packer validate -
./jsonpp.pl ${vbox} | packer inspect -
./jsonpp.pl ${vbox} | packer build -
./jsonpp.pl ${vbox} | packer build --force -

packer build --debug --var 'sha=38d5d51d9d100fd73df031ffd6bd8b1297ce24660dc8c13a3b8b4534a4bd291c' --var 'iso=ISO/CentOS-7-x86_64-Minimal-1810.iso' packer-vbox.json
packer build --debug --var 'sha=7c0dee2a0494dabd84809b72ddb4b761f9ef92b78a506aef709b531c54d30770' --var 'iso=ISO/CentOS-6.10-x86_64-Minimal.iso' packer-vbox.json

packer build  --var 'sha=7c0dee2a0494dabd84809b72ddb4b761f9ef92b78a506aef709b531c54d30770' --var "iso=${PWD}/ISO/CentOS-6.10-x86_64-minimal.iso" -on-error=ask --force packer-vbox.json
packer build  --var 'sha=38d5d51d9d100fd73df031ffd6bd8b1297ce24660dc8c13a3b8b4534a4bd291c' --var 'iso=ISO/CentOS-7-x86_64-Minimal-1810.iso' -on-error=ask --force packer-vbox.json

X
