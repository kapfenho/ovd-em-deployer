# Config settings for Oracle Enterprise Manager DB installation
#

# environment used by installation
export       MACHINE_NAME=oemapp.dev.vm
export        NM_PORT_IDM=5556
export        NM_PORT_IAM=5557
export          UNIX_USER=oracle

# 
# DB Installation
#
export               BASE=/opt/oracle
export        ORACLE_BASE=${BASE}
export            MW_HOME=${ORACLE_BASE}
export        ORACLE_HOME=${MW_HOME}/product/11.2/db
export        DOMAIN_NAME=oemdb
export            DB_HOST=127.0.0.1
export            DB_PORT=1521
export     DB_SERVICENAME=lunes
            BASHRC_CONFIG=${LIB_DIR}/env/bashrc
           DB_INIT_SCRIPT=${MISC_DIR}/oracle_init.d.sh
              DB_INIT_LOC=/etc/init.d/oracle
            
# oracle inventory pointer
                   ORAINV=${ORACLE_BASE}/oraInventory
                ORAINVPTR=${ORAINV}/oraInst.loc


# set java in $PATH
export          JAVA_HOME=${ORACLE_BASE}/jdk/jrockit-jdk1.6.0_51
export               PATH=${JAVA_HOME}/bin:${PATH}

#
# DB Creation
#
          DB_TEMPLATE_DIR=${TEMPLATE_DIR}/db
           RESP_DB_CREATE=${RESP_DIR}/db_create.rsp
                TNS_ADMIN=${ORACLE_BASE}/network/admin
             TNSNAMES_ORA=${MISC_DIR}/tnsnames.ora
             LISTENER_ORA=${MISC_DIR}/listener.ora
                 LSNR_ORA=${TNS_ADMIN}/listener.ora
               RESP_NETCA=${RESP_DIR}/db_netca.rsp
export       SQLPLUS_HOME=$ORACLE_HOME

# fusion patches to apply
                  PATCHES=( p6880880 16619892 )
             OPATCH_CHECK="Prereq \"checkConflictAgainstOHWithDetail\" passed."
               OPATCH_RSP=${MISC_DIR}/ocm.rsp


