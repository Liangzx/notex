# nbd

## nbd 与 nbd kit 使用上的区别

NBD（Network Block Device）和 NBD Kit 在使用上的区别主要体现在配置复杂度、灵活性、功能扩展性以及适用场景等方面。以下是它们在实际使用中的关键差异：

配置复杂度

```text
NBD：
简单直接：NBD 的配置相对简单，适合快速设置基本的网络块设备服务
通常只需要指定磁盘或文件路径、监听端口等基本信息。
命令行工具：通过 nbd-server 和 nbd-client 命令行工具进行操作，参数
少，易于上手。

NBD Kit：
更复杂的配置：NBD Kit 提供了更多的配置选项，包括插件选择、过滤器添加、性能优化参数等，因此配置过程可能更为复杂。
脚本与编程接口：支持 Python 等高级语言编写的插件，允许用户编写自定义逻辑来处理数据源，这需要一定的编程知识。
```

灵活性与功能扩展性

```text
NBD：
固定模式：主要用于导出整个磁盘或文件作为 NBD 设备，行为较为固定，不支持复杂的自定义逻辑。
有限的功能：提供的功能较为基础，主要用于简单的磁盘共享需求。

NBD Kit：
高度可定制：支持多种插件类型（如 file, qcow2, python 等），允许开发者根据需要定制行为，甚至可以编写自己的插件来处理不同格式的数据源。
过滤器与预处理：可以在数据传输过程中添加过滤器（如压缩、加密等），对数据流进行预处理，提高性能或增强安全性。
```

性能优化与安全特性

```text
NBD：
基本性能：提供了基本的性能水平，但没有专门针对性能的优化特性。
安全性：传统上不包含加密传输等安全特性，依赖于底层网络的安全措施。

NBD Kit：
性能优化：内置缓存机制、多线程处理等性能优化措施，能够更好地应对高负载情况。
安全性：支持 TLS/SSL 加密，确保在网络上传输的数据是安全的。
```

实际操作示例

```shell
# 启动 NBD 服务器
dd if=/dev/urandom of=/data/nbd/nbd-image bs=1M count=128
nbd-server 10809 /data/nbd/nbd-image

# new style

# 客户端连接并映射为本地设备
modprobe nbd max_part=8
nbd-client 172.20.30.176 10809 /dev/nbd0

# 断开 client
sudo nbd-client -d /dev/nbd0

#------------------
# 启动 NBD Kit 服务器，使用 qcow2 插件并添加 gzip 过滤器
nbdkit --filter=gzip qcow2 /path/to/disk.qcow2

# 客户端连接方式相同
modprobe nbd max_part=8
nbd-client 172.20.30.176 10809 /dev/nbd0

# 示例：提供两个文件作为 NBD 设备

# 创建 qcow2 文件
qemu-img create -f qcow2 -o preallocation=metadata /data/nbd/disk1.qcow2 10G
qemu-img create -f qcow2 -o preallocation=metadata /data/nbd/disk2.qcow2 5G

# 第一个 nbdkit 实例，监听端口 10809
nbdkit -v -e=disk1  --port=10809 file /data/nbd/disk1.qcow2&

# 第二个 nbdkit 实例，监听端口 10810
nbdkit -v -e=disk2  --port=10810 file /data/nbd/disk2.qcow2&

```

## nbd 实现文件级备份恢复

```shell
# 连接 nbdkit 暴露的设备
modprobe nbd max_part=8
nbd-client 172.20.30.176 10809 /dev/nbd0

# 查看分区
sudo fdisk -l /dev/nbd0

# 查看文件系统
sudo blkid /dev/nbd0p1

# 只读凡是挂载（如果nbdkit暴露的时候是只读的话，这里不用只读挂载不了）
sudo mount -o ro /dev/nbd0p1 /data/nbd1

```


/etc/nbd-server/config

```text
# This is a comment
[generic]
    # The [generic] section is required, even if nothing is specified
    # there.
    # When either of these options are specified, nbd-server drops
    # privileges to the given user and group after opening ports, but
    # _before_ opening files.
    user = nbd
    group = nbd
#[export1]
#    exportname = /export/nbd/export1-file
#    authfile = /export/nbd/export1-authfile
#    timeout = 30
#    filesize = 10000000
#    readonly = false
#    multifile = false
#    copyonwrite = false
#    prerun = dd if=/dev/zero of=%s bs=1k count=500
#    postrun = rm -f %s
[otherexport]
    exportname = /data/nbd/nbd-image
    # The other options are all optional
```


## refs

[proto](https://sourceforge.net/p/nbd/code/ci/master/tree/doc/proto.md)
[nbd](https://github.com/NetworkBlockDevice/nbd)
[nbdkit](https://gitlab.com/nbdkit/libnbd)
