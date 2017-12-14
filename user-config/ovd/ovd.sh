# ovd deployment variables
#
iam_top=/opt/fmw
product=ovd
mw_home=$iam_top/products/$product
ora_home=$mw_home/ovd
s_runjre=$mw_home/jdk

instance_base=/opt/fmw/services/instances
instance_name=ovd1

# oracle inventory
orainv_ptr=/opt/fmw/lcm/oraInst.loc
iam_orainv_ptr=$orainv_ptr
iam_orainv_grp=oinstall
iam_orainv=/opt/fmw/lcm/oraInventory
