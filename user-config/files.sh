# Common config settings for Oracle Enterprise Manager installation
# 

# scripts location
                     BASE=/vagrant
              MNT_SCRIPTS=${BASE}/lib
                  SYS_DIR=${BASE}/sys/redhat
                  LIB_DIR=${BASE}/lib
             TEMPLATE_DIR=${LIB_DIR}/templates
                 RESP_DIR=${LIB_DIR}/resp 

                 MISC_DIR=${LIB_DIR}/misc
                 INIT_DIR=${LIB_DIR}/init.d
                CERTS_DIR=${LIB_DIR}/certs

                  RESP_DB=${RESP_DIR}/db_install.rsp
           RESP_ORAINVPTR=${TEMPLATE_DIR}/oraInst.loc
                JDK_PATCH=${MISC_DIR}/jdk.patch
                    
                  ENV_DIR=${LIB_DIR}/env 
                  DBS_ENV=${LIB_DIR}/env/dbs_profile.sh
                  OEM_ENV=${LIB_DIR}/env/em_profile.sh
                AGENT_ENV=${LIB_DIR}/env/idm_profile.sh
              FEDORA_EPEL=${MISC_DIR}/epel-release-6-8.noarch.rpm
                  LOGFILE=log/install.log
                   XAVIEW=/opt/oracle/product/11.2/db/rdbms/admin/xaview.sql

# images location
                MNT_IMAGES=/mnt/oracle
               IMAGE_JAVA=${MNT_IMAGES}/images/java/java6/jrockit-R28.2.8-p16863120_2828_Linux-x86-64.zip
                 IMAGE_DB=${MNT_IMAGES}/database-ee-11.2.0.4/p13390677_112040_Linux-x86-64
                IMAGE_OEM=${MNT_IMAGES}/em-12.1.0.5
                PATCH_DIR=${MNT_IMAGES}/patches
                 MNT_TEST=${MNT_IMAGES}/README.markdown

# machine information
              GROUPS_UNIX=( oinstall oem oemagent dba )
                 USER_ORA=oracle
                 USER_OEM=oem
               USER_AGENT=oemagent
             U_AGENT_HOME=/home/oemagent
                 BASE_DBS=/opt/oracle
                 BASE_OEM=/opt/oem
               BASE_AGENT=/opt/oemagent
               MNT_MASTER=${BASE_AGENT}/master
              BASE_MASTER=${MNT_MASTER}/agent


