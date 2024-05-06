# 查看磁盘
export VIR_DOMAIN_EXTERNAL="ubuntu.1804.5G-external"
virsh domblklist ${VIR_DOMAIN_EXTERNAL}

root@infokist:/var/lib/libvirt/images# virsh domblklist ${VIR_DOMAIN_EXTERNAL}
Target     Source
------------------------------------------------
hda        /var/lib/libvirt/images/ubuntu.1804.5G-clone1-1.qcow2
hdb        -

# 查看快照链
qemu-img info --backing-chain /var/lib/libvirt/images/ubuntu.1804.5G-clone1-1.qcow2

root@infokist:/var/lib/libvirt/images# qemu-img info --backing-chain /var/lib/libvirt/images/ubuntu.1804.5G-clone1-1.qcow2
image: /var/lib/libvirt/images/ubuntu.1804.5G-clone1-1.qcow2
file format: qcow2
virtual size: 5.0G (5368709120 bytes)
disk size: 4.0G
cluster_size: 65536
Format specific information:
    compat: 1.1
    lazy refcounts: true
    refcount bits: 16
    corrupt: false

# 创建外置快照 snapshot1
# 在 domain 中新建文件
echo hello1 > snapshot1.txt
virsh snapshot-create-as --domain ${VIR_DOMAIN_EXTERNAL} --name ${VIR_DOMAIN_EXTERNAL}-snapshot1 \
    --disk-only \
    --diskspec hda,snapshot=external,file=/var/lib/libvirt/images/${VIR_DOMAIN_EXTERNAL}-snapshot1.qcow2 \
    --atomic

# 查看 domain disk
...
<disk type='file' device='disk'>
    <driver name='qemu' type='qcow2'/>
    <source file='/var/lib/libvirt/images/ubuntu.1804.5G-external-snapshot1.qcow2'/>
    <backingStore type='file' index='1'>
        <format type='qcow2'/>
        <source file='/var/lib/libvirt/images/ubuntu.1804.5G-clone1-1.qcow2'/>
        <backingStore/></backingStore>
    <target dev='hda' bus='ide'/>
    <alias name='ide0-0-0'/>
    <address type='drive' controller='0' bus='0' target='0' unit='0'/>
</disk>
...
# 查看磁盘
root@infokist:/var/lib/libvirt/images# virsh domblklist ${VIR_DOMAIN_EXTERNAL}
Target     Source
------------------------------------------------
hda        /var/lib/libvirt/images/ubuntu.1804.5G-external-snapshot1.qcow2
hdb        -


# 创建外置快照 snapshot2
# 在 domain 中新建文件
echo hello2 > snapshot2.txt

virsh snapshot-create-as --domain ${VIR_DOMAIN_EXTERNAL} --name ${VIR_DOMAIN_EXTERNAL}-snapshot2 \
    --disk-only \
    --diskspec hda,snapshot=external,file=/var/lib/libvirt/images/${VIR_DOMAIN_EXTERNAL}-snapshot2.qcow2 \
    --atomic

# 查看 domain disk：
...
<disk type='file' device='disk'>
    <driver name='qemu' type='qcow2'/>
    <source file='/var/lib/libvirt/images/ubuntu.1804.5G-external-snapshot2.qcow2'/>
    <backingStore type='file' index='1'>
        <format type='qcow2'/>
        <source file='/var/lib/libvirt/images/ubuntu.1804.5G-external-snapshot1.qcow2'/>
        <backingStore type='file' index='2'>
            <format type='qcow2'/>
            <source file='/var/lib/libvirt/images/ubuntu.1804.5G-clone1-1.qcow2'/>
            <backingStore/></backingStore>
    </backingStore>
    <target dev='hda' bus='ide'/>
    <alias name='ide0-0-0'/>
    <address type='drive' controller='0' bus='0' target='0' unit='0'/>
</disk>
...


# 创建外置快照 snapshot3
# 在 domain 中新建文件
echo hello3 > snapshot3.txt
virsh snapshot-create-as --domain ${VIR_DOMAIN_EXTERNAL} --name ${VIR_DOMAIN_EXTERNAL}-snapshot3 \
    --disk-only \
    --diskspec hda,snapshot=external,file=/var/lib/libvirt/images/${VIR_DOMAIN_EXTERNAL}-snapshot3.qcow2 \
    --atomic


