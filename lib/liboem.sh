# Create user profile --------------------------------------
#
create_oms_user_env() {
    if ! [ -d ~/.env ]
    then
        log "OMS >> creating user environment..."

        mkdir -p $HOME/.env
        cp -f $DEPLOYER/lib/env/*.env $HOME/.env
        mkdir -p $HOME/bin
        cp -f $DEPLOYER/lib/templates/oem/bin/* $HOME/bin
        chmod 0755 ~/bin/*

        echo "source ~/.env/common.env" >>$HOME/.bash_profile
        echo "source ~/.env/oms.env"    >>$HOME/.bash_profile
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

# Configure OEM Master Agent
# configure_master() {
#   # Creating plugin list for OEM Master Agent
#   ${AGENT_HOME}/perl/bin/perl ${AGENT_HOME}/sysman/install/create_plugin_list.pl \
#       -instancehome ${MASTER_INST}
# }

