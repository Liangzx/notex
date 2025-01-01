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
```
