# help text for ovdkey
#

ovdkeyhelp() {
  echo "
  Syntax: ${0} command [flags] [-h] [-H host] [-A]
 
  Manage OVD keystores.

  Commands
    list      list the currently used keystore content
    diff      show differences between OVD and reference keystore
    help      show this help

  Generell Parameters
    -h        help
    -t        OVD trust keystore (ovdtrust)
    -i        OVD identity keystore (ovdident)
    -T        reference trust keystore (reftrust)
    -I        reference identity keystore (refident)

  Parameters
    -O Oracle home

"
  echo
}
# ---------------------------------------------------
help_list() {
  echo "
  Syntax: ${0} list [ -v ] { all | ovdident | ovdtrust | reftrust | refident }

    ${0} list -v all

  List the content of the specified keystore

  Parameter:
    -v   list verbose

  "
}
# ---------------------------------------------------
help_provision() {
  echo "
  Syntax: ${0} provision [-f workflow_file]

  Run full provisioning defined in workflow file.

  Parameter:
    -f   workflow_file  Defaults: user-config/workflow

  "
}
