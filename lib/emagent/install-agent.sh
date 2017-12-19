#!/bin/bash

# Deployment script for Oracle Enterprise Manager Master Agent
# 
# This procedure can be rerun after an error correction. In the next run 
#+the script will skip already executed steps.
#+All tasks are executed under the defined user account.
#
# Installation files

_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${_DIR}/config/files.sh
source ${_DIR}/config/files_em.sh

# Print master agent mount message
#
master_mount_msg(){
  echo "Error: agent master share not mounted at ${MNT_MASTER}"
  echo 
  echo "Sample mount:"
  echo "\$ mkdir -p ${MNT_MASTER}; chown oemagent:oinstall ${MNT_MASTER}; chmod 0777 ${MNT_MASTER}"
  echo "\$ mount -t nfs -o proto=tcp,port=2049 kapfenho-dev.at-work.local:/export/oemagent1 ${MNT_MASTER}"
  echo

}

# Download and execute AgentPull.sh to install and configure the agent
agent_pull() {
  OLD_DIR=$(pwd)
  cd /tmp
  
  # Download the script.
  curl "https://${EM_HOST}:${EM_PORT}/em/install/getAgentImage" --insecure -o AgentPull.sh
  chmod u+x AgentPull.sh

  # Download, install and configure the agent.
  #./AgentPull.sh LOGIN_USER=${EM_USER} LOGIN_PASSWORD=${EM_PASS} PLATFORM="Linux x86-64" AGENT_REGISTRATION_PASSWORD=${AGENT_REG_PASS} AGENT_BASE_DIR=${BASE_MASTER} b_startAgent=FALSE
  ./AgentPull.sh AGENT_BASE_DIR=${BASE_MASTER} RSPFILE_LOC=${RESP_DIR}/master_agent.rsp b_startAgent=FALSE

  # Create plugin list (required only for master)
  ${AGENT_HOME}/perl/bin/perl ${AGENT_HOME}/sysman/install/create_plugin_list.pl -instancehome ${MASTER_INST} 
  cd "${OLD_DIR}"
}

############### start execution #####################
#

[[ -d ${MNT_MASTER} ]] || { master_mount_msg ; exit 100; }

[[ -d ${BASE_MASTER}/agent_inst ]] || agent_pull

exit $?

