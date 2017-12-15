#!/bin/sh

set -o errexit
set -o nounset

umask 0002

# settings
. $DEPLOYER/user-config/ovd/ovd.sh
. $DEPLOYER/user-config/oem.config
# functions
. $DEPLOYER/lib/libovd.sh

# create home dir
[ -d "$mw_home" ] || mkdir -p "$mw_home"

ovd_install_jdk

export PATH=/home/fmwuser/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:$s_runjre/bin
export JAVA_HOME=$s_runjre

source $DEPLOYER/lib/libiam.sh

create_orainvptr

weblogic_install $product

ovd_install_software

ovd_create_instance

