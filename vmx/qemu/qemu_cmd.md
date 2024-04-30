https://www.qemu.org/docs/master/


### poe qemu-*

```shell
# qemu-*是一系列与QEMU（Quick Emulator）虚拟化软件相关的命令和工具。QEMU是一个开源的虚拟化软件，它可以
# 模拟多个硬件平台，并提供了用于创建、管理和运行虚拟机的工具和库。

# 以下是一些常见的qemu-*命令和工具：

# 1. qemu-system-*：QEMU系统模拟器命令，用于创建和运行虚拟机。例如，qemu-system-x86_64用于创建和运行x86_64架构的虚拟机。
qemu-system-x86_64 -m 2048 -smp 2 --enable-kvm  -boot d -hda /var/lib/libvirt/images/ubuntu20.04_1.qcow2

qemu-system-x86_64 -m 2048 -enable-kvm /var/lib/libvirt/images/ubuntu20.04_1.qcow2


# 2. qemu-img：QEMU镜像管理工具，用于创建、转换和操作虚拟机磁盘镜像文件。例如，qemu-img create用于创建新的虚拟机磁盘镜像。
qemu-img create -f qcow2 mydisk.qcow2 10G

# 3. qemu-io：QEMU I/O工具，用于测试和调试虚拟机磁盘I/O性能。它可以模拟各种磁盘I/O操作，如读、写、异步操作等。
qemu-io -c "write 0 512" mydisk.qcow2

# 4. qemu-ga：QEMU Guest Agent，用于与虚拟机内部的QEMU代理进行交互。它可以提供虚拟机的状态信息，执行操作和命令等。
qemu-ga shutdown

# 5. qemu-nbd：QEMU网络块设备服务器，用于将虚拟机磁盘镜像文件导出为网络块设备（NBD），以供远程访问和挂载。
qemu-nbd -c /dev/nbd0 mydisk.qcow2

```

### qemu-img info

```shell
qemu-img info /path/to/image.qcow2
image: /path/to/image.qcow2
file format: qcow2
virtual size: 20G (21474836480 bytes)
disk size: 2.5G
cluster_size: 65536
Snapshot list:
ID        TAG                 VM SIZE                DATE       VM CLOCK
1         snapshot1           2.5G (2684354560 bytes) 2021-01-01 00:00:00   00:00:00.000
2         snapshot2           2.0G (2147483648 bytes) 2021-02-01 00:00:00   00:00:00.000

#--------------------------------------------------------------------
# 上述示例输出中包含以下信息：
#
# image：磁盘镜像文件的路径。
# file format：磁盘镜像的格式，例如 qcow2、raw、vmdk 等。
# virtual size：虚拟磁盘的大小，以人类可读的格式和字节表示。
# disk size：磁盘镜像文件的实际大小，以字节表示。
# cluster_size：簇大小，即每个簇的字节数。
# Snapshot list：快照列表，显示每个快照的 ID、标签、虚拟机大小、创建日期和虚拟机时钟信息。

```
