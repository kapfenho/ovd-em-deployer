# functions for OVD keystore managament
#

ADMINSRV_HOST="ovd.vie.agoracon.at"
ADMINSRV_PORT=7201
ADMIN_USER="weblogic"
ADMIN_PASS="Montag11"

# INSTANCE_NAME
REF_TRUST=/vagrant/local/pki/trust.jks
REF_TRUSTPASS="Montag11"
REF_IDENT=/vagrant/local/pki/ident.jks
REF_IDENTPASS="Montag11"
REF_IDENTALIAS="ovd.vie.agoracon.at"

OVD_KS_DIR=$INSTANCE_HOME/config/OVD/$INSTANCE_NAME/keystores
OVD_TRUST="$OVD_KS_DIR/keys.jks"
OVD_TRUSTPASS="Montag11"
OVD_IDENT="$OVD_KS_DIR/keys.jks"
OVD_IDENTPASS="Montag11"

BACKUP_DIR="$HOME/backup"

# list keystore
# param1: either all, ovdtrust, ovdident, reftrust, refident
list_keystore()
{
    local ks=""
    local kspass=""

    case $1 in
        ovdtrust)   ks="${OVD_TRUST}" ; kspass="${OVD_TRUSTPASS}" ;;
        ovdident)   ks="${OVD_IDENT}" ; kspass="${OVD_IDENTPASS}" ;;
        reftrust)   ks="${REF_TRUST}" ; kspass="${REF_TRUSTPASS}" ;;
        refident)   ks="${REF_IDENT}" ; kspass="${REF_IDENTPASS}" ;;
        *)          error "Keystore $1 unknown!" ;;
    esac

    keytool -list -keystore "$ks" -storepass "$kspass" ${opt_v:+"-v"}
}

# add service certificate to emagent
#
emagent_add_cert()
{
  local pem=$(mktemp)
  local wallet=$INSTANCE_HOME/EMAGENT/EMAGENT/sysman/config/monwallet

  set -x
  keytool -exportcert -keystore $REF_IDENT -storepass $REF_IDENTPASS \
      -alias $REF_IDENTALIAS -rfc -file $pem

  # $ORACLE_COMMON/bin/orapki wallet add -wallet $wallet -cert $pem \
  #     -trusted_cert -pwd welcome

  set +x
  rm -f $pem
}

# add new keystores to ovd and configure ovd instance to use them
#
update_keystore()
{
  local dtm="$(date '+%Y%m%d-%H%M%S')"
  local ovdprop=$(mktemp)
  OVD_TRUST_NEW="trust-$dtm.jks"
  OVD_IDENT_NEW="ident-$dtm.jks"

  # import and set new keystores
  #
  echo "SSLEnabled=true"            >$ovdprop
  echo "AuthenticationType=Server" >>$ovdprop
  echo "KeyStore=$OVD_IDENT_NEW"   >>$ovdprop
  echo "TrustStore=$OVD_TRUST_NEW" >>$ovdprop

  local _wlst="acConnect()
importKeyStore('$INSTANCE_NAME','ovd1','ovd','$OVD_TRUST_NEW','$OVD_TRUSTPASS','$REF_TRUST')
importKeyStore('$INSTANCE_NAME','ovd1','ovd','$OVD_IDENT_NEW','$OVD_IDENTPASS','$REF_IDENT')
configureSSL('$INSTANCE_NAME','ovd1','ovd','LDAP SSL Endpoint','$ovdprop')
configureSSL('$INSTANCE_NAME','ovd1','ovd','Admin Gateway','$ovdprop')
exit()
"

  echo "${_wlst}"

  echo "${_wlst}" | ${ORACLE_COMMON}/common/bin/wlst.sh -loadProperties $HOME/.env/ovd.prop

  rm -f $ovdprop

  stop-ovd
  start-ovd
}

# update component registration
#
update_component_registration()
{
  pwd=$(mktemp)
  echo -n "$ADMIN_PASS" >$pwd
  
  set -x
  $INSTANCE_HOME/bin/opmnctl updatecomponentregistration \
      -adminHost $ADMINSRV_HOST \
      -adminPort $ADMINSRV_PORT \
      -adminUsername $ADMIN_USER \
      -adminPasswordFile $pwd \
      -componentType OVD \
      -componentName ovd1
  set +x
  
  rm -f $pwd
}
