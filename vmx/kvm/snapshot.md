# snapshot

## QEMU/KVM 快照

### 磁盘快照

#### 根据快照信息的保存位置

- 内置快照：快照数据和base磁盘数据放在一个qcow2文件中
- 外置快照: 快照数据存放在单独的qcow2文件

#### 根据虚拟机状态

- 关机态快照：关机时执行
- 运行态快照：需要在虚拟机中安装agent，能够将缓存中的数据写入磁盘，保证数据的一致性

### 内存快照

对虚拟机的内存/设备信息进行保存。该机制同时用于休眠恢复，迁移等场景。
主要使用virsh save（qemu migrate to file）实现。
只能对运行态的虚拟机进行。

### 检查点(checkpoint)快照

同时保存虚拟机的磁盘快照和内存快照。用于将虚拟机恢复到某个时间点。可以保证数据的一致性。

## 创建快照

### 内置快照

#### 利用qemu-img

```shell
qemu-img snapshot -c snapshot01 test.qcow2  //创建
qemu-img snapshot -l test.qcow2             //查看
qemu-img snapshot -a snapshot01 test.qcow2  //revert到快照点
qemu-img snapshot -d snapshot01 test.qcow2  //删除
```

#### 利用libvirt

```xml
<!-- snapshot01.xml -->
<domainsnapshot>
    <name>snapshot01</name>
    <description>Snapshot of OS install and updates by boh</description>
    <disks>
        <disk name='/var/lib/libvirt/images/ubuntu20.04_1.qcow2'>
        </disk>
    </disks>
</domainsnapshot>
```

```shell
# 1. 创建快照。快照元信息在/var/lib/libvirt/qemu/snapshot/（destroy后丢失）
# 创建后会有对应得快照文件（snapshot01.xml），删除快照后快照文件也删除
virsh snapshot-create ub2004_1 snapshot01.xml
# 2. 树形查看快照。
virsh snapshot-list ub2004_1 --tree
# 3. 查看当前快照
virsh snapshot-current ub2004_1
# 4. 恢复快照
virsh snapshot-revert ub2004_1 snapshot01
# 删除快照
virsh snapshot-delete ub2004_1 snapshot01

功能参数：
    --quiesce        quiesce guest's file systems
    --atomic         require atomic operation
```

### 外置快照

#### 利用qemu-img

```text
关机态
可以利用qcow2的backing_file创建。

运行态
可以利用qemu的snapshot_blkdev命令。（为了数据一致性，可以使用guest-fsfreeze-freeze和guest-fsfreeze-thaw进行文件系统的冻结解冻结操作）
多盘可以利用qemu的transaction实现atomic。
```

#### 利用libvirt

```shell
# 1. 创建
virsh snapshot-create-as --domain ub2004_1 snap1 snap1-desc \
--disk-only --diskspec vda,snapshot=external,file=/export/vmimages/sn1-of-f17-base.qcow2 \
--atomic

# 2. 查看
virsh domblklist ub2004_1

```


## 参考

[KVM: creating and reverting libvirt external snapshots](https://fabianlee.org/2021/01/10/kvm-creating-and-reverting-libvirt-external-snapshots/)

[QEMU checkpoint(snapshot) 使用](https://blog.csdn.net/JaCenz/article/details/126929081)

[Features/Snapshots](https://wiki.qemu.org/Features/Snapshots)
[kvm虚拟机快照技术](https://www.cnblogs.com/guge-94/p/11827390.html)

[KVM 介绍（7）：使用 libvirt 做 QEMU/KVM 快照和 Nova 实例的快照 （Nova Instances Snapshot Libvirt）](https://www.cnblogs.com/sammyliu/p/4468757.html)

[libvirt_Snapshots](https://wiki.libvirt.org/Snapshots.html)
