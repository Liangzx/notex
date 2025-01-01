# debugfs

## 恢复删除的文件

## 准备

```shell
# 1. 添加一块磁盘
# 2. 格式化
mkfs -t ext4 /dev/vdb
# 3. 新建目录作为挂载点
mkdir -p /data
# 4. 挂载
mount /dev/vdb /data
# 5. 新建文件然后删除
echo hello > hello.txt
# dd if=/dev/urandom of=data.bin bs=1M count=1
```

## 恢复记录

```shell
# 1. 查看文件所在分区
df ./
# 2. 使用debugfs打开
debugfs /dev/mapper/ubuntu--vg-ubuntu--lv
# 2. 列出删除的文件 <xxx> 为inode
debugfs:  ls -d /root
# 3. 列出文件信息注意带上`<>`, 注意这个找到的block不对
debugfs:  logdump -i <132357>
# 4. 将块写入文件
sudo dd if=/dev/mapper/ubuntu--vg-ubuntu--lv of=/root/data_bak.bin bs=4k count=2 skip=2175528
sudo dd if=/dev/vdb of=/root/hello.txt bs=4k count=1 skip=34304
# truncate -s 4097 /root/data_bak.bin

# debugfs -R "blocks /root/data.bin" /dev/mapper/ubuntu--vg-ubuntu--lv
# debugfs -R "blocks /data/hello.txt" /dev/vdb
```

```shell
sudo umount /data
sudo debugfs -w /dev/vdb

```

## refs

[linux内核中的debugfs](https://zhuanlan.zhihu.com/p/651692040)
[debugfs](https://wker.com/linux-command/debugfs.html)
[Linux文件数据恢复 (XFS & EXT4)](https://www.cnblogs.com/Alwayslearn/p/16719473.html)
