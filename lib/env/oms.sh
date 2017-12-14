# Oracle OMS environment

export MIDDLEWARE_HOME=/opt/oem/fmw
export MW_HOME=${MIDDLEWARE_HOME}
export ORACLE_HOME=${MIDDLEWARE_HOME}/oms
export WL_HOME=${MIDDLEWARE_HOME}/wlserver_10.3
export INSTANCE_HOME=/opt/oem/em_inst
export DOMAIN_HOME=${INSTANCE_HOME}/user_projects/domains/oem_dev
export ORACLE_COMMON=${MIDDLEWARE_HOME}/oracle_common

PATH_OLD=${PATH}
PATH=${ORACLE_HOME}/bin:${ORACLE_HOME}/OPatch:${PATH}:${ORACLE_COMMON}/bin

export PATH
export PATH_OLD

export CURRENT_ENV="OMS"
