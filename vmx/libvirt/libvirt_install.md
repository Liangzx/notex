# libvirt install ub2204

[源码编译安装 Libvirt 工具](https://blog.csdn.net/asvblog/article/details/128071456)
[compiling](https://libvirt.org/compiling.html)
[CentOS 8-libvirt 7 编译安装](https://robin5911.github.io/2021/09/28/CentOS-8-libvirt-7-%E7%BC%96%E8%AF%91%E5%AE%89%E8%A3%85/)
[libvirt](https://gitlab.com/libvirt/libvirt)



## 源码安装

```shell
# 1. 下载源码
# wget https://download.libvirt.org/libvirt-9.10.0.tar.xz
# tar -xvf archive.tar.xz
# cd libvirt-9.10.0
wget https://download.libvirt.org/libvirt-8.0.0.tar.xz

#2. 配置（编译debug版本）
meson build -Dsystem=true -Ddriver_qemu=enabled -Ddriver_libvirtd=enabled -Ddriver_remote=enabled --buildtype=debug

# 3. 编译 [-v] 能查看编译的命令 查看是否带 -g
ninja -v -C build

# 4. 安装
# 注意这里会安装到系统目录下，所以如果为了调试的话不需要安装
sudo ninja -C build install

# 5. 检查版本
virsh --version

# 6. 启动服务
sudo systemctl daemon-reload
sudo systemctl start libvirtd.service
systemctl start libvirtd
systemctl start virtlogd

# 异常
sudo systemctl list-unit-files --type=service | grep virt
# /etc/systemd/system/libvirtd.service

sudo systemctl unmask libvirt-guests.service
sudo systemctl unmask libvirtd.service
sudo systemctl unmask virtlockd.service
sudo systemctl unmask virtlogd.service
sudo systemctl unmask virtlogd-admin.socket
sudo systemctl unmask virtlogd.socket


```

## 依赖

```shell
sudo apt  install libxml2-utils -y
sudo apt install  xsltproc -y
sudo apt install libtirpc-dev  -y
sudo apt install gnutls-dev -y
sudo apt install libxml2-dev -y
sudo apt install libyajl-dev -y
# https://blog.csdn.net/phmatthaus/article/details/129736484
sudo apt install  python-docutils -y
# ub2204
sudo apt install  python3-docutils -y
sudo apt install dnsmasq -y
echo "/usr/local/lib" >> /etc/ld.so.conf
```

## 删除安装

```shell
# 库文件注意确认
rm -rf /etc/systemd/system/*virt*

# 库文件注意确认
rm -rf  /usr/local/lib/x86_64-linux-gnu/*virt*
```

## errors

```shell
# 1. meson.build:1:0: ERROR: Meson version is 0.53.2 but project requires >= 0.56.0
# 1.1 升级 meson
# 先安装 pip3
sudo apt install python3-pip
# 通过 pip3 安装 meson 指定的版本
pip3 install meson==0.63
meson -v

# 2. error : virGetUserID:760 : invalid argument: Failed to parse user 'libvirt-qemu'
# from poe
# 这个错误可能是由于 `libvirt-qemu` 用户在系统中不存在或无效导致的。在 libvirt 中，`libvirt-qemu` 用户是用于运行虚拟机的 QEMU 进程的用户。

要解决这个错误，您可以尝试以下步骤：

# 1. 检查 `libvirt-qemu` 用户是否存在：运行以下命令检查 `libvirt-qemu` 用户是否存在于系统中：
id libvirt-qemu

#2. 创建 `libvirt-qemu` 用户：运行以下命令创建 `libvirt-qemu` 用户
# 这将创建一个系统用户组和用户，并将其命名为 `libvirt-qemu`
sudo adduser --system --group --no-create-home libvirt-qemu
sudo groupadd libvirt

# 3. 设置 `libvirt-qemu` 用户的权限：运行以下命令为 `libvirt-qemu` 用户设置适当的权限：
# 这将确保 `libvirt-qemu` 用户具有适当的访问权限
sudo chown root:libvirt-qemu /var/run/libvirt
sudo chmod 0750 /var/run/libvirt

# 4. 重启 libvirt 服务：运行以下命令重启 libvirt 服务：
sudo systemctl enable libvirtd
sudo systemctl restart libvirtd
sudo systemctl enable virtlogd
sudo systemctl restart virtlogd

```
