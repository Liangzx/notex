# zfs

## install

```shell
sudo apt update
sudo apt install zfsutils-linux

# Created symlink /etc/systemd/system/zfs-import.target.wants/zfs-import-cache.service → /lib/systemd/system/zfs-import-cache.service.
# Created symlink /etc/systemd/system/zfs-mount.service.wants/zfs-import.target → /lib/systemd/system/zfs-import.target.
# Created symlink /etc/systemd/system/zfs.target.wants/zfs-import.target → /lib/systemd/system/zfs-import.target.
# Created symlink /etc/systemd/system/zfs-mount.service.wants/zfs-load-module.service → /lib/systemd/system/zfs-load-module.service.
# Created symlink /etc/systemd/system/zfs.target.wants/zfs-load-module.service → /lib/systemd/system/zfs-load-module.service.
# Created symlink /etc/systemd/system/zfs-share.service.wants/zfs-mount.service → /lib/systemd/system/zfs-mount.service.
# Created symlink /etc/systemd/system/zfs.target.wants/zfs-mount.service → /lib/systemd/system/zfs-mount.service.
# Created symlink /etc/systemd/system/zfs.target.wants/zfs-share.service → /lib/systemd/system/zfs-share.service.
# Created symlink /etc/systemd/system/multi-user.target.wants/zfs.target → /lib/systemd/system/zfs.target.

```

## 常用命令

