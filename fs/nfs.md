# NFS

```text
NFS（Network File System，网络文件系统）是一种分布式文件系统协议，允许客户端计算机通过网络访问服务器上的文件和目录，
就像它们是本地资源一样。在 NFS 的架构中，涉及两个主要角色：NFS 服务器 和 NFS 客户端。

NFS 架构中的角色
1. NFS 服务器 (Server)
定义：NFS 服务器是指提供共享文件系统的计算机或设备。它负责管理对这些文件系统的访问，并响应来自客户端的读写请求。
任务：
    配置哪些目录或文件系统可以被共享（导出）。
    设置共享资源的安全性和权限控制。
    处理来自客户端的所有文件操作请求。
    配置步骤：
    在服务器上安装并启动 NFS 服务。
    编辑 /etc/exports 文件以指定要共享的目录及其访问权限。
    使用 exportfs 命令重新加载配置或手动导出共享。
    确保防火墙规则允许 NFS 流量通过。

配置步骤：
    在服务器上安装并启动 NFS 服务。
    编辑 /etc/exports 文件以指定要共享的目录及其访问权限。
    使用 exportfs 命令重新加载配置或手动导出共享。
    确保防火墙规则允许 NFS 流量通过。

2. NFS 客户端 (Client)
定义：NFS 客户端是指连接到 NFS 服务器并挂载共享文件系统的计算机。客户端可以通过标准的文件系统接口与远程数据进行交互。
任务：
    连接到 NFS 服务器并挂载其提供的共享资源。
    根据需要执行文件和目录的操作（如读取、写入、创建、删除等）。
    管理挂载点的状态（例如，在重启后自动重新挂载）。
配置步骤：
    在客户端上安装 NFS 客户端工具。
    使用 mount 命令或编辑 /etc/fstab 文件来挂载远程 NFS 共享。
    验证挂载是否成功，并确保能够正常访问共享资源。

挂载流程
简单来说，NFS 是由客户端挂载服务器提供的共享文件系统。具体过程如下：
NFS 服务器准备：服务器配置好要共享的文件系统，并通过 /etc/exports 文件定义了哪些客户端可以访问这些共享资源以及它们具有的权限。
NFS 客户端请求挂载：客户端使用 mount 命令或者通过 /etc/fstab 文件中的条目发起挂载请求。这告诉操作系统将远程服务器上的某个路径作为本地文件系统的一部分挂载到指定的位置。
建立连接：客户端与服务器建立 TCP 或 UDP 连接（取决于配置），并通过 NFS 协议协商如何传输文件数据。
开始使用：一旦挂载完成，用户就可以像操作本地文件一样操作远程文件系统中的文件和目录。

```

## 示例

```shell
# 在 NFS 服务器上：
# 编辑 /etc/exports 文件
echo "/my_pool/data *(rw,sync,no_subtree_check)" | sudo tee -a /etc/exports
# 导出共享
sudo exportfs -a
# 启动 NFS 服务
sudo systemctl start nfs-server
sudo systemctl enable nfs-server

# 在 NFS 客户端上：
# 创建挂载点
sudo mkdir -p /mnt/nfs_share
# 挂载 NFS 共享
sudo mount -t nfs 192.168.1.100:/my_pool/data /mnt/nfs_share
# 验证挂载是否成功
df -h | grep nfs_share
ls /mnt/nfs_share

# 如果你希望在每次启动时自动挂载该 NFS 共享，可以在客户端的 /etc/fstab 文件中添加一行：
192.168.1.100:/my_pool/data   /mnt/nfs_share   nfs    defaults    0 0

```
