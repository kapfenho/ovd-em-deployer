# installation images location
#
# enterprise manager
#
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

# ovd
#
# s_wls=/mnt/oracle/iam-11.1.2.3/repo/installers/weblogic/wls_generic.jar
 s_wls=/mnt/oracle/weblogic/wls1036_generic.jar
 s_ovd=/mnt/oracle/iam-11.1.1.9
s_java=/mnt/oracle/images/java/java7/server-jre-7u76-linux-x64.tar.gz
# s_java=/mnt/oracle/images/java/java6/jrockit-R28.2.8-p16863120_2828_Linux-x86-64.zip
s_java_dir=jdk1.7.0_76
# s_java_dir=jrockit-jdk1.6.0_51
