# 扩展卷

```shell
# 创建新分区
sudo fdisk /dev/vda
# 按照上述步骤创建分区并保存

# 刷新分区表
sudo partprobe /dev/vda

# 创建物理卷
sudo pvcreate /dev/vda4

# 扩展卷组
sudo vgextend ubuntu-vg /dev/vda4

# 扩展逻辑卷
sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv

# 扩展文件系统
sudo resize2fs /dev/ubuntu-vg/ubuntu-lv
# 或者
sudo xfs_growfs /
```
