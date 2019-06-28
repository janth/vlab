#/bin/bash

vbox=packer-vbox.json

cat << X
packer validate ${vbox}
packer inspect ${vbox}
packer build ${vbox}
packer build --force ${vbox}

X
