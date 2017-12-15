# ovd deployment functions
#

# install OVD software.
# preconditions:
# - invenory pointer file already exists
# - install images share mounted
# - root script finished on machine
#
ovd_install_software() {

    export ORACLE_HOME=
    export LD_LIBRARY_PATH=
    
    if ! [ -d "$ora_home" ]
    then
        log "OVD >> Installing OVD software..."
    
        ${s_ovd}/Disk1/runInstaller -silent \
          -jreLoc ${s_runjre} \
          -invPtrLoc ${orainv_ptr} \
          -response ${DEPLOYER}/user-config/ovd/ovd_install.rsp \
          -ignoreSysPrereqs \
          -nocheckForUpdates \
          -waitforcompletion
    
        log "OVD >> Successfully installed OVD software"
    else
        log "OVD >> Skipped OVD software installation"
    fi
}

# create ovd instance, as specified in response file
#
ovd_create_instance() {

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
}
