# Create user profile --------------------------------------
#
create_oms_user_env() {
    if ! [ -d ~/.env ]
    then
        log "OMS >> creating user environment..."

        mkdir -p $HOME/.env
        cp -f $DEPLOYER/lib/env/*.env $HOME/.env
        echo "source ~/.env/common.env" >>$HOME/.bash_profile
    fi
}

# clean em control are in repository database ----------------
#
oms_deregister_control() { (
log "OMS >> deregister database control in repository database"
    # ORACLE_HOME is set already
    export ORACLE_SID=$DB_SERVICENAME

    $ORACLE_HOME/bin/emca -deconfig dbcontrol db -repos drop \
      -SID $DB_SERVICENAME -PORT $DB_PORT \
      -SYS_PWD "$DBS_SYS_PWD" -SYSMAN_PWD "$DBS_SYSMAN_PWD"
) }

# Oracle Enterprise Manager configuration --------------------
#
configure_em() {
    if ! [ -d $DOMAIN_HOME ]
    then
        log "OMS >> configuring OMS..."
        # MEMORY_OPTIONS="-ms1024m -mx2048m -XX:MaxPermSize=2048m"
        $OEM_HOME/sysman/install/ConfigureGC.sh \
            WLS_DOMAIN_NAME=$DOMAIN_NAME \
            -silent \
            -responseFile $DEPLOYER/user-config/oem/em_config.rsp \
            -invPtrLoc $ORAINVPTR \
            -b_startAgent=false 
        log "OMS >> successfully configured OMS"
    fi
}

