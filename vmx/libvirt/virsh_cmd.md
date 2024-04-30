# virsh cmd


## refs

[manpages](https://www.libvirt.org/manpages/virsh.html)

## 创建 vm

```shell
# 1. 虚拟化检测
grep -E "vmx|svm" /proc/cpuinfo

# 2. 安装KVM工具包
sudo apt update
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils

# [KVM-Qemu-Libvirt三者之间的关系](https://zhuanlan.zhihu.com/p/521167414)
# 创建磁盘镜像
# 创建一个格式为raw大小为50G的裸磁盘
# qemu-img create -f raw /var/lib/libvirt/images/CentOS-7-x86_64.raw 50G
# 创建一个格式为raw大小为50G的稀疏格式磁盘
# qemu-img create -f qcow2 /var/lib/libvirt/images/CentOS-7-x86_64.qcow2 50G
# https://www.cnblogs.com/eddie1127/p/12002826.html
qemu-img create -f qcow2 /var/lib/libvirt/images/ub2004_1.qcow2 16G

# 创建NAT网络虚拟机
virt-install --name ub2004_1 \
             --virt-type kvm \
             --os-variant ubuntu20.04 \
             --import \
             --memory 2048 \
             --vcpus 2 \
             --disk path=/var/lib/libvirt/images/ubuntu20.04_1.qcow2,size=8 \
             --network network=default \
             --graphics vnc,listen=0.0.0.0 \
             --console pty,target_type=serial

# virt-install命令创建bridge网络的虚拟机
virt-install --name ub2004_1 \
             --virt-type kvm \
             --os-variant ubuntu20.04 \
             --import \
             --memory 2048 \
             --vcpus 2 \
             --disk path=/var/lib/libvirt/images/ubuntu20.04_1.qcow2,size=8 \
             --network bridge=br0 \
             --graphics vnc,listen=0.0.0.0 \
             --console pty,target_type=serial

# 查看 vm 配置

virsh dumpxml ubuntu20.04 > vm.xml
```

## 快照

```shell
# 1. 创建
virsh snapshot-create ubuntu20.04
```

## FAQs

```shell
virsh set-user-password ubuntu20.04 --user dingjia --password dingjia123
```
