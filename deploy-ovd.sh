#!/bin/sh -x

set -o errexit
set -o nounset

. $DEPLOYER/user-config/ovd/ovd.sh
. $DEPLOYER/user-config/oem.config

# create home dir ---------------------------------------
#
[ -d "$mw_home" ] || mkdir -p "$mw_home"

# install jdk ---------------------------------------
#
if ! [ -e "$s_runjre" ]
then
    pushd "$mw_home"
    tar -xzf "$s_java"
    # unzip -d "$mw_home" "$s_java"
    ln -s "$s_java_dir" jdk
    popd

    patch -b ${mw_home}/jdk/jre/lib/security/java.security \
        $DEPLOYER/user-config/ovd/java7.security.patch
fi

export PATH=/home/fmwuser/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:$s_runjre/bin
export JAVA_HOME=$s_runjre

source $DEPLOYER/lib/libiam.sh

create_orainvptr

# install weblogic ----------------------------------
#
weblogic_install $product

# install software ----------------------------------
#
export ORACLE_HOME=
export LD_LIBRARY_PATH=

if ! [ -d "$ora_home" ]
then
    echo "Installing OVD software..."

    ${s_ovd}/Disk1/runInstaller -silent \
      -jreLoc ${s_runjre} \
      -invPtrLoc ${orainv_ptr} \
      -response ${DEPLOYER}/user-config/ovd/ovd_install.rsp \
      -ignoreSysPrereqs \
      -nocheckForUpdates \
      -waitforcompletion

    echo "Successfully installed OVD software"
else
    echo "Skipped OVD software installation"
fi

# create ovd instance ----------------------------------
#
if ! [ -d "$instance_base/$instance_name" ]
then
    echo "Creating OVD instance..."

    ${ora_home}/bin/config.sh \
      -silent \
      -invPtrLoc ${orainv_ptr} \
      -responseFile ${DEPLOYER}/user-config/ovd/ovd_config.rsp \
      -jreLoc ${JAVA_HOME}/jre \
      -waitforcompletion \
      -noconsole

    echo "Successfully created OVD instance"
else
    echo "Skipped creation if OVD instance"
fi


