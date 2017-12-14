# .bash_profile
# vim: set ft=sh :
#
# TODO: check if everything is there
#

# Get the aliases and functions
#if [ -f ~/.bashrc ]; then
#        . ~/.bashrc
#fi

# User specific environment and startup programs

export         NLS_LANG=AMERICAN_AMERICA.AL32UTF8
export         LOG_HOME=/appl/logs
export      ORACLE_BASE=/appl/dbs
export      ORACLE_HOME=${ORACLE_BASE}/product/11.2/db
export          DB_HOST=127.0.0.1
export          DB_PORT=1521
export   DB_SERVICENAME=lunes
export       ORACLE_SID=lunes
export        TNS_ADMIN=${ORACLE_BASE}/network/admin
export  LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${ORACLE_HOME}/lib
export             PATH=${PATH}:${ORACLE_HOME}/bin
export        JAVA_HOME=/appl/dbs/jdk/jrockit-jdk1.6.0_51

#  awesome aliases, your life will be good...
alias      oh='cd ${ORACLE_HOME}'
alias      dh='cd ${DOMAIN_HOME}'
alias      dl='cd ${LOG_HOME}/${DOMAIN_NAME}'


# Welcome.md
echo "### Oracle environment set ###" 
#echo "--- SQLPATH=${SQLPATH}" 
echo "--- TNS_ADMIN=${TNS_ADMIN}" 
echo "--- NLS_LANG=${NLS_LANG}" 
echo "--- LD_LIBRARY_PATH=${LD_LIBRARY_PATH}" 
echo "--- PATH=${PATH}"

