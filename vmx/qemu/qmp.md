# qmp

[QEMU QMP Reference Manual](https://www.qemu.org/docs/master/interop/qemu-qmp-ref.html)
[QEMU QMP Reference Manual]
[qmp-wiki](https://wiki.qemu.org/Documentation/QMP)
[QEMU Machine Protocol Specification](https://www.qemu.org/docs/master/interop/qmp-spec.html)
[go-qemu](https://github.com/digitalocean/go-qemu)
[qemu添加hmp和qmp接口](https://blog.csdn.net/daxiatou/article/details/100152212)
[基于QMP实现对qemu虚拟机进行交互](https://blog.csdn.net/weixin_40836557/article/details/135959048)
[Dirty Bitmaps and Incremental Backup](https://www.qemu.org/docs/master/interop/bitmaps.html)

## 基于QMP实现对qemu虚拟机进行交互

### QMP语法

不带参数的指令

```json
{"execute" : "XXX"}
```

带参数的指令

```JSON
{"execute" : "XXX", "arguments" : { ... }}
```

### 单独使用qemu，启用QMP

```text
注：
/usr/libexec/qemu-kvm -> /usr/bin/kvm -> qemu-system-x86_64
/usr/bin/kvm -> qemu-system-x86_64
```

```shell
# 注：在启动时新增参数（-qmp tcp:127.0.0.1:4444,server,nowait）
# qemu monitor采用tcp方式，监听在127.0.0.1上，端口为4444
qemu-system-x86_64 -qmp tcp:127.0.0.1:4444,server,nowait \
    -drive file=/var/lib/libvirt/images/ubuntu20.04_1.qcow2

# qemu monitor采用unix socket，socket文件生成于/opt/qmp.socket
qemu-system-x86_64 -qmp unix:/opt/qmp.socket,server,nowait

# 1. tcp可以通过telnet进行连接
telnet 127.0.0.1 4444

# 2. unix socket可以通过nc -U进行连接，方法如下
nc -U qmp.socket

# 3. 除了 telnet、nc从外部连接，还可以在qemu启动时候进入一个交互的cli界面
# 使用hmp(human monitor protocol)
qemu-system-x86_64 -qmp tcp:127.0.0.1:4444,server,nowait -monitor stdio
# 使用hmp不需要输入类似qmp的{"execute" : "qmp_capabilities"}
# 直接输入info回车，可以看到所有查询类的指令使用方法
# 直接输入info回车，可以看到所有查询类的指令使用方法
(qemu) info

# 查看块设备
(qemu) info block

# 在线增加磁盘
(qemu) drive_add 0 file=/opt/data.qcow2,format=qcow2,id=drive-virtio-disk1,if=none
(qemu) device_add virtio-blk-pci,scsi=off,drive=drive-virtio-disk1

```

### qmp 示例

先输入

```json
{"execute" : "qmp_capabilities"}
```

查看支持哪些qmp指令

```json
{"execute": "query-commands"}
```

虚拟机状态

```json
{"execute": "query-status"}
```

虚拟机暂停

```json
{"execute": "stop"}
```

磁盘查看

```json
{"execute": "query-block"}
```

磁盘在线插入

```json
{
    "execute": "blockdev-add",
    "arguments": {
        "driver": "qcow2",
        "node-name": "drive-virtio-disk1",
        "file": {
            "driver": "file",
            "filename": "/opt/data.qcow2"
        }
    }
}

{
    "execute": "device_add",
    "arguments": {
        "driver": "virtio-blk-pci",
        "drive": "drive-virtio-disk1"
    }
}
```

### 通过libvirt启动qemu，启用QMP

```shell
# 1. xml里不做任何额外配置，默认就会启用QMP，但通过这种方法启用的QMP，只能
# 通过libvirt接口(比如virsh命令或libvirt api)来进行QMP指令的输入，而不能通过telnet、nc之类的，
# 因为默认启用的QMP，只会生成unix socket(位于/var/lib/libvirt/qemu/domain-xx-DOMAIN/monitor.sock)，
# nc -U /var/lib/libvirt/qemu/domain-1-ub2004_1/monitor.sock
# 而该socket被libvirtd始终连接占用着。此时通过ps aux命令可以看到qemu进程参数，和之前有点不太一样，不是-qmp，而是如下
# -chardev socket,id=charmonitor,fd=36,server,nowait \
# -mon chardev=charmonitor,id=monitor,mode=control

virsh qemu-monitor-command ub2004_1 --pretty '{ "execute": "query-block" }'

# 2. 在xml里额外增加2段配置，注意看下面这个xml的第一行，需要增加一个xmlns:qemu，
# 另外在<domain>里增加qemu:command
```

```xml
<domain type='kvm' xmlns:qemu='http://libvirt.org/schemas/domain/qemu/1.0'>
  ...
  <devices>
    ...
  </devices>
  <qemu:commandline>
    <qemu:arg value='-qmp'/>
    <qemu:arg value='unix:/tmp/qmp-sock,server,nowait'/>
  </qemu:commandline>
</domain>
```

```shell
# 接着通过libvirt启动qemu(比如virsh start xxx)，就创建了2个qmp通道，一个是libvirt默认创建
# 的，可以依然使用libvirt接口来执行QMP指令，另一个就是自定义的qmp，可以通过上面提到的nc来使用
nc -U /tmp/qmp-sock

# libvirt也支持hmp：
virsh qemu-monitor-command ub2004_1 --hmp 'info block'

```

### qemu-guest-agent(qemu-ga)

```shell
# 通过qmp还可以对虚拟机内的操作系统进行RPC操作，其原理是：
# 1. 先在xml里配置channel段，然后启动虚拟机，会在宿主机上生成一个unix socket，同时在vm里生成
# 一个字符设备，生成的unix socket和字符设备可以理解为一个channel隧道的两端

# 2. 虚拟机里要启动qemu-guest-agent守护进程，该守护进程会监听字符设备

# 3. 然后可以在宿主机上将虚拟机里的qemu-guest-agent所支持的RPC指令经过channel发送到虚拟机里，虚
# 拟机里的qemu-guest-agent从字符设备收到数据后，执行指令，比如读写文件、修改密码等等

# 若要使用qemu-guest-agent需要满足以下条件
# 1. xml里配置channel，范例：

```

```xml
<domain type='kvm'>
  ...
  <devices>
    ...
    <channel type='unix'>
      <source mode='bind' path='/tmp/channel.sock'/>
      <target type='virtio' name='org.qemu.guest_agent.0'/>
    </channel>
  </devices>
</domain>
```

```
# 注意，path可以自定义，但name需要保持org.qemu.guest_agent.0，因为这会影响虚拟机里字符设备的文件
# 名，而虚拟机里的qemu-guest-agent服务默认读取的是对应org.qemu.guest_agent.0的字符设备，如果改了
# name，那么qemu-guest-agent的配置文件也要跟着改，改成对应name的路径

# 2. 虚拟机内的操作系统内核需要支持(linux、windows均支持)

3. 虚拟机里要安装并启动qemu-ga的服务(比如centos可以yum install qemu-ga && systemctl start qemu-guest-agent，windows通过导入virtio-win的iso，该iso里包含有qemu-ga程序)
当按照上述配置好后，可以在宿主机上进行RPC操作

# 测试虚拟机里的qemu-guest-agent是否可用
virsh qemu-agent-command DOMAIN --pretty '{ "execute": "guest-ping" }'

# 查看支持的qemu-guest-agent指令
virsh qemu-agent-command DOMAIN --pretty '{ "execute": "guest-info" }'

# 获得网卡信息
virsh qemu-agent-command DOMAIN --pretty '{ "execute": "guest-network-get-interfaces" }'

# 执行命令，这是异步的，第一步会返回一个pid，假设为797，在第二步需要带上这个pid
virsh qemu-agent-command DOMAIN --pretty '{ "execute": "guest-exec", "arguments": { "path": "ip", "arg": [ "addr", "list" ], "capture-output": true } }'
virsh qemu-agent-command DOMAIN --pretty '{ "execute": "guest-exec-status", "arguments": { "pid": 797 } }'

qemu-guest-agent不支持hmp调用

虚拟机里的/etc/sysconfig/qemu-ga内容中的BLACKLIST_RPC参数可以配置禁止哪些指令

```
