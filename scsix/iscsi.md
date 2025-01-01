# iSCSI

## iSCSI Target

```shell
# iSCSI Target提供存储服务——磁盘
# 1. 安装
apt-get update -y
apt-get install tgt -y
systemctl status tgt

# 2. 配置
# iSCSI有两种命名格式： 一种是iqn， 一种是EUI。后者使用较少， 因为EUI命令不如iqn直观。 iqn的基本格式是：
#iqn.<YYYY-MM>.<reversed domain name>:<extra-name>
#iqn.2015-08.example.com:disk0
# 可以参考 /usr/share/doc/tgt/examples/targets.conf.example
vim /etc/tgt/conf.d/iscsi.conf
# 定义LUN（逻辑单元号）的名称。
#<target iqn.2001-04.com.example:storage.disk1>
#    # 定义了iSCSI Target服务器上存储设备的位置和名称（可以是物理磁盘或者LVM）
#    # 注意：使用的存储对象必须是新建的，而不能是在用的。
#    backing-store /dev/sdb
#    # 定义iSCSI启动器的IP地址——ACL
#    initiator-address 192.168.91.152
#    # initiator-address 192.168.91.0/24
#    # 定义传入的用户名/密码 iscsi-user password
#    incominguser test01 123456
#    # 定义目标将提供给启动器的用户名/密码 iscsi-target secretpass
#    outgoinguser test02 654321
#</target>

# 3. 测试结果
systemctl restart tgt
tgtadm --mode target --op show

```

## iSCSI Initiator

```shell
# iSCSI Initiator提供存储访问——用户
# 1. 安装
apt-get install open-iscsi -y

# 2. 配置
iscsiadm -m discovery -t st -p 172.20.10.40
# 节点配置文件将存放于目录 /etc/iscsi/nodes/ 中，并且每个LUN都有一个对应的配置目录。
# 比如：/etc/iscsi/nodes/iqn.2021-03.bee.com:iscsi.disk0/172.20.10.40,3260,1/default
# 在上述发现命令执行完毕后将在 /etc/iscsi/nodes/ 中自动生成指向iscsi target的IP的配置目录。
# 在存储技术中，LUN（Logical Unit Number）是用于标识SCSI（Small Computer System Interface）
# 或光纤通道协议中的逻辑单元的编号。LUN实际上是一个软件层面的概念，它允许一个物理存储设备被划分为多个独立的逻辑卷，
# 每个逻辑卷都可以作为一个单独的硬盘来使用。

# 添加iSCSI Target LUN名称
vim /etc/iscsi/initiatorname.iscsi
# 注意InitiatorName只能有一个。主要用于标识 Initiator，与target无关。
InitiatorName=iqn.2001-04.com.example:storage.disk1.init1

# 定义Initiator对应iscsi target的CHAP认证信息（可选）。
vim /etc/iscsi/iscsid.conf
# 修改以下信息
node.session.auth.authmethod = CHAP
node.session.auth.username = test01 # incominguser
node.session.auth.password = 123456 # incominguser
node.session.auth.username_in = test02 # outgoinguser
node.session.auth.password_in = 654321 # outgoinguser
node.startup = automatic # 开机自动登陆iscsi target（必选）

# 通过命令修改
iscsiadm -m node -T iqn.2001-04.com.example:storage.disk1 -p 172.20.10.40:3260 --op update -n node.session.auth.authmethod -v CHAP
iscsiadm -m node -T iqn.2001-04.com.example:storage.disk1 -p 172.20.10.40:3260 --op update -n node.startup -v automatic

# 3. 测试结果
# 这里会自动登陆iscsi target（更新配置时的出错考虑删除/etc/iscsi/nodes下的配置文件夹），完了使用iscsiadm -m node -o show 查看生成的配置。
systemctl restart open-iscsi iscsid

# 查看iSCSI Initiator工作状态
systemctl status open-iscsi
iscsiadm -m session -o show

# 发现iscsi target
iscsiadm -m discovery -t sendtargets -p 172.20.10.40
或者
iscsiadm -m node --login

# 登陆iscsi target
iscsiadm -m node -T iqn.2001-04.com.example:storage.disk1 -p 172.20.10.40 -l

# 登出iscsi target
iscsiadm -m node -T iqn.2001-04.com.example:storage.disk1 -p 172.20.10.40 -u

# 验证连接
sudo iscsiadm -m session

# 查看LUN设备
fdisk -l
cat /proc/partitions
lsblk
# 查看UUID
blkid

# 4. 创建文件系统
fdisk /dev/sdb

Welcome to fdisk (util-linux 2.34).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0xd8da0e5f.

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1):
First sector (2048-20971519, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-20971519, default 20971519):

Created a new partition 1 of type 'Linux' and of size 10 GiB.

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.

# 格式化分区
mkfs.ext4 /dev/sdb1

#挂载分区
mount /dev/sdb1 /mnt
df -h
# 查看磁盘统计信息
du -shc * /mnt

```

