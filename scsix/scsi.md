# SCSI

```text
SCSI（Small Computer System Interface，小型计算机系统接口）是一种用于计算机和其外围设备之间进行数据传输的标准接口。
它最初设计于1986年，旨在提供一种高性能、高可靠性的接口标准，特别适用于服务器和工作站环境中的存储设备。

主要特点
高性能：SCSI接口支持高速数据传输，这使得它非常适合需要大量数据交换的应用场景，如服务器和高端工作站。
多设备连接：一个SCSI适配器可以连接多个设备（通常最多15或16个），包括硬盘驱动器、磁带驱动器、光驱、打印机等。
独立处理器：SCSI设备通常有自己的控制器，可以在一定程度上减轻主机CPU的负担，提高系统的整体性能。
命令集丰富：SCSI协议定义了一套丰富的命令集，支持多种操作，如读写、寻道、格式化等。
可靠性高：SCSI接口具有较高的容错能力和错误恢复机制，适合关键任务环境。

物理接口
SCSI有多种物理接口类型，包括但不限于：

SCSI-1, SCSI-2, SCSI-3：这些是SCSI的不同版本，每个版本都引入了新的特性和改进。
Ultra SCSI, Ultra2 SCSI, Ultra3 SCSI：这些是SCSI的不同速度等级，提供了更高的数据传输速率。
Wide SCSI：支持更宽的数据总线，从而增加数据传输速率。
Low Voltage Differential (LVD) SCSI：使用差分信号，提高了抗干扰能力和传输距离。
Fibre Channel (FC)：一种基于光纤的SCSI变体，提供极高的传输速率和长距离传输能力。
应用
SCSI接口主要用于以下场景：

服务器：在企业级服务器中，SCSI硬盘和其他SCSI设备因其高性能和可靠性而被广泛使用。
工作站：在需要处理大量数据的专业工作站中，SCSI也是常见的选择。
外部存储：SCSI接口也用于连接外部存储设备，如磁盘阵列和磁带库。
iSCSI
iSCSI（Internet Small Computer System Interface）是一种基于IP网络的SCSI协议，它允许通过TCP/IP网络进行块级数据传输。
iSCSI将SCSI命令封装在IP数据包中，使得存储设备可以通过标准的以太网基础设施进行访问，从而降低了成本并简化了部署。

总结
SCSI是一种成熟且高效的接口标准，特别适用于对性能和可靠性要求较高的环境。
尽管随着SATA和NVMe等新技术的发展，SCSI在某些领域的应用有所减少，但它仍然是许多关键任务环境中不可或缺的技术。

SCSI Target 是存储网络中的一个概念，特别是在 iSCSI（Internet Small Computer System Interface）和 FC（Fibre Channel）等协议中。
SCSI Target 通常是指在网络上提供存储资源的设备或服务。

定义
    SCSI Target：在 SCSI 协议中，Target 是指提供存储资源的设备。它可以是一个物理磁盘、磁盘阵列、虚拟磁盘或其他类型的存储设备。
    SCSI Initiator：Initiator 是指发起 I/O 请求的设备，通常是服务器或客户端计算机。

工作原理
    发现：Initiator 通过网络发现 Target。在 iSCSI 中，这可以通过 SendTargets 发现方法或使用 ISNS（Internet Storage Name Service）等方式完成。
    登录：Initiator 向 Target 发送登录请求，建立会话。一旦会话建立成功，Initiator 就可以访问 Target 上的 LUN（Logical Unit Number）。
    数据传输：Initiator 可以读取和写入 Target 上的数据。这些操作是通过 SCSI 命令集进行的。
    登出：当不再需要访问 Target 时，Initiator 可以发送登出请求，终止会话。

应用场景
    iSCSI：在 iSCSI 环境中，SCSI Target 通常是一个运行在 Linux 或其他操作系统上的 iSCSI 目标子系统，如 tgt（Targetd）、lio-utils 或者商业解决方案如 StarWind Virtual SAN。
    Fibre Channel (FC)：在 FC 环境中，SCSI Target 通常是存储阵列，通过光纤通道网络连接到主机。

配置示例 [deprecated]
    使用 targetcli 来配置一个 iSCSI Target，以下是一个简单的配置步骤：


```

## 常用命令

