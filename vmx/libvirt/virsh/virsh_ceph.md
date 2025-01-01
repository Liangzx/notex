# 虚拟机配置 ceph 存储

要为虚拟机配置Ceph存储，你需要完成以下步骤：

1. **安装Ceph客户端**：在虚拟机宿主机上安装Ceph客户端工具。
2. **配置Ceph存储池**：在Ceph集群中创建一个存储池。
3. **配置libvirt**：在虚拟机的XML配置文件中添加Ceph存储卷。

### 步骤1：安装Ceph客户端
在虚拟机宿主机上安装Ceph客户端工具。

```sh
sudo apt-get install ceph-common
```

### 步骤2：配置Ceph存储池
在Ceph集群中创建一个存储池。

```sh
ceph osd pool create <pool-name> <pg-num>
```

例如：

```sh
ceph osd pool create vmpool 128
```

### 步骤3：配置libvirt
在虚拟机的XML配置文件中添加Ceph存储卷。

1. **获取Ceph集群的密钥**：
   ```sh
   sudo cat /etc/ceph/ceph.client.admin.keyring
   ```

2. **编辑虚拟机的XML配置文件**：
   ```sh
   virsh edit <vm-name>
   ```

3. **在XML文件中添加Ceph存储卷**：

```xml
<disk type='network' device='disk'>
  <driver name='qemu' type='raw'/>
  <auth username='admin'>
    <secret type='ceph' uuid='<secret-uuid>'/>
  </auth>
  <source protocol='rbd' name='<pool-name>/<image-name>'>
    <host name='<ceph-mon-host>' port='6789'/>
  </source>
  <target dev='vda' bus='virtio'/>
</disk>
```

例如：

```xml
<disk type='network' device='disk'>
  <driver name='qemu' type='raw'/>
  <auth username='admin'>
    <secret type='ceph' uuid='12345678-1234-1234-1234-123456789abc'/>
  </auth>
  <source protocol='rbd' name='vmpool/vmimage'>
    <host name='ceph-mon1' port='6789'/>
  </source>
  <target dev='vda' bus='virtio'/>
</disk>
```

4. **创建libvirt secret**：
   ```sh
   virsh secret-define --file secret.xml
   virsh secret-set-value --secret <secret-uuid> --base64 $(cat /etc/ceph/ceph.client.admin.keyring | grep key | awk '{print $3}')
   ```

`secret.xml` 文件内容示例：

```xml
<secret ephemeral='no' private='no'>
  <uuid>12345678-1234-1234-1234-123456789abc</uuid>
  <usage type='ceph'>
    <name>client.admin secret</name>
  </usage>
</secret>
```

### 总结
通过以上步骤，你可以为虚拟机配置Ceph存储。首先安装Ceph客户端工具，然后在Ceph集群中创建存储池，最后在虚拟机的XML配置文件中添加Ceph存储卷，并配置libvirt secret。这样，虚拟机就可以使用Ceph存储了。
