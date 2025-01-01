# Virsh 常用命令

```shell
# 虚拟机管理
echo "列出所有虚拟机"
virsh list --all

echo "启动虚拟机"
virsh start <vm-name>

echo "关闭虚拟机"
virsh shutdown <vm-name>

echo "强制关闭虚拟机"
virsh destroy <vm-name>

echo "重启虚拟机"
virsh reboot <vm-name>

echo "挂起虚拟机"
virsh suspend <vm-name>

echo "恢复挂起的虚拟机"
virsh resume <vm-name>

# 删除虚拟机的配置
virsh undefine ubuntu20.04

# 删除虚拟机的磁盘文件
virsh dumpxml ubuntu20.04 | grep 'source file'

rm /var/lib/libvirt/images/ubuntu20.04.qcow2

# 虚拟机信息
echo "查看虚拟机信息"
virsh dominfo <vm-name>

echo "查看虚拟机的XML配置"
virsh dumpxml <vm-name>

echo "查看虚拟机的控制台输出"
virsh console <vm-name>

# 虚拟机快照
echo "创建快照"
virsh snapshot-create-as <vm-name> <snapshot-name>

echo "列出快照"
virsh snapshot-list <vm-name>

echo "恢复快照"
virsh snapshot-revert <vm-name> <snapshot-name>

echo "删除快照"
virsh snapshot-delete <vm-name> <snapshot-name>

# 虚拟机存储
echo "列出存储池"
virsh pool-list --all

echo "创建存储池"
virsh pool-create <xml-file>

echo "启动存储池"
virsh pool-start <pool-name>

echo "停止存储池"
virsh pool-destroy <pool-name>

echo "删除存储池"
virsh pool-delete <pool-name>

# 虚拟机网络
echo "列出网络"
virsh net-list --all

echo "启动网络"
virsh net-start <network-name>

echo "停止网络"
virsh net-destroy <network-name>

echo "创建网络"
virsh net-create <xml-file>

echo "删除网络"
virsh net-undefine <network-name>



# 与 vm 交互
## 可以通过 lsof -p qemu 进程
## monitor: /var/lib/libvirt/qemu/domain-2-ubuntu20.04/monitor.sock
## 源码 全局匹配'/monitor.' src/qemu/qemu_process.c
## ga: /var/lib/libvirt/qemu/channel/target/domain-2-ubuntu20.04/org.qemu.guest_agent.0
## 源码 全局匹配 'guest_agent.' src/qemu/qemu_domain.c
## 查询虚拟机状态 对应函数 virDomainQemuMonitorCommand
virsh qemu-monitor-command ubuntu20.04 --hmp "info status"
virsh qemu-monitor-command --domain ubuntu20.04 --pretty '{"execute":"query-status"}'
## 获取虚拟机信息
virsh qemu-monitor-command --domain ubuntu20.04 --pretty '{"execute":"query-version"}'

## 获取虚拟机的块设备信息
virsh qemu-monitor-command --domain ubuntu20.04 --pretty '{"execute":"query-block"}'
```

## qemu 位图

```shell
# https://www.qemu.org/docs/master/interop/bitmaps.html#overview
# 发送 QMP 命令
virsh qemu-monitor-command --domain ubuntu20.04 --pretty '{"execute":"qmp_capabilities"}'

#  查询磁盘节点名称
virsh qemu-monitor-command --domain ubuntu20.04 --pretty '{"execute":"query-block"}'

# 创建位图
virsh qemu-monitor-command --domain ubuntu20.04 --pretty '
{
    "execute": "block-dirty-bitmap-add",
    "arguments": {
        "node": "libvirt-2-format",
        "name": "bitmap0",
        "persistent": true
    }
}'

# 删除位图
virsh qemu-monitor-command --domain ubuntu20.04 --pretty '
{
    "execute": "block-dirty-bitmap-remove",
    "arguments": {
       "node": "libvirt-2-format",
       "name": "bitmap0"
    }
}'

# 清除位图
virsh qemu-monitor-command --domain ubuntu20.04 --pretty '
{
    "execute": "block-dirty-bitmap-clear",
    "arguments": {
        "node": "libvirt-2-format",
        "name": "bitmap0"
    }
}'

# enable 位图
virsh qemu-monitor-command --domain ubuntu20.04 --pretty '
{
    "execute": "block-dirty-bitmap-enable",
    "arguments": {
        "node": "libvirt-2-format",
        "name": "bitmap0"
    }
}'

# disable 位图
virsh qemu-monitor-command --domain ubuntu20.04 --pretty '
{
    "execute": "block-dirty-bitmap-disable",
    "arguments": {
        "node": "libvirt-2-format",
        "name": "bitmap0"
    }
}'

# merge 位图
virsh qemu-monitor-command --domain ubuntu20.04 --pretty '
{
    "execute": "block-dirty-bitmap-merge",
    "arguments": {
        "node": "libvirt-2-format",
        "target": "new_bitmap",
        "bitmaps": [
            "bitmap0"
        ]
    }
}'

# 查询位图信息：
virsh qemu-monitor-command --domain ubuntu20.04 --pretty '
{
    "execute": "query-block"
}'

```

## Example: Multi-drive Incremental Backup

```shell
# // https://www.cnblogs.com/ishmaelwanglin/p/17053204.html
# internal error: cannot load AppArmor profile 'libvirt-
# https://askubuntu.com/questions/1032939/internal-error-cannot-load-apparmor-profile-libvirt
# /etc/libvirt/qemu.conf security_driver = "none"
# 1. For each drive, create an empty image:
qemu-img create -f qcow2 drive0.full.qcow2 8G
qemu-img create -f qcow2 drive1.full.qcow2 8G
# 权限 问题 /etc/libvirt/qemu.conf user=root group=root
# https://gitlab.com/libvirt/libvirt/-/issues/150
# systemctl restart libvirtd

# 2. Add target block nodes:
virsh qemu-monitor-command --domain ubuntu20.04 --pretty '
{
    "execute": "blockdev-add",
    "arguments": {
        "node-name": "target0",
        "driver": "qcow2",
        "file": {
            "driver": "file",
            "filename": "/root/inc/drive0.full.qcow2"
        }
    }
}'

# 3. Create a full (anchor) backup for each drive, with accompanying bitmaps:
virsh qemu-monitor-command --domain ubuntu20.04 --pretty '
{
    "execute": "blockdev-backup",
    "arguments": {
        "device": "disk",
        "bitmap": "bitmap0",
        "target": "target0",
        "sync": "incremental"
    }
}'

virsh qemu-monitor-command --domain ubuntu20.04 '{ "execute" : "drive-backup" , "arguments" : { "device" : "libvirt-2-format" , "sync" : "full" , "target" : "/root/inc/drive0.inc.qcow2" } }'

virsh qemu-monitor-command --domain ubuntu20.04 --pretty '
{
    "execute": "transaction",
    "arguments": {
        "actions": [
            {
                "type": "block-dirty-bitmap-add",
                "data": {
                    "node": "libvirt-2-format",
                    "name": "bitmap0"
                }
            },
            {
                "type": "blockdev-backup",
                "data": {
                    "device": "libvirt-2-format",
                    "target": "target0",
                    "sync": "full"
                }
            }
        ]
    }
}'
```