```shell
# /sys/class/scsi_host/
# /sys/class/scsi_host/ 目录是 Linux 系统中用于管理 SCSI 主机适配器的 sysfs 接口。
# 这个目录下的每个子目录代表一个 SCSI 主机适配器（例如，SATA 控制器、USB 存储控制器等）。
# 通过这些接口，你可以查看和控制 SCSI 设备的状态。

# 列出所有 SCSI 主机适配器
ls /sys/class/scsi_host/

# 查看某个 SCSI 主机适配器的信息，例如，查看 host0 的信息：
ll  /sys/class/scsi_host/host0/
# active_mode：显示或设置当前主机适配器的活动模式（例如，ALUA - Asymmetric Logical Unit Access）。
# can_queue：显示主机适配器可以处理的最大命令队列长度。
# cmd_per_lun：显示每个逻辑单元（LUN）可以同时处理的最大命令数。
# device -> ../../../host0/：符号链接，指向该主机适配器在 /sys 文件系统中的设备节点。
# eh_deadline：显示或设置错误恢复超时时间（以秒为单位）。
# host_busy：显示主机适配器是否忙于处理 I/O 请求。
# host_reset：可写文件，向其写入数据会触发主机适配器复位。通常写入 1 来触发复位。
# power/：子目录，包含与电源管理相关的文件。
# proc_name：显示驱动该主机适配器的内核模块名称。
# prot_capabilities：显示主机适配器支持的数据保护能力。
# prot_guard_type：显示主机适配器支持的数据保护类型。
# scan：可写文件，向其写入特定格式的数据会触发总线扫描。例如，写入 - - - 会触发所有通道、目标和 LUN 的重新扫描。
# sg_prot_tablesize：显示主机适配器支持的 SG 保护表大小。
# sg_tablesize：显示主机适配器支持的散列表（scatter-gather table）大小。
# state：显示主机适配器的状态（例如，运行、离线等）。
# subsystem -> ../../../../../../../class/scsi_host/：符号链接，指向 /sys/class/scsi_host 目录。
# supported_mode：显示主机适配器支持的所有模式。
# uevent：用于通知用户空间守护进程（如 udev）关于设备事件的文件。
# unchecked_isa_dma：显示主机适配器是否允许未检查的 ISA DMA 传输。
# unique_id：显示主机适配器的唯一标识符。
# use_blk_mq：显示主机适配器是否使用多队列块层（blk-mq）

# 重新扫描 SCSI 总线
echo "- - -" > /sys/class/scsi_host/host0/scan

# 查看 SCSI 主机适配器的状态
cat /sys/class/scsi_host/host0/state

# 查看 host0 的状态
cat /sys/class/scsi_host/host0/state

# 查看 host0 的队列深度
cat /sys/class/scsi_host/host0/queue_depth

# 查看 host0 的驱动程序
cat /sys/class/scsi_host/host0/proc_name

# 查看 scsi
cat /proc/scsi/scsi
# Attached devices:
# Host: scsi1 Channel: 00 Id: 00 Lun: 00
#   Vendor: NECVMWar Model: VMware IDE CDR10 Rev: 1.00
#   Type:   CD-ROM                           ANSI  SCSI revision: 05
# Host: scsi2 Channel: 00 Id: 00 Lun: 00
#   Vendor: VMware   Model: Virtual disk     Rev: 1.0
#   Type:   Direct-Access                    ANSI  SCSI revision: 02
# Host: scsi5 Channel: 00 Id: 00 Lun: 01
#   Vendor: LIO-ORG  Model: IBLOCK           Rev: 4.0
#   Type:   Direct-Access                    ANSI  SCSI revision: 05
# Host: scsi6 Channel: 00 Id: 00 Lun: 01
#   Vendor: LIO-ORG  Model: IBLOCK           Rev: 4.0
#   Type:   Direct-Access                    ANSI  SCSI revision: 05
# Host: scsi11 Channel: 00 Id: 00 Lun: 01
#   Vendor: LIO-ORG  Model: IBLOCK           Rev: 4.0
# 一个主板可能接多个host，比如上面的服务器，在有多个sas芯片的情况下，肯定就有多个host。
# 一个sas芯片又可以分割为多个通道，也就是channel，也叫bus。一个通道下多个target，一个target下多个lun。
# 如果一个硬盘支持双通道，那么在scsi层，就是展示为两个scsi标号。

```

