# device mapper

## 概念

设备映射器（Device Mapper）是 Linux 内核的一个模块，它提供了一种灵活且强大的机制来管理和操作块设备。通过设备映射器，可以创建虚拟的块设备，这些虚拟设备可以对应于一个或多个实际的物理块设备，并且可以通过不同的方式对数据进行映射和转换。这种灵活性使得设备映射器成为实现多种高级存储功能的基础，如逻辑卷管理（LVM）、软件 RAID、加密设备、多路径 I/O 和快照等。

## 设备映射器的工作原理

设备映射器的核心概念是“目标”（target），每个目标定义了如何将输入输出（I/O）请求从虚拟设备重定向到一个或多个底层物理设备。一个设备映射器设备可以包含多个目标，形成一个复杂的映射表。当 I/O 请求到达时，设备映射器会根据映射表中的规则将请求分发给适当的物理设备。

主要特点：

- 抽象层：设备映射器在用户空间和内核空间之间提供了一个抽象层，允许管理员通过简单的命令行工具（如 dmsetup）来配置复杂的存储布局。
- 动态性：可以在不中断服务的情况下添加、修改或删除映射规则，这为在线维护和调整提供了极大的便利。
- 可扩展性：支持多种不同类型的目标，从而能够实现丰富的功能集。例如，线性映射、条带化、镜像、加密、快照等都可以通过特定的目标来实现。

## 设备映射器的应用场景

逻辑卷管理 (LVM): LVM 使用设备映射器来创建和管理逻辑卷。它可以跨越多个物理磁盘，提供灵活的分区方案，并支持在线扩展和收缩卷大小。
软件 RAID：通过设备映射器可以构建软件 RAID 阵列，而无需依赖专用硬件控制器。常见的 RAID 级别包括 RAID 0、RAID 1、RAID 5 等
加密设备：设备映射器结合 dm-crypt 或 LUKS 可以创建加密的磁盘分区或整个磁盘。只有在正确解锁后，才能访问其中的数据。
[多路径 I/O](./multi_io_device.md): 对于高可用性和性能要求高的环境，设备映射器可以帮助配置多路径 I/O，确保即使某些路径失效，仍然可以通过其他路径访问存储设备。
快照: 利用设备映射器可以生成文件系统的即时副本，这对于备份、测试和恢复非常有用。快照可以在不影响原始数据的情况下进行读写操作。
其他高级特性:包括但不限于缓存、压缩、复制等功能，具体取决于所使用的内核版本和支持的目标类型。

## 如何使用设备映射器

虽然大多数情况下你不会直接与设备映射器交互，而是通过更高层次的工具（如 lvm, multipath-tools, cryptsetup 等）间接使用它，但了解基本的命令仍然是有用的。以下是一些常用的命令：

```shell
# 查看所有设备映射器设备
dmsetup ls

# 获取详细信息
dmsetup info <device_name>

# 显示映射表
dmsetup table <device_name>

# 重新加载映射表
dmsetup reload <device_name> --table "<new_table>"

# 激活/停用设备
dmsetup resume <device_name>
dmsetup suspend <device_name>

# 示例：创建一个简单的线性映射
# 假设我们有两个物理磁盘 /dev/sdb 和 /dev/sdc，我们可以使用设备映射器创建一个线性映射，将它们合并成一个更大的虚拟设备。
# 准备工作
# 1. 确认物理磁盘: 确保你有至少两个未被使用的物理磁盘（如 /dev/sdb 和 /dev/sdc），并且这些磁盘没有挂载或正在使用中。
# 2. 安装必要的工具: 确认系统已经安装了 device-mapper 及其相关工具（如 dmsetup）。大多数现代 Linux 发行版默认都包含了这些工具，但如果没有，可以使用包管理器进行安装：
sudo apt-get install dmsetup  # Debian/Ubuntu
sudo yum install device-mapper # CentOS/RHEL

# 创建线性映射设备
# 1. 步骤 1: 获取磁盘大小
sudo blockdev --getsize /dev/sdb
sudo blockdev --getsize /dev/sdc

# 2. 步骤 2: 构建映射表
# 接下来，我们需要构建一个映射表文件，该文件描述了如何将物理磁盘映射到新的虚拟设备。这里我们创建一个名为 linear_table 的文件：
echo "0 $(sudo blockdev --getsize /dev/sdb) linear /dev/sdb 0" > linear_table
echo "$(sudo blockdev --getsize /dev/sdb) $(sudo blockdev --getsize /dev/sdc) linear /dev/sdc 0" >> linear_table
# 这段命令做了两件事：
#   第一行：从偏移量 0 开始，将 /dev/sdb 的所有扇区线性映射到新设备。
#   第二行：从 /dev/sdb 结束的地方继续，将 /dev/sdc 的所有扇区线性映射到新设备。

# 步骤 3: 创建设备映射器设备
sudo dmsetup create mylineardev --table "$(cat linear_table)"
# 如果一切顺利，你应该会在 /dev/mapper/ 目录下看到一个名为 mylineardev 的新设备。

# 步骤 4: 验证新设备
sudo dmsetup info mylineardev
sudo dmsetup table mylineardev
# 此外，还可以使用 lsblk 或 fdisk -l 来查看新设备及其大小。

# 步骤 5: 格式化和挂载（可选）
sudo mkfs.ext4 /dev/mapper/mylineardev
sudo mkdir -p /mnt/mylineardev
sudo mount /dev/mapper/mylineardev /mnt/mylineardev

# 清理与删除
sudo umount /mnt/mylineardev
sudo dmsetup remove mylineardev

# 持久化配置
# 以上步骤仅适用于临时创建线性映射设备。若要实现持久化配置，可能需要编辑 /etc/fstab 或编写启动脚本。

```


## refs
[通义](什么是设备映射器)
