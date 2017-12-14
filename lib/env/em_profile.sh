# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# User specific aliases and functions
if [ -f ${HOME}/.bash_aliases ]; then
  . ${HOME}/.bash_aliases
fi


## EM Environment 12.1.0.3

export JAVA_HOME=/opt/oem/fmw/jdk16/jdk
export PATH=${JAVA_HOME}/bin:$PATH

export PS1='\h:\W [${CURRENT_ENV}] '

alias OMS=". ~/.env/oms.sh"
alias EMCLI=". ~/.env/emcli.sh"
#alias AGENT=". ~/.env/agent.sh"

alias u="echo Environments: OMS, EMCLI"

#cat ${HOME}/.welcome.md
