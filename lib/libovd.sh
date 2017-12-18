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

        mkdir -p $HOME/.env
        cp -f $DEPLOYER/lib/templates/ovd/env/* $HOME/.env
        mkdir -p $HOME/bin
        # cp -f $DEPLOYER/lib/templates/ovd/bin/* $HOME/bin
        # chmod 0755 ~/bin/*

        echo "source ~/.env/common.env" >>$HOME/.bash_profile
        echo "source ~/.env/ovd.env"    >>$HOME/.bash_profile
    fi
}