## Linux IO

```text
lio-utils [deprecated] 使用 targetcli 是 Linux 内核中的 LIO（Linux-IO）目标子系统的用户空间工具集，用于配置和管理
iSCSI、FCoE（Fibre Channel over Ethernet）、iSER（iSCSI over RDMA）等存储目标。
LIO 提供了一个高度灵活且功能强大的框架，可以用来创建和管理各种类型的块存储目标。
```

### targetcli 安装

```shell
# # 安装 lio-utils [deprecated]
# apt-get update
# apt-get install lio-utils
# # https://github.com/Datera/lio-utils
# # 验证安装，安装完成后，你可以使用 targetcli 命令来验证 lio-utils 是否已正确安装并运行

# 1. 安装 targetcli
sudo apt update
sudo apt install targetcli-fb

# 2. 启动 targetcli （交互式）
targetcli

# 例子1
# 1. 创建 iSCSI 目标
/iscsi create iqn.2023-01.com.example:target1

# 2. 删除 iSCSI 目标（非交互）
targetcli /iscsi delete iqn.2023-01.com.example:target1

# 文件方式 commands.txt
# /iscsi create iqn.2023-01.com.example:target1
# /backstores/block create name=mydisk dev=/dev/vg0/lv0
# /iscsi/iqn.2023-01.com.example:target1/tpg1/luns create /backstores/block/mydisk
# /iscsi/iqn.2023-01.com.example:target1/tpg1/acls create iqn.2023-01.com.example:client
sudo targetcli /f commands.txt

# 创建后端存储（例如使用 LVM）
/backstores/block create name=mydisk dev=/dev/vg0/lv0

# 示例2 创建一个基于文件的 iSCSI 目标，并将其暴露给发起端，以下是完整的步骤:

# 安装 targetcli
sudo apt-get update
sudo apt-get install targetcli

# 启动 targetcli
sudo targetcli

# 创建一个 10GB 的文件后端存储
# sudo fallocate -l 10G /var/lib/iscsi/disk1.img
targetcli /backstores/fileio create disk1 /var/lib/iscsi/disk1.img 10G

# 创建一个新的 iSCSI 目标
targetcli /iscsi create iqn.2001-04.com.example:storage.disk1

# 将文件后端存储关联到 iSCSI 目标的 LUN 0
targetcli /iscsi/iqn.2001-04.com.example:storage.disk1/tpg1/luns create /backstores/fileio/disk1

# 配置监听端口（可选）
targetcli /iscsi/iqn.2001-04.com.example:storage.disk1/tpg1/portals create 172.20.10.40 3260

# 设置 ACL，允许特定的发起端访问 [more /etc/iscsi/initiatorname.iscsi]
targetcli /iscsi/iqn.2001-04.com.example:storage.disk1/tpg1/acls create iqn.1993-08.org.debian:01:823b6fd8f520

# 保存配置并退出
targetcli saveconfig
targetcli exit

# ---------示例3:-----------
# 启动 targetcli
sudo targetcli

# 创建一个 10GB 的文件后端存储
/backstores/fileio create mydisk /var/lib/iscsi/mydisk.img 10G

# 创建一个新的 iSCSI 目标
/iscsi create iqn.2001-04.com.example:storage.disk1

# 配置第一个 TPG (tpg1)
# TPG (Target Portal Group)
# TPG 是 iSCSI 目标的一个逻辑分组，它包含一组监听端口（Portals），这些端口可以接收来自 iSCSI 发起端的连接请求。
# Portal 是一个 IP 地址和端口号的组合，表示 iSCSI 目标上的一个监听点
cd /iscsi/iqn.2001-04.com.example:storage.disk1/tpg1
portals create 192.168.1.100 3260
acls create iqn.1994-05.com.redhat:initiator1
luns create /backstores/fileio/mydisk

# 创建第二个 TPG (tpg2)
/iscsi/iqn.2001-04.com.example:storage.disk1/tpg2 enable
cd /iscsi/iqn.2001-04.com.example:storage.disk1/tpg2
portals create 192.168.1.101 3260
acls create iqn.1994-05.com.redhat:initiator2
luns create /backstores/fileio/mydisk

# 查看 portals acls
targetcli ls /iscsi/iqn.2001-04.com.example:storage.disk1/tpg1/portals
targetcli ls /iscsi/iqn.2001-04.com.example:storage.disk1/tpg1/acls

# 保存配置并退出
saveconfig
exit
#------------示例3:------------
# 启动和启用 iSCSI 目标服务
sudo systemctl enable target
sudo systemctl start target
```