# 查看 domain disk：
...
<disk type='file' device='disk'>
    <driver name='qemu' type='qcow2'/>
    <source file='/var/lib/libvirt/images/ubuntu.1804.5G-external-snapshot3.qcow2'/>
    <backingStore type='file' index='1'>
        <format type='qcow2'/>
        <source file='/var/lib/libvirt/images/ubuntu.1804.5G-external-snapshot2.qcow2'/>
        <backingStore type='file' index='2'>
            <format type='qcow2'/>
            <source file='/var/lib/libvirt/images/ubuntu.1804.5G-external-snapshot1.qcow2'/>
            <backingStore type='file' index='3'>
                <format type='qcow2'/>
                <source file='/var/lib/libvirt/images/ubuntu.1804.5G-clone1-1.qcow2'/>
                <backingStore/></backingStore>
        </backingStore>
    </backingStore>
    <target dev='hda' bus='ide'/>
    <alias name='ide0-0-0'/>
    <address type='drive' controller='0' bus='0' target='0' unit='0'/>
</disk>
...

# 查看快照链--合并前
root@infokist:/var/lib/libvirt/images# qemu-img info --backing-chain  /var/lib/libvirt/images/ubuntu.1804.5G-external-snapshot3.qcow2
image: /var/lib/libvirt/images/ubuntu.1804.5G-external-snapshot3.qcow2
file format: qcow2
virtual size: 5.0G (5368709120 bytes)
disk size: 2.9M
cluster_size: 65536
backing file: /var/lib/libvirt/images/ubuntu.1804.5G-external-snapshot2.qcow2
backing file format: qcow2
Format specific information:
    compat: 1.1
    lazy refcounts: false
    refcount bits: 16
    corrupt: false
...
image: /var/lib/libvirt/images/ubuntu.1804.5G-clone1-1.qcow2
file format: qcow2
virtual size: 5.0G (5368709120 bytes)
disk size: 2.6G
cluster_size: 65536
Format specific information:
    compat: 1.1
    lazy refcounts: true
    refcount bits: 16
    corrupt: false

# 查看大小
root@infokist:/var/lib/libvirt/images# du -sh  /var/lib/libvirt/images/ubuntu.1804.5G-clone1-1.qcow2
2.6G    /var/lib/libvirt/images/ubuntu.1804.5G-clone1-1.qcow2
root@infokist:/var/lib/libvirt/images# du -sh /var/lib/libvirt/images/ubuntu.1804.5G-external-snapshot1.qcow2
1.4M    /var/lib/libvirt/images/ubuntu.1804.5G-external-snapshot1.qcow2
root@infokist:/var/lib/libvirt/images# du -sh /var/lib/libvirt/images/ubuntu.1804.5G-external-snapshot2.qcow2
644K    /var/lib/libvirt/images/ubuntu.1804.5G-external-snapshot2.qcow2
root@infokist:/var/lib/libvirt/images# du -sh /var/lib/libvirt/images/ubuntu.1804.5G-external-snapshot3.qcow2
900K    /var/lib/libvirt/images/ubuntu.1804.5G-external-snapshot3.qcow2
root@infokist:/var/lib/libvirt/images#


# 查看快照信息
root@infokist:/var/lib/libvirt/images# virsh snapshot-info ${VIR_DOMAIN_EXTERNAL} ${VIR_DOMAIN_EXTERNAL}-snapshot3
Name:           ubuntu.1804.5G-external-snapshot3
Domain:         ubuntu.1804.5G-external
Current:        yes
State:          disk-snapshot
Location:       external
Parent:         ubuntu.1804.5G-external-snapshot2
Children:       0
Descendants:    0
Metadata:       yes
--
root@infokist:/var/lib/libvirt/images# virsh snapshot-info ${VIR_DOMAIN_EXTERNAL} ${VIR_DOMAIN_EXTERNAL}-snapshot2
Name:           ubuntu.1804.5G-external-snapshot2
Domain:         ubuntu.1804.5G-external
Current:        no
State:          disk-snapshot
Location:       external
Parent:         ubuntu.1804.5G-external-snapshot1
Children:       1
Descendants:    1
Metadata:       yes
--
root@infokist:/var/lib/libvirt/images# virsh snapshot-info ${VIR_DOMAIN_EXTERNAL} ${VIR_DOMAIN_EXTERNAL}-snapshot1
Name:           ubuntu.1804.5G-external-snapshot1
Domain:         ubuntu.1804.5G-external
Current:        no
State:          disk-snapshot
Location:       external
Parent:         -
Children:       1
Descendants:    2
Metadata:       yes

# 查看快照文件
root@infokist:/var/lib/libvirt/images# ll /var/lib/libvirt/qemu/snapshot/ubuntu.1804.5G-external
total 28
drwxr-xr-x  2 root         root  157 Oct 28 18:12 ./
drwxr-xr-x 23 libvirt-qemu kvm  4096 Oct 28 18:02 ../
-rw-------  1 root         root 4686 Oct 28 18:07 ubuntu.1804.5G-external-snapshot1.xml
-rw-------  1 root         root 4770 Oct 28 18:12 ubuntu.1804.5G-external-snapshot2.xml
-rw-------  1 root         root 4770 Oct 28 18:12 ubuntu.1804.5G-external-snapshot3.xml

