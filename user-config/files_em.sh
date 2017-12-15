# 
# Oracle Enterprise Manager Installation
#
export           OEM_BASE=/opt/oem
export            MW_HOME=${OEM_BASE}/fmw
export           WLS_HOME=${MW_HOME}/wlserver_10.3
export            WL_HOME=${MW_HOME}/wlserver_10.3
export           OEM_HOME=${MW_HOME}/oms
export        ORACLE_HOME=${OEM_HOME}

export            EM_INST=${OEM_BASE}/em_inst
export        DOMAIN_NAME=oem_dev
export        DOMAIN_HOME=${EM_INST}/user_projects/domains/${DOMAIN_NAME}
export       WLS_USERNAME=weblogic
export       WLS_PASSWORD=Montag11
export            DB_HOST=oms.vie.agoracon.at
export            DB_PORT=1521
export     DB_SERVICENAME=lunes
export           WLS_PORT=7001

# installation variables
        EM_HOST=oms.vie.agoracon.at
        EM_PORT=7302
        EM_USER=sysman
        EM_PASS=Montag11
 AGENT_REG_PASS=$EM_PASS
    DBS_SYS_PWD=$EM_PASS
 DBS_SYSMAN_PWD=$EM_PASS
 
     EM_VERSION=12.1.0.5.0
     AGENT_HOME=${BASE_MASTER}/core/${EM_VERSION}
    SHARED_INST=${BASE_AGENT}/agent_inst
    MASTER_INST=${BASE_MASTER}/agent_inst
       LOGS_DIR=/var/log/oem

# oracle inventory pointer
   ORAINV=/opt/oracle/oraInventory
ORAINVPTR=/opt/oem/oraInst.loc

# fusion patches to apply
#               OPATCH_DIR=p6880880
#                  PATCHES=( 16736728 16736729 17196811 )
#             OPATCH_CHECK="Prereq \"checkConflictAgainstOHWithDetail\" passed."
#               OPATCH_RSP=${MISC_DIR}/ocm.rsp

# Named Credentials setup
SSH_DEPLOY_HOSTS="ovd.vie.agoracon.at"
#    AGENT_EMCLI=${U_AGENT_HOME}/emcli
