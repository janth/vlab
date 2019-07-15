#!/bin/bash

script_name=${0##*/}                               # Basename, or drop /path/to/file
script=${script_name%%.*}                          # Drop .ext.a.b
script_path=${0%/*}                                # Dirname, or only /path/to
script_path=$( [[ -d ${script_path} ]] && cd ${script_path} ; pwd)             # Absolute path
script_path_name="${script_path}/${script_name}"   # Full path and full filename to $0
absolute_script_path_name=$( /bin/readlink --canonicalize ${script_path}/${script_name})   # Full absolute path and filename to $0
absolute_script_path=${absolute_script_path_name%/*}                 # Dirname, or only /path/to, now absolute
script_basedir=${script_path%/*}                   # basedir, if script_path is .../bin/



out=/root/.inst
[[ ! -d ${out} ]] && mkdir ${out}
echo "Hello, world! from ${absolute_script_path_name} run at host ${HOSTNAME} as ${USER} in ${PWD}" | tee ${out}/install-ansible.out

(
echo ip a:
/sbin/ip a
echo

echo ip r:
/sbin/ip r
echo
) | tee ${out}/ipcfg

# Exit immediately on non-zero return code
#set -e

for pkg in epel-release wget git htop ; do
   echo "yum: Installing ${pkg}"
   /usr/bin/yum -y install ${pkg}
done

# elver=$( grep -o ' [0-9]' /etc/redhat-release )
# remove leading whitespace characters
# elver="${elver#"${elver%%[![:space:]]*}"}"
# remove trailing whitespace characters
# elver="${elver%"${elver##*[![:space:]]}"}"
elver=$( sed -e 's/.*release \([0-9][0-9]*\).*/\1/' /etc/redhat-release )
case ${elver} in
   7) pipbin=/usr/bin/pip3.6
      pippkg=python36-pip
      echo "yum: Installing ${pippkg}"
      /usr/bin/yum -y install python36-pip

      echo "pip3: Upgrading pip3"
      /usr/bin/pip3.6 install pip --upgrade --progress-bar off

      echo "pip3: installing ansible 2.7.2"
      /usr/local/bin/pip3.6 install 'ansible==2.7.2' --progress-bar off

      echo "pip3: installing pydf"
      /usr/local/bin/pip3.6 install pydf --progress-bar off
      ;;
   *) echo "ERROR: Unknown EL version '${elver}', aborting here" 
   exit ;;
esac

# TODO:
#   Get ansible plays from git and run...

# Record the packer http server's ip and port
echo > ${out}/.packer.url
echo "PACKER_HTTP_ADDR=${PACKER_HTTP_ADDR}" >> /root/.packer.url
echo "PACKER_BUILDER_TYPE=${PACKER_BUILDER_TYPE}" >> /root/.packer.url
echo "PACKER_BUILD_NAME=${PACKER_BUILD_NAME}" >> /root/.packer.url

env | sort > ${out}/.env
