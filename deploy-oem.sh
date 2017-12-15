#!/bin/sh

set -o errexit
set -o nounset

umask 0022

. $DEPLOYER/lib/libcommon.sh
. $DEPLOYER/lib/libcommon2.sh
. $DEPLOYER/lib/liboem.sh
. $DEPLOYER/user-config/oem.config

if ! [ -d $ORACLE_HOME ]
then
    log "OEM >> installing software..."

    cat > $ORAINVPTR <<-EOS
inventory_loc=/opt/oracle/oraInventory
inst_group=oinstall
EOS

    ${IMAGE_OEM}/runInstaller -silent \
        -invPtrLoc ${ORAINVPTR} \
        -responseFile $DEPLOYER/user-config/oem/em_software_only.rsp \
        -waitforcompletion
    
    # cp ${BASE}/doc/em-upgrade-README.markdown \
    #     ${BASE_OEM}/README.markdown
    log "OEM >> software successfully installed"
fi

# post install: execute inventory script only if first Oracle product on host
if ! [ -f /etc/oraInst.loc ]
then
    log "OEM >> running inventory root script orainstRoot.sh..."
    sudo -n ${ORAINV}/orainstRoot.sh
    log "OEM >> inventory root script ran successfully"
fi

# post install: execute EM root script
if ! [ -f /etc/init.d/gcstartup ]
then
    log "OEM >> running service root script allroot.sh..."
    sudo -n ${OEM_HOME}/allroot.sh
    log "OEM >> service root script ran successfully"
fi

# create oms instance
configure_em

# create profiles
create_oms_user_env

source ~/.env/common.env
source ~/.env/oms.env

log "OEM >> restarting instance..."

# restart oms instance
${OEM_HOME}/bin/emctl stop oms -all
${OEM_HOME}/bin/emctl start oms

log "OEM >> deployment finished successfully"
