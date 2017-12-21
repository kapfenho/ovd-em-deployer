# ovd deployment functions
#

# -----------------------------------------------------------------------
#  create oracle inventory pointer
#
ovd_create_orainvptr()
{
  if ! [ -a ${iam_orainv_ptr} ] ; then
      log "OVD >> Creating Oracle Inventory Pointer..."

    cat > ${iam_orainv_ptr} <<-EOS
      inventory_loc=${iam_orainv}
      inst_group=${iam_orainv_grp}
EOS
      log "OVD >> Successfully created Oracle Inventory Pointer"
  fi
}

# -----------------------------------------------------------------------
# install weblogic server
#
weblogic_install()
{
  local _mw="${iam_top}/products/${1}"

  if ! [ -a ${_mw}/wlserver_10.3 ] ; then

    log "OVD >> Installing Weblogic Server..."

    local _xml=$(mktemp /tmp/wls-XXXXXXXX)

    cat > ${_xml} <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<bea-installer>
<input-fields>
<data-value name="BEAHOME" value="${_mw}" />
<data-value name="WLS_INSTALL_DIR" value="${_mw}/wlserver_10.3" />
<data-value name="COMPONENT_PATHS" value="WebLogic Server/Core Application Server|WebLogic Server/Administration Console|WebLogic Server/Configuration Wizard and Upgrade Framework|WebLogic Server/Web 2.0 HTTP Pub-Sub Server|WebLogic Server/WebLogic SCA|WebLogic Server/WebLogic JDBC Drivers|WebLogic Server/Third Party JDBC Drivers|WebLogic Server/WebLogic Server Clients|WebLogic Server/WebLogic Web Server Plugins|WebLogic Server/UDDI and Xquery Support|Oracle Coherence/Coherence Product Files" />
</input-fields>
</bea-installer>
EOS
    java -d64 -jar ${s_wls} -mode=silent -silent_xml=${_xml}
    rm -f ${_xml}

    log "OVD >> Successfully installed Weblogic Server"
  else
    log "OVD >> Skipped Weblogic server installation"
  fi
}


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
        log "Creating OVD instance..."
    
        ${ora_home}/bin/config.sh \
          -silent \
          -invPtrLoc ${orainv_ptr} \
          -responseFile ${DEPLOYER}/user-config/ovd/ovd_config.rsp \
          -jreLoc ${JAVA_HOME}/jre \
          -waitforcompletion \
          -noconsole
    
        log "Successfully created OVD instance"
    else
        log "Skipped creation if OVD instance"
    fi
}

# ovd_install_jdk
#
ovd_install_jdk() {

    if ! [ -e "$s_runjre" ]
    then
        log "OVD >> Installing JDK..."
        pushd "$mw_home"
        tar -xzf "$s_java"
        # unzip -d "$mw_home" "$s_java"
        ln -s "$s_java_dir" jdk
        popd
    
        log "OVD >> Patching JDK..."

        patch -b ${mw_home}/jdk/jre/lib/security/java.security \
            $DEPLOYER/user-config/ovd/java7.security.patch
        
        log "OVD >> Successfully installed and patched JDK"
    else
        log "OVD >> Skipped JDK installation"
    fi
}

# create user profile --------------------------------------
#
ovd_create_user_env() {
    if ! [ -d ~/.env ]
    then
        log "OVD >> creating user environment..."

        mkdir -p /var/log/fmw/nodemanager
        mkdir -p $HOME/.creds $HOME/.env $HOME/bin
        cp -f $DEPLOYER/lib/templates/ovd/env/* $HOME/.env
        cp -f $DEPLOYER/lib/templates/ovd/bin/* $HOME/bin
        chmod 0755 ~/bin/*

        echo "source ~/.env/common.env" >>$HOME/.bash_profile
        echo "source ~/.env/ovd.env"    >>$HOME/.bash_profile
    fi
}


# deploy wlst standard functions ------------------------------
#
ovd_wlst_common_functions() {
    for f in $DEPLOYER/lib/wlst/common/*
    do
        if [ -f $WL_HOME/common/wlst/$(basename $f) ]
        then
            log "WLST library $(basename $f) already deployed"
        else
            cp $f $WL_HOME/common/wlst/
            echo "Deployed WLST library $(basename $f)"
        fi
    done
}

# create weblogic nodemanager keyfiles
#
nodemanager_keyfiles() {
    if ! [ -f ~/.creds/nm.key ]
    then
        local _wlst="nmConnect(username='$nodemanager_user',password='$nodemanager_password',host=acGetFQDN(),port=nmPort,domainName=domName,domainDir=domDir,nmType='ssl')
storeUserConfig(userConfigFile=nmUC,userKeyFile=nmUK,nm='true')
y
exit()
"
        echo "${_wlst}" | ${WL_HOME}/common/bin/wlst.sh -loadProperties ~/.env/ovd.prop
    fi
}

# create weblogic domain nodemanager keyfiles
#
domain_keyfiles() {
    local _bp=$DOMAIN_HOME/servers/AdminServer/security/boot.properties

    if ! [ -f $_bp ]
    then
        touch $_bp
        chmod 0640 $_bp
        echo "username=$domain_user"     >> $_bp
        echo "password=$domain_password" >> $_bp
    fi

    if ! [ -f ~/.creds/ovd.key ]
    then

        local _wlst="connect(username='$domain_user',password='$domain_password',url=domUrl)
nmEnroll(domainDir=domDir,nmHome='$WL_HOME/common/nodemanager')
storeUserConfig(userConfigFile=domUC,userKeyFile=domUK,nm='false')
y
exit()
"
        echo "${_wlst}" | ${WL_HOME}/common/bin/wlst.sh -loadProperties ~/.env/ovd.prop
    fi
}

# create new ovd keystore and import entries from external keystore
#   param1: filename of new keystore
#   param2: pathname of source keystore to import from
#
ovd_import_keystore_from() {

  local _new_ks=$INSTANCE_HOME/config/OVD/$INSTANCE_NAME/keystores/$1
  
  if ! [ -f "$_newks" ]
  then
        local _wlst="acConnect();
custom();
cd('oracle.as.management.mbeans.register');
cd('oracle.as.management.mbeans.register:type=component,name=ovd1,instance=$INSTANCE_NAME');
invoke('load',jarray.array([],java.lang.Object),jarray.array([],java.lang.String));
importKeyStore('$INSTANCE_NAME','ovd1','ovd','$1','$domain_password','$2');
exit()
"
        echo "${_wlst}" | ${WL_HOME}/common/bin/wlst.sh -loadProperties ~/.env/ovd.prop
    fi
}



# import ca into emagent truststore
#
ovd_emagent_add_trust() {
    local _wallet=/opt/fmw/services/instances/ovd1/EMAGENT/EMAGENT/sysman/config/monwallet
    local _cert=$HOME/cert1/cert.pem
    
    $ORACLE_COMMON/bin/orapki wallet add -wallet $_wallet -cert $_cert -trusted_cert -pwd welcome
}

# register ovd with weblogic domain 
#
ovd_register_instance() {
    local PWD=$(mktemp)
    echo -n "$domain_password" >$PWD

    $ORACLE_INSTANCE/bin/opmnctl updatecomponentregistration \
      -adminHost ovd.vie.agoracon.at \
      -adminPort 7201 \
      -adminUsername $domain_user \
      -adminPasswordFile $PWD \
      -componentType OVD \
      -componentName ovd1

    rm -f $PWD
}
