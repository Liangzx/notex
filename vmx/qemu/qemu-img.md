# qemu-img

## refs

[qemu-img](https://www.qemu.org/docs/master/tools/qemu-img.html)
[QEMU block drivers reference](https://www.qemu.org/docs/master/system/qemu-block-drivers.html)

## qemu-img info

```shell
qemu-img info /var/lib/libvirt/images/ubuntu20.04.qcow2
image: /var/lib/libvirt/images/ubuntu20.04.qcow2
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

## qemu-img create

```shell
# create [--object OBJECTDEF] [-q] [-f FMT] [-b BACKING_FILE [-F BACKING_FMT]] [-u] [-o OPTIONS] FILENAME [SIZE]

# 创建磁盘
qemu-img create -f qcow2 mydisk.qcow2 1G
```

## qemu-img snapshot

```shell
# snapshot [--object OBJECTDEF] [--image-opts] [-U] [-q] [-l | -a SNAPSHOT | -c SNAPSHOT | -d SNAPSHOT] FILENAME

# 1. 创建
# qemu-img snapshot -c <snapshot_name> <disk_image>
qemu-img snapshot -c snapshot1 /var/lib/libvirt/images/ubuntu20.04.qcow2

# 2. 删除
# qemu-img snapshot -d <snapshot_name> <disk_image>
qemu-img snapshot -d snapshot1 /var/lib/libvirt/images/ubuntu20.04.qcow2

# 3. 列出
# qemu-img snapshot -l <disk_image>
qemu-img snapshot -l /var/lib/libvirt/images/ubuntu20.04.qcow2

# 4. 应用
# qemu-img snapshot -a <snapshot_name> <disk_image>
qemu-img snapshot -a snapshot1 /var/lib/libvirt/images/ubuntu20.04.qcow2

```

## qemu-img bitmap

```shell
# qemu-img info mydisk.qcow2 查看 bitmap 信息
qemu-img bitmap --add mydisk.qcow2 hell_bt1

# 列出位图
qemu-img bitmap list /path/to/disk.qcow2

# 查看特定位图信息
qemu-img bitmap show /path/to/disk.qcow2 --name hotbitmap

# 导出位图数据


```

## qemu-img map

```shell
qemu-img map --output=json /var/lib/evc/lhv/storage/local/204bb8b7-f013-4f43-9bde-7d3db5228805/1b775b02-ba69-4e02-80ff-e51a0c5024cf.img
qemu-img map /var/lib/evc/lhv/storage/local/204bb8b7-f013-4f43-9bde-7d3db5228805/1b775b02-ba69-4e02-80ff-e51a0c5024cf.img -U -f qcow2 --output json | jq -c '[.[] | select((.zero == false) and (.depth <= 0) and (.start >= 0) )]'
```

## qemu-img compare

```shell
qemu-img compare /var/lib/evc/lhv/storage/local/204bb8b7-f013-4f43-9bde-7d3db5228805/1b775b02-ba69-4e02-80ff-e51a0c5024cf.img /var/lib/evc/lhv/storage/local/204bb8b7-f013-4f43-9bde-7d3db5228805/.snap/8fb37e8a-f483-46e5-99da-6ec371a7fd79.snap.img
```
