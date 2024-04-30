https://zhuanlan.zhihu.com/p/161533381

## poe lvm

```shell
# LVM（Logical Volume Manager）是一种用于管理磁盘存储的逻辑卷管理器，它提供了灵活的磁盘# 分区和卷管理功能，使您可以更方便地管理磁盘空间和存储卷。以下是一些常见的LVM相关操作和命#令：

# 1. pvcreate：创建物理卷（Physical Volume），将物理磁盘或分区添加到LVM管理中。
pvcreate /dev/sdb1

# 2. vgcreate：创建卷组（Volume Group），将一个或多个物理卷组合成一个逻辑存储池。
vgcreate myvg /dev/sdb1

# 3. lvcreate：创建逻辑卷（Logical Volume），从卷组中划分出一个或多个逻辑卷。
lvcreate -L 10G -n mylv myvg

# 4. lvextend：扩展逻辑卷的大小。
lvextend -L +5G /dev/myvg/mylv

# 5. lvresize：调整逻辑卷的大小。
lvresize -L 15G /dev/myvg/mylv

# 6. lvremove：删除逻辑卷。
lvremove /dev/myvg/mylv

# 7. vgextend：将物理卷添加到现有卷组中。
vgextend myvg /dev/sdc1

# 8. vgreduce：从卷组中删除物理卷。
vgreduce myvg /dev/sdc1

# 9. pvdisplay：显示物理卷的信息。
pvdisplay /dev/sdb1

# 10. vgdisplay：显示卷组的信息。
vgdisplay myvg

# 11. lvdisplay：显示逻辑卷的信息。
lvdisplay /dev/myvg/mylv

```
