# Create user profile --------------------------------------
#
create_oms_user_env() {
    if ! [ -d ~/.env ]
    then
        log "OMS >> creating user environment..."

        mkdir -p $HOME/.env
        echo "source ~/.env/common.env" >>$HOME/.bash_profile
        cp -f $DEPLOYER/lib/env/bashrc        $HOME/.bashrc
        cp -f $DEPLOYER/lib/env/emcli.sh      $HOME/.env

        . ~/.bashrc

        log "OMS >> user environment successfully created, files:"
        log "       - ~/.bash_profile"
        log "       - ~/.bashrc"
        log '       - ~/.env/*'
    fi
}

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

