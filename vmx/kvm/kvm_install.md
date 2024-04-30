# ub2004

https://cloud.tencent.com/developer/article/1657533

[Ubuntu22.04安装配置KVM虚拟化](https://zhuanlan.zhihu.com/p/692018636)


## 一、前提条件

```shell
# 1. 查看cpu是否支持虚拟化（如果输出为0，它意味着这个 CPU 不支持硬件虚拟化）
# 系统必须拥有 支持 VT-x（vmx）的 Intel 处理器 或者支持 AMD-V (svm) 技术的 AMD 处理器

grep -Eoc '(vmx|svm)' /proc/cpuinfo

# 2. 查看 bios 是否启用 VT
sudo apt update
sudo apt install cpu-checker
kvm-ok

```

## 二、在 Ubuntu 20.04 上安装 KVM

```shell
# qemu-kvm - 为 KVM 管理程序提供硬件模拟的软件程序
# libvirt-daemon-system - 将 libvirt 守护程序作为系统服务运行的配置文件
# libvirt-clients - 用来管理虚拟化平台的软件
# bridge-utils - 用来配置网络桥接的命令行工具
# virtinst - 用来创建虚拟机的命令行工具
# virt-manager - 提供一个易用的图形界面，并且通过libvirt 支持用于管理虚拟机的命令行工具

sudo apt remove qemu-kvm libvirt-daemon libvirt-daemon-system libvirt-clients bridge-utils virtinst virt-manager libvirt-dev

# 验证
sudo systemctl is-active libvirtd

# 添加用户到“libvirt” 和 “kvm” 用户组
sudo usermod -aG libvirt $USER
sudo usermod -aG kvm $USER

```

## 三、网络设置

```shell
# 在libvirt 安装过程中，一个被称为 “virbr0”的桥接设备默认被创建。
# 这个设备使用 NAT 来连接客户机到外面的世界。
brctl show

```

## 四、创建虚拟机

```shell
virt-manager
# wget https://github.com/virt-manager/virt-manager/archive/refs/tags/v4.1.0.tar.gz
apt install libvirt-glib-1.0-dev
apt install libosinfo-1.0-dev
sudo pip3 install libvirt-python
sudo pip3 install libxml2-python3

```

[ValueError:命名空间Gtk不可用](https://cloud.tencent.com/developer/ask/sof/921686)
