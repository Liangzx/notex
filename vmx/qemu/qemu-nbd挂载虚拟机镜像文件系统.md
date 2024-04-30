https://blog.csdn.net/cclethe/article/details/107093834

## 基本原理

nbd（网络块设备: Network Block Device），利用qemu-nbd将qemu虚拟机镜像挂载到Linux上。

### 一般步骤

```shell
一般步骤
# 1. 加载 nbd 驱动(sudo modprobe nbd)
# 查看有没有加载nbd模块lsmod |grep nbd
# 加载nbd模块sudo modprobe nbd max_part=16
# 2. 连接 qemu-nbd(sudo qemu-nbd -c nbd设备路径 虚拟机镜像路径)
# 查看分区: sudo fdisk -l nbd设备，可能虚拟机不止一个分区（一般还会有一个boot分区）
# 3. 挂载(sudo mount nbd分区 挂载路径)
# 4. 解挂(sudo qemu-nbd -d nbd分区)。

```

### 虚机文件系统为LVM

```shell
# 连接镜像
qemu-nbd -f qcow2 -c /dev/yournbddev yourimg
# 更新lvm分区
pvscan --cache
vgscan
vgchange -a y
# 挂载lvm分区
mount /dev/vgname/lvname /your/mount/point
# 卸载分区
umount /your/mount/point
vgchange -an centos
# 断开nbd连接
qemu-nbd -d /dev/yournbddev
pvscan --cache
```

### 虚机文件系统为非LVM

```shell
# 连接镜像
qemu-nbd -f qcow2 -c /dev/yournbddev yourimg

# 查看新增文件系统结构
lsblk -f

# 挂载分区 -- 其中pn代表你要挂载的时镜像里的分区
mount /dev/[yournbddev][pn] /your/mount/point

# 卸载分区
umount /your/mount/point

# 断开nbd连接
qemu-nbd -d /dev/yournbddev

```

### 虚机文件系统为ntfs

```shell
# 连接镜像
qemu-nbd -f qcow2 -c /dev/yournbddev yourimg

lsblk -f #查看新增文件系统结构

# 挂载分区
mount -t ntfs-3g /dev/[yournbddev][pn] /your/mount/point	# 其中pn代表你要挂载的时镜像里的分区n

# 卸载分区
umount /your/mount/point

# 断开nbd连接
qemu-nbd -d /dev/yournbddev
```

### 注意

```text
1. 一般如果虚机在运行中突然断电关机（比如直接杀死qemu进程或者用virsh destroy命令关闭），此时虚机文件系统可能损坏，这时候直接mount一般会出错，建议用-o ro,norecovery选项挂载
2. 在卸载过程中需要考虑是否有进程正在占用文件，一般用fuser -k
3. 注意mount和umount命令的用法
```