## FAQs

### Linux SCSI Target Framework (STF) 与 Target Core Mod（TCM）

```text
Linux SCSI Target Framework（STF）和 Target Core Mod（TCM）都是用于实现 SCSI 目标的框架，但它们在设计和实现上有所不同。
TCM is another name for LIO, an in-kernel iSCSI target (server).
主要区别
架构层次：
SCSI Target Framework (STF)：是较早的实现，主要用于支持 iSCSI 和 SCSI 目标。它相对较复杂，包含多个模块，专注于提供 SCSI 目标的功能。
Target Core Mod (TCM)：是对 STF 的改进，提供了更简化和统一的接口，旨在支持多种存储协议（如 iSCSI、Fibre Channel 等）。
功能性：

STF：功能较为基础，主要专注于传统的 SCSI 目标。
TCM：引入了更灵活的设计，支持多种协议，并提供了更强的扩展性和可维护性。
使用和管理：

STF：管理和配置较为繁琐，通常使用不同的工具。
TCM：通过 targetcli 等工具提供了更友好的用户界面，使得配置和管理更加直观。
现代支持：

TCM 是现代 Linux 系统中推荐的目标实现，已经取代了 STF，许多新特性和修复都集中在 TCM 上。
```

### 控制器中的通道

```text
在硬盘控制器（如RAID控制器或SATA控制器）中，通道是指控制器与硬盘之间的独立数据路径。
每个通道可以连接一个或多个硬盘。例如：
SATA控制器：一个SATA控制器可能有多个通道，每个通道可以连接一个SATA硬盘。
SAS控制器：SAS（Serial Attached SCSI）控制器也有多通道设计，每个通道可以连接多个SAS或SATA硬盘。
例子:
一个4通道的SATA控制器可以同时连接并管理4个SATA硬盘。
一个8通道的SAS控制器可以连接和管理多达8个SAS或SATA硬盘。
```

### 如何直接 操作Linux LIO kernel targe

```shell
# 直接操作 Linux LIO (Linux-IO) 内核目标通常需要通过配置文件系统（configFS）来完成。
# LIO 是一个高性能的 SCSI 目标子系统，支持多种协议，如 iSCSI、Fibre Channel、SRP (SCSI RDMA Protocol) 等。
# 以下是一些基本步骤和命令，用于直接操作 LIO 内核目标。

#!/bin/bash

# 加载必要的内核模块
sudo modprobe target_core_mod
sudo modprobe iscsi_target_mod
sudo modprobe target_core_file
sudo modprobe target_core_iblock

target_core_file：使用文件作为后端存储。
target_core_iblock：使用物理块设备作为后端存储。
iscsi_target_mod：实现 iSCSI 协议，使系统成为 iSCSI 目标。
target_core_pscsi：使用物理 SCSI 设备作为后端存储。
target_core_user：允许用户空间应用程序与 TCM 框架交互，实现自定义后端存储。
target_core_mod

# 挂载 configFS
sudo mount -t configfs none /sys/kernel/config

# 创建后端存储 [/sys/kernel/config/target/iscsi/iqn.2001-04.com.example:storage.disk1]
sudo mkdir -p /sys/kernel/config/target/loopback/disk1
echo "/var/lib/iscsi/disk1.img" | sudo tee /sys/kernel/config/target/loopback/disk1/backing_file

# 创建 iSCSI 目标
sudo mkdir -p /sys/kernel/config/target/iscsi/iqn.2001-04.com.example:storage.disk1/tpg1
cd /sys/kernel/config/target/iscsi/iqn.2001-04.com.example:storage.disk1/tpg1

# 配置监听端口
sudo mkdir -p np/172.20.10.40:3260

# 添加 LUN
sudo mkdir -p lun/lun0
echo 1 | sudo tee /sys/kernel/config/target/iscsi/iqn.2001-04.com.example:storage.disk1/tpg1/lun/lun0/enable
echo /sys/kernel/config/target/loopback/disk1/bs | sudo tee /sys/kernel/config/target/iscsi/iqn.2001-04.com.example:storage.disk1/tpg1/lun/lun0/bs_type

# 配置 ACL
sudo mkdir -p acls/iqn.1994-05.com.redhat:myinitiator

# 启用 TPG
echo 1 | sudo tee /sys/kernel/config/target/iscsi/iqn.2001-04.com.example:storage.disk1/tpg1/enable

echo "iSCSI 目标已成功配置"

```

