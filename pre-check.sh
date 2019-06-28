#!/bin/bash

script_name=${0##*/}                               # Basename, or drop /path/to/file
script=${script_name%%.*}                          # Drop .ext.a.b
script_path=${0%/*}                                # Dirname, or only /path/to
script_path=$( [[ -d ${script_path} ]] && cd ${script_path} ; pwd)             # Absolute path
script_path_name="${script_path}/${script_name}"   # Full path and full filename to $0

readlink=/bin/readlink
[[ $(uname -s) = "Darwin" ]] && readlink=/usr/local/bin/greadlink # brew install coreutils

case $( uname -s ) in
   Darwin) absolute_script_path_name=$( /bin/readlink --canonicalize ${script_path}/${script_name}) ;;  # Full absolute path and filename to $0
   Linux) absolute_script_path_name=$( /bin/readlink --canonicalize ${script_path}/${script_name}) ;;  # Full absolute path and filename to $0
   *) absolute_script_path_name='' ;;
esac
absolute_script_path=${absolute_script_path_name%/*}                 # Dirname, or only /path/to, now absolute
script_basedir=${script_path%/*}                   # basedir, if script_path is .../bin/

declare -a Binaries=( packer vagrant vboxmanage puppet r10k terraform ansible )
declare -i reqbin_err=0
for bin in ${Binaries[*]} ; do
   if ! type ${bin} >/dev/null 2>&1 ; then
      echo "ERROR: Missing required binary '${bin}', (not found in path or not installed)"
      reqbin_err=$(( reqbin_err++ ))
   fi
done
[[ ${reqbin_err} -gt 0 ]] && exit 1


 : << X

brew install packer packer-completion
brew install ansible
brew install terraform
brew cask install vagrant vagrant-manager

puppet: https://puppet.com/docs/puppet/5.3/install_osx.html

virtualbox: https://www.virtualbox.org/wiki/Downloads

- or -

brew cask install virtualbox virtualbox-extension-pack

X
