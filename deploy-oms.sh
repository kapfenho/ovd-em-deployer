#!/bin/sh -x

set -o errexit
set -o nounset

umask 0002

. ${DEPLOYER}/lib/libcommon.sh
. ${DEPLOYER}/lib/libcommon2.sh
. ${DEPLOYER}/lib/liboms.sh

source ${DEPLOYER}/user-config/files.sh
source ${DEPLOYER}/user-config/files_em.sh

if ! [ -d $ORACLE_HOME ]
then
    log "OMS >> installing software..."

    cat > $ORAINVPTR <<-EOS
inventory_loc=/opt/oracle/oraInventory
inst_group=oinstall
EOS

    ${IMAGE_OEM}/runInstaller -silent \
        -invPtrLoc ${ORAINVPTR} \
        -responseFile $DEPLOYER/user-config/oms/em_software_only.rsp \
        -waitforcompletion
    
    # cp ${BASE}/doc/em-upgrade-README.markdown \
    #     ${BASE_OEM}/README.markdown
    log "OMS >> software successfully installed"
fi

# Configure OEM Master Agent
# configure_master() {
#   echo "-- Creating plugin list for OEM Master Agent"
#   ${AGENT_HOME}/perl/bin/perl ${AGENT_HOME}/sysman/install/create_plugin_list.pl \
#       -instancehome ${MASTER_INST}
# }

# root actions after install ---------------------------------
#
# execute inventory script only if first Oracle product on host
#
if ! [ -f /etc/oraInst.loc ]
then
    log "OMS >> running inventory root script orainstRoot.sh..."
    sudo -n ${ORAINV}/orainstRoot.sh
    log "OMS >> inventory root script ran successfully"
fi

# execute EM root script
#
if ! [ -f /etc/init.d/gcstartup ]
then
    log "OMS >> running service root script allroot.sh..."
    sudo -n ${OEM_HOME}/allroot.sh
    log "OMS >> service root script ran successfully"
fi


# configure Oracle Enterprise Manager
configure_em

# create profile
create_oms_user_env

log "OMS >> restarting instance..."

# restart oms instance
${OEM_HOME}/bin/emctl stop oms -all
${OEM_HOME}/bin/emctl start oms

log "OMS >> deployment finished successfully"