### 为什么看不到端口 3260 对应的进程

```text
为内核进程，内核进程看不到端口号对应的进程名
```

例子

```c
#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/socket.h>
#include <linux/net.h>
#include <linux/in.h>
#include <linux/inet.h>
#include <linux/slab.h>
#include <linux/uaccess.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Your Name");
MODULE_DESCRIPTION("A simple TCP server kernel module.");

static struct socket *listen_sock;
static struct socket *client_sock;

static int __init tcp_server_init(void) {
    struct sockaddr_in server_addr;
    struct msghdr msg;
    struct kvec vec;
    char buffer[1024];
    int ret;

    // 创建 TCP 套接字
    ret = sock_create(AF_INET, SOCK_STREAM, IPPROTO_TCP, &listen_sock);
    if (ret < 0) {
        pr_err("Failed to create socket: %d\n", ret);
        return ret;
    }

    // 设置服务器地址
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(8888); // 监听端口
    server_addr.sin_addr.s_addr = htonl(INADDR_ANY); // 监听所有接口

    // 绑定套接字
    ret = kernel_bind(listen_sock, (struct sockaddr *)&server_addr, sizeof(server_addr));
    if (ret < 0) {
        pr_err("Failed to bind socket: %d\n", ret);
        sock_release(listen_sock);
        return ret;
    }

    // 开始监听
    ret = kernel_listen(listen_sock, 5);
    if (ret < 0) {
        pr_err("Failed to listen: %d\n", ret);
        sock_release(listen_sock);
        return ret;
    }

    pr_info("TCP server listening on port 8080\n");

    // 接受客户端连接
    while (1) {
        struct sockaddr_in client_addr;
        int client_len = sizeof(client_addr);
        ret = kernel_accept(listen_sock, &client_sock, O_NONBLOCK);
        if (ret < 0) {
            pr_err("Failed to accept connection: %d\n", ret);
            break;
        }
        pr_info("Client connected\n");

        // 处理客户端请求
        memset(&msg, 0, sizeof(msg));
        vec.iov_base = buffer; // 指向接收缓冲区
        vec.iov_len = sizeof(buffer); // 缓冲区大小

        ret = kernel_recvmsg(client_sock, &msg, &vec, 1, sizeof(buffer), 0);
        if (ret > 0) {
            buffer[ret] = '\0'; // null-terminate
            pr_info("Received: %s\n", buffer);
            kernel_sendmsg(client_sock, &msg, &vec, ret, ret); // Echo back
        }

        // 关闭客户端连接
        kernel_sock_shutdown(client_sock, SHUT_RDWR);
        sock_release(client_sock);
        pr_info("Client disconnected\n");
    }

    return 0;
}

static void __exit tcp_server_exit(void) {
    if (listen_sock) {
        kernel_sock_shutdown(listen_sock, SHUT_RDWR);
        sock_release(listen_sock);
    }
    pr_info("TCP server module unloaded\n");
}

module_init(tcp_server_init);
module_exit(tcp_server_exit);


/**
obj-m += tcp_server.o

all:
    make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

clean:
    make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean

*/
```


## 参考

[lsscsi 与 cat /proc/scsi/scsi](https://www.cnblogs.com/longchang/p/11045533.html)
[深入浅出SCSI子系统（一）Linux 内核中的 SCSI 架构](https://blog.csdn.net/sinat_37817094/article/details/120357371)
[深入浅出SCSI子系统（二）SCSI子系统对象](https://blog.csdn.net/sinat_37817094/article/details/120541004)
[存储原理](https://blog.csdn.net/sinat_37817094/category_11365652.html)
[Linux中三种SCSI target的介绍之LIO](https://www.cnblogs.com/pipci/p/11618671.html)
[targetcli](https://github.com/Datera/targetcli)
[iscsi target 研究](https://www.cnblogs.com/chris-cp/p/8136511.html)
[rtslib-fb](https://github.com/open-iscsi/rtslib-fb)
