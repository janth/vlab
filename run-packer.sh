#/bin/bash

vbox=packer-vbox.json

cat << X
packer validate ${vbox}
packer inspect ${vbox}
packer build ${vbox}
packer build --force ${vbox}

jsonpp.pl ${vbox} | packer validate -
jsonpp.pl ${vbox} | packer inspect -
jsonpp.pl ${vbox} | packer build -
jsonpp.pl ${vbox} | packer build --force -

X