# 合并快照链
virsh blockcommit --domain ${VIR_DOMAIN_EXTERNAL} \
    --path hda \
    --base  /var/lib/libvirt/images/${VIR_DOMAIN_EXTERNAL}-snapshot1.qcow2 \
    --top   /var/lib/libvirt/images/${VIR_DOMAIN_EXTERNAL}-snapshot3.qcow2 \
    --active \
    --wait \
    --delete \
    --verbose

virsh blockcommit --domain ${VIR_DOMAIN_EXTERNAL} \
    --path hda \
    --base  /var/lib/libvirt/images/ubuntu.1804.5G-clone1-1.qcow2 \
    --top   /var/lib/libvirt/images/${VIR_DOMAIN_EXTERNAL}-snapshot3.qcow2 \
    --pivot \
    --wait \
    --verbose

# 为带[--active]的合并快照锚点（执行后磁盘就合并也可以在 active 那里直接带上 --pivot）
virsh blockjob --domain ${VIR_DOMAIN_EXTERNAL} hda --pivot

# 查看磁盘--（可以看到快照已经合并至 base ）
root@infokist:~# virsh domblklist ${VIR_DOMAIN_EXTERNAL}
Target     Source
------------------------------------------------
hda        /var/lib/libvirt/images/ubuntu.1804.5G-clone1-1.qcow2
hdb        -



# 查看 domain disk
<disk type='file' device='disk'>
    <driver name='qemu' type='qcow2'/>
    <source file='/var/lib/libvirt/images/ubuntu.1804.5G-external-snapshot3.qcow2'/>
    <backingStore type='file' index='1'>
        <format type='qcow2'/>
        <source file='/var/lib/libvirt/images/ubuntu.1804.5G-external-snapshot2.qcow2'/>
        <backingStore type='file' index='2'>
            <format type='qcow2'/>
            <source file='/var/lib/libvirt/images/ubuntu.1804.5G-external-snapshot1.qcow2'/>
            <backingStore type='file' index='3'>
                <format type='qcow2'/>
                <source file='/var/lib/libvirt/images/ubuntu.1804.5G-clone1-1.qcow2'/>
                <backingStore/></backingStore>
        </backingStore>
    </backingStore>
    <mirror type='file' job='active-commit' ready='yes'>
        <format type='qcow2'/>
        <source file='/var/lib/libvirt/images/ubuntu.1804.5G-external-snapshot1.qcow2'/>
    </mirror>
    <target dev='hda' bus='ide'/>
    <alias name='ide0-0-0'/>
    <address type='drive' controller='0' bus='0' target='0' unit='0'/>
</disk>
# 查看快照文件
root@infokist:/var/lib/libvirt/images# ll /var/lib/libvirt/qemu/snapshot/ubuntu.1804.5G-external
total 28
drwxr-xr-x  2 root         root  157 Oct 28 18:12 ./
drwxr-xr-x 23 libvirt-qemu kvm  4096 Oct 28 18:02 ../
-rw-------  1 root         root 4686 Oct 28 18:07 ubuntu.1804.5G-external-snapshot1.xml
-rw-------  1 root         root 4770 Oct 28 18:12 ubuntu.1804.5G-external-snapshot2.xml
-rw-------  1 root         root 4770 Oct 28 18:12 ubuntu.1804.5G-external-snapshot3.xml

# 删除快照
virsh snapshot-delete --domain ${VIR_DOMAIN_EXTERNAL}  ${VIR_DOMAIN_EXTERNAL}-snapshot1 --metadata
virsh snapshot-delete --domain ${VIR_DOMAIN_EXTERNAL}  ${VIR_DOMAIN_EXTERNAL}-snapshot2 --metadata
virsh snapshot-delete --domain ${VIR_DOMAIN_EXTERNAL}  ${VIR_DOMAIN_EXTERNAL}-snapshot3 --metadata

# 查看快照文件
root@infokist:/var/lib/libvirt/images# ll /var/lib/libvirt/qemu/snapshot/ubuntu.1804.5G-external
total 4
drwxr-xr-x  2 root         root   10 Oct 28 18:39 ./
drwxr-xr-x 23 libvirt-qemu kvm  4096 Oct 28 18:02 ../
root@infokist:/var/lib/libvirt/images#


# 查看快照链
qemu-img info --backing-chain /var/lib/libvirt/images/ubuntu.1804.5G-external-snapshot3.qcow2
# 查看 domain 信息
virsh dumpxml ${VIR_DOMAIN_EXTERNAL}
# 查看快照
virsh snapshot-list ${VIR_DOMAIN_EXTERNAL}
