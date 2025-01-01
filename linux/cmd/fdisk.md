# fdisk

## 创建分区

```shell
# 1. 列出当前磁盘信息
lsblk

# 2. 创建分区表
sudo fdisk /dev/vdd
# 2.1 输入 o 来创建一个新的空分区表 2.2 输入 w 保存更改并退出 fdisk

# 3. 创建新分区 -n
fdisk /dev/vdd
# 3.1 选择分区类型，例如主分区（p） 输入 w 保存更改并退出 fdisk

# 4. 格式化分区
sudo mkfs.ext4 /dev/vdd1

# 5. 创建挂载点
sudo mkdir /mnt/new_partition

# 6. 临时挂载分区
sudo mount /dev/vdb1 /mnt/new_partition

# 7. 永久挂载，编辑 /etc/fstab 文件，添加条目
/dev/vdb1 /mnt/new_partition ext4 defaults 0 2

# 8. 测试挂载， mount -a 命令来尝试挂载所有在 /etc/fstab 文件中定义的分区
mount -a

# https://www.cnblogs.com/renshengdezheli/p/13941563.html
```