## 在Linux系统中进行iSCSI LUN上的文件读取和写入的基本步骤：

```shell
# 1. 发现 iSCSI 目标
sudo iscsiadm -m discovery -t st -p 172.20.10.40

# 2. 登录到 iSCSI 目标
sudo iscsiadm -m node -T iqn.2001-04.com.example:storage.disk1 -p 172.20.10.40:3260 --login

# 3. 查看新添加的块设备
sudo lsblk

# 4. 创建文件系统（如果尚未创建）, 其中 /dev/sdb 是你发现的新块设备
sudo mkfs.ext4 /dev/sdb

# 5. 挂载文件系统
sudo mount /dev/sdb /mnt/iscsi

# 6. 读取和写入文件
# 写入文件
echo "Hello, iSCSI!" > /mnt/iscsi/hello.txt

# 读取文件
cat /mnt/iscsi/hello.txt

# 7. 卸载文件系统（当不再需要时）,当你完成所有操作后，应该卸载文件系统以确保数据完整性
sudo umount /mnt/iscsi

# 8. 注销 iSCSI 会话（可选）
sudo iscsiadm -m node -T iqn.2001-04.com.example:storage.disk1 -p 172.20.10.40:3260 --logout

# note
# /mnt/iscsi 是你选择用来挂载iSCSI LUN的本地文件系统中的一个目录。它位于你的本地计算机上，
# 而不是在iSCSI目标（target）上。这个目录通常被称为挂载点。当你通过iSCSI协议连接到远程存储设备并将其LUN映射为块设备后，
# 你需要将该块设备格式化为一个文件系统（如果还没有格式化的话），然后将这个文件系统挂载到一个本地目录下，比如 /mnt/iscsi。
# 这样，你就可以通过访问这个本地目录来读写远程存储设备上的数据了。
# 总结一下：
#   iSCSI 目标（Target）：这是远程存储设备，提供了一个或多个逻辑单元（LUN）。
#   iSCSI 发起端（Initiator）：这是你的本地计算机或服务器，它通过网络连接到iSCSI目标，并使用iSCSI协议进行通信。
#   挂载点（如 /mnt/iscsi）：这是在发起端（你的本地计算机）上创建的一个目录，用于挂载远程LUN对应的文件系统。一旦LUN被挂载到这个目录，你就可以像访问本地磁盘一样访问远程存储空间。

```

## 参考
[Linux配置iSCSI存储](https://www.cnblogs.com/liuxing0007/p/11442537.html)
[IP网络存储iSCSI的概念与工作原理](https://www.cnblogs.com/liujunjun/p/15619650.html)
[ISCSI工作流程target和initiator](https://www.cnblogs.com/wuchanming/p/4894366.html)
[iscsi的工作原理与优化](https://www.cnblogs.com/topass123/p/12579290.html)
[网络磁盘共享iscsi服务](https://blog.csdn.net/llllyr/article/details/99647744)
[Linux iscsi/target 内核模块框架详细解析](https://blog.csdn.net/maybeYoc/article/details/135357641)
[Ubuntu20.04 server 安装iSCSI](https://blog.csdn.net/beeworkshop/article/details/114523270)
[Linux上open-iscsi 的安装，配置和使用](https://www.cnblogs.com/sting2me/p/6937578.html)
