# Create user profile --------------------------------------
#
create_oms_user_env() {
    if ! [ -d ~/.env ]
    then
        log "OMS >> creating user environment..."

        cat ${OEM_ENV} > ${HOME}/.bash_profile
        cp -f ${BASHRC_CONFIG} ${HOME}/.bashrc
        mkdir -p ${HOME}/.env
        cp -f ${LIB_DIR}/env/emcli.sh ${HOME}/.env

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
        ${OEM_HOME}/sysman/install/ConfigureGC.sh \
            WLS_DOMAIN_NAME=${DOMAIN_NAME} \
            -silent \
            -responseFile ${RESP_DIR}/em_config.rsp \
            -invPtrLoc ${ORAINVPTR} \
            -b_startAgent=false 
        log "OMS >> successfully configured OMS"
    fi
}

# Link all OMS and Agent log directories to /var/log/oms ------
#
setup_logs(){
  # Maybe prevent the servers to start after the configuration
  # because the initial logs would be erased by this setup...

  declare -A old_new_log

  DOMAIN_LOGS=${LOGS_DIR}/${DOMAIN_NAME}
  
  # OMS logs 
  old_new_log["${DOMAIN_HOME}/servers/EMGC_OMS1/logs"]="${DOMAIN_LOGS}/EMGC_OMS1"
  old_new_log["${DOMAIN_HOME}/servers/EMGC_OMS1/data/ldap/log"]="${DOMAIN_LOGS}/EMGC_OMS1_ldap"
  old_new_log["${DOMAIN_HOME}/servers/EMGC_OMS1/sysman/log"]="${DOMAIN_LOGS}/EMGC_OMS1_sysman"

  old_new_log["${DOMAIN_HOME}/servers/EMGC_ADMINSERVER/logs"]="${DOMAIN_LOGS}/EMGC_ADMINSERVER"
  old_new_log["${DOMAIN_HOME}/servers/EMGC_ADMINSERVER/data/ldap/log"]="${DOMAIN_LOGS}/EMGC_ADMINSERVER_ldap"
  old_new_log["${DOMAIN_HOME}/servers/EMGC_ADMINSERVER/sysman/log"]="${DOMAIN_LOGS}/EMGC_ADMINSERVER_sysman"

  old_new_log["${EM_INST}/em/EMGC_OMS1/sysman/log"]="${LOGS_DIR}/oem_cli"
  old_new_log["${MW_HOME}/logs"]="${LOGS_DIR}/oem_wlst"

  old_new_log["${EM_INST}/WebTierIH1/diagnostics/logs/OPMN/opmn"]="${LOGS_DIR}/WebTierIH1/OPMN/opmn"
  old_new_log["${EM_INST}/WebTierIH1/diagnostics/logs/OHS/ohs1"]="${LOGS_DIR}/WebTierIH1/OHS/ohs1"

  # Agent logs
  old_new_log["${BASE_AGENT}/agent_inst/sysman/log"]="${LOGS_DIR}/oemagent/agent_inst"

  for old in "${!old_new_log[@]}"; do
    OLD=${old}
    NEW=${old_new_log[${old}]}

    mkdir -p ${NEW}
    rm -r ${OLD}
    ln -s ${NEW} ${OLD}
  done
}

