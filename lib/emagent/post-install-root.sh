#!/bin/bash

# Deployment script for Oracle Enterprise Manager Master Agent root scripts
# 
# This procedure can be rerun after an error correction. In the next run 
#+the script will skip already executed steps.
#+All tasks are executed under the defined user account.
#
# Installation files

_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${_DIR}/config/files.sh
source ${_DIR}/config/files_em.sh

# Execute Agent post instlal root script
#
run_agent_root() {
  echo "-- Executing ${BASE_MASTER}/core/${EM_VERSION}/root.sh"
  # Change EM_VERSION if the agent is not the same version as OMS
  ${BASE_MASTER}/core/${EM_VERSION}/root.sh
  echo "-- root.sh completed"
}

# Execute inventory root script
# It is anticipated that the OEM Master Agent is the first (and only)
# Oracle install on the machine, so the inventory script runs always
run_inv_root() {
  echo "-- Executing ${U_AGNET_HOME}/oraInventory/orainstRoot.sh"
  ${U_AGENT_HOME}/oraInventory/orainstRoot.sh
  echo "-- orainsRoot.sh completed"
}


############## start execution #################
#

# Execute inventory script only if first Oracle product on host
[[ -f /etc/oraInst.loc ]] || run_inv_root

# The agent root script moves sbin/<binary>.new to sbin/binary
# If the files have not been moved by the script, run script
[[ -f ${BASE_MASTER}/sbin ]] || run_agent_root

# Make sure the agent doesn't start at next boot
GC_STARTUP=/etc/init.d/gcstartup
[[ ! -f ${GC_STARTUP} ]] || /bin/rm ${GC_STARTUP}

exit 0
