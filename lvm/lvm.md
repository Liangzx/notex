https://zhuanlan.zhihu.com/p/161533381

## poe lvm

```shell
# LVM 的基本概念
# LVM 引入了三个主要的概念：物理卷（Physical Volumes, PV）、卷组（Volume Groups, VG）和逻辑卷（Logical Volumes, LV）。
# 这三个层次共同构成了 LVM 的架构。

# 1. 物理卷 (PV)
# 定义：物理卷是指实际的物理存储设备，如硬盘、SSD 或 RAID 阵列。它们是 LVM 的基础构建块。
# 操作：你可以将一个或多个物理设备初始化为物理卷，并将其加入到卷组中
# 初始化一个物理卷
pvcreate /dev/sdb

# 2. 卷组 (VG)
# 定义：卷组是由一个或多个物理卷组成的集合。卷组提供了连续的存储空间池，可以在其中创建逻辑卷。
# 操作：一旦创建了物理卷，就可以用它们来创建一个或多个卷组。
# 创建一个卷组
vgcreate my_volume_group /dev/sdb

# 3. 逻辑卷 (LV)
# 定义：逻辑卷是从卷组中分配出来的虚拟磁盘。逻辑卷可以像普通磁盘分区一样格式化并挂载使用。
# 操作：你可以在卷组内创建任意数量的逻辑卷，并根据需要调整其大小。
# 创建一个逻辑卷
lvcreate -L 10G -n my_logical_volume my_volume_group

# 示例---------------
# 1. 初始化物理卷
pvcreate /dev/sdb /dev/sdc
# 2. 创建卷组
vgcreate my_vg /dev/sdb /dev/sdc
# 3. 创建逻辑卷
lvcreate -L 50G -n my_lv my_vg
# 4. 格式化并挂载逻辑卷
mkfs.ext4 /dev/my_vg/my_lv
mount /dev/my_vg/my_lv /mnt/my_mount_point

# 示例---------------end------


# -----------------------ai-end-----------
# LVM（Logical Volume Manager）是一种用于管理磁盘存储的逻辑卷管理器，它提供了灵活的磁盘
# 分区和卷管理功能，使您可以更方便地管理磁盘空间和存储卷。以下是一些常见的LVM相关操作和命令：

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
