[KVM--libguestfs-tools工具介绍（九）](https://cloud.tencent.com/developer/article/2017457)
[libguestfs](https://github.com/libguestfs/libguestfs)
[libguestfs.org](https://libguestfs.org/)

## 安装

```shell
sudo apt-get install libguestfs-tools
```

## 命令使用

```shell
# 两命令不同
sudo guestfish -h
sudo guestfish --help

sudo guestfish --ro -i -a /var/lib/libvirt/images/ubuntu20.04.qcow2
```

### 更改密码

[使用 guestfish 修改 qcow2 镜像文件中的 root 密码，时区等](https://www.cnblogs.com/nihaorz/p/16013341.html)
[ubuntu-images](https://cloud-images.ubuntu.com/)
[centos8-images](https://cloud.centos.org/centos/8-stream/x86_64/images/)

```shell
# guestfish --rw -i -d ubuntu20.04
guestfish --rw -a /var/lib/libvirt/images/ubuntu20.04.qcow2

# 在宿主机生成密钥（假设为 123456）
openssl passwd -1 123456

list-filesystems
# 如以mount 不需要mount
# mount /dev/sda1 /
vi /etc/shadow
# umount /
exit
```