```shell
# ZFS（Zettabyte File System）是由 Sun Microsystems 开发的一个结合了文件系统和卷管理器功能的高级存储系统。
# 它最初设计用于 Solaris 操作系统，但后来也被移植到其他平台，如 FreeBSD 和 Linux。
# ZFS 提供了许多先进特性，包括数据完整性校验、快照、克隆、压缩、去重等，使其成为高性能和高可靠性的存储解决方案。

# ZFS 的核心概念
# 1. 池（Pool）
# 定义：ZFS 中的数据存储在称为“池”的逻辑容器中。一个池可以包含多个磁盘或分区，并支持不同的 RAID 级别（如镜像、条带化、RAID-Z 等）。
# 池是创建文件系统的基础。
# 命令：
# 创建池
zpool create <pool_name> <device(s)>
# 查看池状态
zpool status

# 2. 文件系统（Filesystem
# 定义：每个 ZFS 池都可以划分为多个独立的文件系统。这些文件系统继承了池的属性，但也可以单独配置特定选项（如压缩、配额等）。
# 命令：
# 创建文件系统：
zfs create <pool_name>/<filesystem_name>
# 列出所有文件系统：
zfs list

# 3. 快照（Snapshot）
# 定义：快照是文件系统某一时刻的状态副本，可以用来恢复数据或进行备份。快照对性能影响极小，因为它们只记录自上次快照以来发生变化的数据块。
# 命令：
# 创建快照：
zfs snapshot <pool_name>/<filesystem_name>@<snapshot_name>
# 列出快照：
zfs list -t snapshot
# 回滚到快照：
zfs rollback <pool_name>/<filesystem_name>@<snapshot_name>

# 4. 克隆（Clone）
# 定义：克隆是从现有快照派生出来的可写副本。与快照不同，克隆是一个完整的文件系统，可以直接挂载和使用。
# 命令：
# 创建克隆：
zfs clone <pool_name>/<filesystem_name>@<snapshot_name> <pool_name>/<clone_name>

# 5. 卷（Volume）
# 定义：ZFS 卷类似于传统意义上的块设备，可以在上面创建文件系统或其他类型的存储结构。卷通常用于需要原始块访问的应用程序（如数据库）。
# 命令：
# 创建卷：zfs create -V <size> <pool_name>/<volume_name>

# 6. 属性（Properties）
# 定义：ZFS 文件系统和卷具有许多可配置的属性，例如压缩、加密、配额、预留空间等。可以通过 zfs get 和 zfs set 命令来查看和修改这些属性。
# 命令：
# 查看属性：
zfs get all <pool_name>/<filesystem_name>
# 设置属性：
zfs set <property>=<value> <pool_name>/<filesystem_name>

# [克隆](https://docs.oracle.com/cd/E56344_01/html/E53918/gbcxz.html#scrolltoc): 其初始内容与快照内容相同的文件系统。
# 数据集: 以下 ZFS 组件的通用名称： 克隆、文件系统、快照和卷。数据集使用以下格式进行标识：pool/path[@snapshot]

# ZFS 使用示例-----------

# 创建 ZFS 池和文件系统
# 创建名为 'my_pool' 的 ZFS 池，包含两个磁盘 sdb 和 sdc
zpool create my_pool /dev/sdb /dev/sdc
# 在 'my_pool' 上创建名为 'data' 的文件系统
zfs create my_pool/data
# 设置文件系统的压缩属性为 lz4
zfs set compression=lz4 my_pool/data

# 创建和管理快照
# 创建名为 'backup_01' 的快照
zfs snapshot my_pool/data@backup_01
# 列出所有快照
zfs list -t snapshot
# 回滚到名为 'backup_01' 的快照
zfs rollback my_pool/data@backup_01

# 创建和管理克隆
# 从快照 'backup_01' 创建名为 'restored_data' 的克隆
zfs clone my_pool/data@backup_01 my_pool/restored_data
# 列出所有文件系统（包括克隆）
zfs list

# 创建 ZFS 卷
# 创建大小为 10GB 的卷 'my_volume'
zfs create -V 10G my_pool/my_volume
# 显示卷信息
zfs list my_pool/my_volume
# ZFS 使用示例-----------end-------

# 实践
# 安装 zfs
# 更新包列表并安装必要的依赖项
sudo apt-get update
sudo apt-get install software-properties-common
# 添加 ZFS 官方 PPA（如果你需要最新版本）
sudo add-apt-repository ppa:zfs-native/stable
# 更新包列表并安装 ZFS
sudo apt-get update
sudo apt-get install zfs-dkms zfsutils-linux
# 加载 ZFS 模块
sudo modprobe zfs
# 验证安装是否成功
zpool status

# 创建 ZFS 池和文件系统
zpool create my_pool /dev/vdb
zfs create my_pool/data

# 创建文件
cd my_pool/data
echo hello > hello.txt

# [创建和管理快照](https://docs.oracle.com/cd/E56344_01/html/E53918/gbcya.html#ZFSADMINgbion)
# 创建名为 'backup_01' 的快照
zfs snapshot my_pool/data@backup_01
echo world > hello.txt
# 列出所有快照
zfs list -t snapshot
# 查看 .zfs/snapshot 目录内容(ls -lsat 看不到.zfs)
ls -la .zfs/snapshot
# 回滚到名为 'backup_01' 的快照
zfs rollback my_pool/data@backup_01
# 销毁快照
zfs destroy my_pool/data@backup_01

# 创建和管理克隆
# 从快照 'backup_01' 创建名为 'restored_data' 的克隆
zfs clone my_pool/data@backup_01 my_pool/restored_data
# 销毁克隆
zfs destroy my_pool/restored_data
# 列出所有文件系统（包括克隆）
zfs list

# 创建和管理 checkpoint
zpool checkpoint my_pool
zpool list my_pool
zfs destroy -r my_pool/data
zpool export my_pool
zpool import --rewind-to-checkpoint my_pool

```

## refs

[ZFS Daily Tips (1) - readonly属性](https://zhuanlan.zhihu.com/p/74933361)
[ZFS Daily Tips (3) - snapshot & checkpoint](https://zhuanlan.zhihu.com/p/75755509)
[ZFS Daily Tips (4) - compress属性](https://zhuanlan.zhihu.com/p/75809553)
[Oracle Solaris ZFS 管理指南](https://docs.oracle.com/cd/E24847_01/html/819-7065/index.html)
[Oracle Solaris ZFS 文件系统（介绍）](https://docs.oracle.com/cd/E56344_01/html/E53918/zfsover-1.html)
[OpenZFS Documentation](https://openzfs.github.io/openzfs-docs/index.html)
[OpenZFS wiki](https://openzfs.org/wiki/Main_Page)
[OpenZFS](https://github.com/openzfs/zfs)
[如何用NFS共享ZFS文件系统——详细教程](https://juejin.cn/post/7088526899239976996)
[ZFS管理手册：第五章ZPool的导入和导出](https://blog.csdn.net/kyle__shaw/article/details/128212875)
