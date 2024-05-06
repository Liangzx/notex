# qemu-nbd

```shell
# 加载 nbd 模块
sudo modprobe nbd

# qcow2 文件映射为块设备
sudo qemu-nbd -c /dev/nbd0 mydisk.qcow2

# # 暴露 bitmap ?
# sudo qemu-nbd -c /dev/nbd0 -B hell_bt1 /var/lib/libvirt/images/ubuntu20.04.qcow2

# 创建分区并保存更改
sudo fdisk /dev/nbd0

# 创建系统
sudo mkfs.ext4 /dev/nbd0

# 创建挂在目录
sudo mkdir /data

# 挂载
sudo mount /dev/nbd0 /data

# 取消挂载
umount /data/

# 取消映射
sudo qemu-nbd -d /dev/nbd0

```
