#!/bin/bash

script_name=${0##*/}                               # Basename, or drop /path/to/file
script=${script_name%%.*}                          # Drop .ext.a.b
script_path=${0%/*}                                # Dirname, or only /path/to
script_path=$( [[ -d ${script_path} ]] && cd ${script_path} ; pwd)             # Absolute path
script_path_name="${script_path}/${script_name}"   # Full path and full filename to $0
absolute_script_path_name=$( /bin/readlink --canonicalize ${script_path}/${script_name})   # Full absolute path and filename to $0
absolute_script_path=${absolute_script_path_name%/*}                 # Dirname, or only /path/to, now absolute
script_basedir=${script_path%/*}                   # basedir, if script_path is .../bin/




echo "Hello, world! from ${absolute_script_path_name} run at host ${HOSTNAME} as ${USER} in ${PWD}" | tee /var/tmp/install-ansible.out

/sbin/ip a
/sbin/ip r

# Exit immediately on non-zero return code
#set -e

echo "yum: Installing epel-release"
/usr/bin/yum -y install epel-release

echo "yum: Installing wget"
/usr/bin/yum -y install wget

echo "yum: Installing git"
/usr/bin/yum -y install git

elver=$( grep -o ' [0-9]' /etc/redhat-release )
# remove leading whitespace characters
elver="${elver#"${elver%%[![:space:]]*}"}"
# remove trailing whitespace characters
elver="${elver%"${elver##*[![:space:]]}"}"
case ${elver} in
   7) pipbin=/usr/bin/pip3.6
      pippkg=python36-pip
      echo "yum: Installing ${pippkg}"
      /usr/bin/yum -y install python36-pip

      echo "pip3: Upgrading pip3"
      /usr/bin/pip3.6 install pip --upgrade

      echo "pip3: installing ansible 2.7.2"
      /usr/local/bin/pip3.6 install 'ansible==2.7.2' --progress-bar off
      ;;
   *) echo "ERROR: Unknown EL version '${elver}', aborting here" 
   exit ;;
esac

# TODO:
#   Get ansible plays from git and run...

