# Ceph

## 部署

```shell
# ------------部署ceph----------
# 使用 cephadm 部署
# 1. 准备环境
sudo apt-get update && sudo apt-get install -y software-properties-common
# 2. 添加 Ceph 源
wget -q -O- 'https://download.ceph.com/keys/release.asc' | sudo apt-key add -
echo deb https://download.ceph.com/debian-quincy/ $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/ceph.list
sudo apt-get update
# 3. 安装 cephadm
sudo apt-get install cephadm
# 4. 启动 Ceph 集群
# 这个命令会自动完成以下任务：
#   创建一个新的 Ceph 集群。
#   在本地机器上部署 Monitor (MON) 和 Manager (MGR)。
#   生成管理员密钥环，并将其保存到 /etc/ceph/ceph.client.admin.keyring。
#   将配置文件保存到 /etc/ceph/ceph.conf
# https://docs.ceph.com/en/reef/cephadm/install/#cephadm-deploying-new-cluster
sudo cephadm bootstrap --single-host-defaults --mon-ip 172.20.30.176
# 5. 添加 OSD
# 如果你想添加本地磁盘作为 Object Storage Daemon (OSD)，可以使用以下命令
sudo ceph orch apply osd --all-available-devices
# 或者手动指定设备 ???
# https://docs.ceph.com/en/latest/cephadm/services/osd/#deploy-osds
ceph orch daemon add osd dingjia:/dev/vdc
# 6. 验证部署
# 验证集群状态和 OSD 状态
sudo ceph status
sudo ceph osd tree

#---------------配置ceph---------
# 1. 创建存储池
# 创建一个名为 'my_pool' 的存储池，设置 PG 数量为 128
sudo ceph osd pool create my_pool 16
# -----更新操作------
## 查看当前的 PG 和 PGP 数量
#ceph osd pool get my_pool pg_num
#ceph osd pool get my_pool pgp_num
## 设置新的 PG 和 PGP 数量为 128
#ceph osd pool set my_pool pg_num 128
#ceph osd pool set my_pool pgp_num 128
## 监控重新平衡进度
#ceph health detail
#ceph pg stat

# 验证更新后的 PG 和 PGP 数量
ceph osd pool get my_pool pg_num
ceph osd pool get my_pool pgp_num
# 动态设置默认池大小为 1
ceph osd pool set my_pool size 1
# 或者设置全局默认值
ceph config set osd_pool_default_size 1
# 2. 配置 CRUSH 地图
# 查看当前的 CRUSH 地图
sudo ceph osd getcrushmap -o crushmap.bin
sudo crushtool -d crushmap.bin -o crushmap.txt

# ----------启用应用程序--------
# 1. 列出所有存储池
ceph osd lspools
# 2. 启用 rbd rgw cephfs
ceph osd pool application enable my_pool rbd
ceph osd pool application enable my_pool rgw
ceph osd pool application enable my_pool cephfs
# 3. 验证应用程序状态
ceph osd pool application get my_pool

# 4. web ui https://172.20.30.176:8443/#/login?returnUrl=%2Fdashboard  admin/Dingjia@123

#--------------使用 Ceph-----------
# 对象存储 (RADOS)
# Ceph 提供了一个原生的对象存储接口 RADOS，可以直接通过 API 访问
# 列出所有存储池
rados lspools
# 向存储池中写入对象
echo "Hello, Ceph!" | rados -p my_pool put my_object -
# 从存储池中读取对象
rados -p my_pool get my_object -

# 块存储 (RBD)
# 创建一个 RBD 图像
rbd create my_image --size 1G --pool my_pool
# 映射 RBD 图像到本地设备
sudo rbd map my_image --pool my_pool
# 格式化并挂载 RBD 图像
sudo mkfs.ext4 /dev/rbd/my_pool/my_image
sudo mount /dev/rbd/my_pool/my_image /mnt/rbd0
echo hello > /mnt/rbd0/hello.txt
# 取消映射 RBD 图像
sudo umount /mnt/rbd0
sudo rbd unmap /dev/rbd/my_pool/my_image
#-----增备例子----
# 1. 创建 RBD 图像的快照
rbd snap create my_image@mysnapshot --pool my_pool
# 比较 my_image 从 mysnapshot 到当前状态的差异
rbd diff my_pool/my_image --from-snap mysnapshot --format json
# 2. 变更数据
echo world > /mnt/rbd0/hello.txt
# 3. 再次快照
rbd snap create my_image@mysnapshot2 --pool my_pool
# 4. 对比快照差异
# 比较 my_image 在 snap1 和 snap2 之间的差异
rbd diff my_pool/my_image --from-snap mysnapshot --snap mysnapshot2 --format json
# [{"offset":134750208,"length":1568768,"exists":"true"},{"offset":536936448,"length":24576,"exists":"true"}]
#---------快照一致性组--------TODO:
# 创建一致性组 https://docs.ceph.com/en/latest/man/8/rbd/
# 创建一致性组 my_group
rbd group create my_pool/my_group
# 将 image1 和 image2 添加到 my_group
# group image add group-spec image-spec
rbd group image add my_pool/my_group my_pool/my_image
rbd group image add my_pool/my_group my_pool/my_image2
# 为 my_group 创建名为 snap1 的快照
rbd group snap create my_pool/my_group@snap1
# 列出 my_group 的快照
rbd group snap ls my_pool/my_group
# 删除 snap1 快照
rbd group snap remove my_pool/my_group@snap1
# 移除 image1 从 my_group
rbd group remove my_pool/my_group my_pool/my_image
# 删除 my_group
rbd group remove my_pool/my_group

#---------卸载 Ceph 的步骤---------
# 1. 停止 Ceph 服务
# 停止所有 Ceph 服务
sudo systemctl stop ceph-*.service
# 使用 cephadm 停止所有服务 sudo cephadm shell -- ceph orch host rm <hostname>
sudo cephadm shell -- ceph orch host rm dingjia
# 2. 移除存储池和数据
# 列出所有存储池
ceph osd lspools
# 删除存储池（替换 <pool_name> 为实际的存储池名称）
ceph osd pool delete my_pool my_pool --yes-i-really-really-mean-it
# 3. 清理 OSD 数据
# 列出所有 OSD
ceph-volume lvm list
# 清理特定的 OSD（替换 <osd_id> 为实际的 OSD ID）
ceph-volume lvm zap --osd-id <osd_id>
# 或者清理所有 OSD（请谨慎使用）
for osd_id in $(ceph osd ls); do
    ceph-volume lvm zap --osd-id $osd_id
done
# 4. 移除 Ceph 配置文件 https://blog.csdn.net/gengduc/article/details/133895789
# 移除配置文件
sudo rm -rf /etc/ceph/*
# 移除 Ceph 数据目录
sudo rm -rf /var/lib/ceph/*
# 主要是这四个目录下的文件
rm -rf /etc/ceph/*
rm -rf /var/lib/ceph/*
rm -rf /var/log/ceph/*
rm -rf /var/run/ceph/*

# 5. 移除 Ceph 包
# 移除 Ceph 软件包
sudo apt-get purge ceph* ceph-common ceph-base ceph-osd ceph-mon ceph-mgr ceph-mds radosgw python3-ceph*
# 清理残留依赖
sudo apt-get autoremove
# 6. 清理 CRUSH 地图和其他元数据(可选)
# 7. 重启系统（可选）
# 8. 删除lv
sudo lvdisplay
# lvremove <vgname>/<lvname>
lvremove ceph-f8012d3b-b17d-4915-8d60-28412e6c3158/osd-block-9af430e4-9649-4b65-9ad7-c437d1b791d7
# 9. 清除磁盘签名
sudo wipefs -a /dev/vdc
```

## ceph组件介绍


## refs

[docs](https://docs.ceph.com/en/quincy/)
[github](https://github.com/ceph/ceph)
[kernel_awsome_feature](https://github.com/0voice/kernel_awsome_feature)
[基本概念、原理及架构 - hukey - 博客园 (cnblogs.com)](https://www.cnblogs.com/hukey/p/12588436.html)
[玩转 Ceph 的正确姿势 - 大CC - 博客园 (cnblogs.com)](https://www.cnblogs.com/me115/p/6366374.html)
[ceph快照原理_天健胡马灵越鸟的博客-CSDN博客](https://blog.csdn.net/pansaky/article/details/84143641)
[【ceph】ceph OSD状态及常用命令](https://blog.51cto.com/liangchaoxi/5223629)
[李航：分布式存储 Ceph 介绍及原理架构分享](https://juejin.cn/post/6844903859945488397)
[(48条消息) Ceph学习——Librados与Osdc实现源码解析_SEU_PAN的博客-CSDN博客](https://blog.csdn.net/CSND_PAN/article/details/78707756)
[《 大话 Ceph 》 之 CRUSH 那点事儿](https://cloud.tencent.com/developer/article/1006315)
[《 大话 Ceph 》 之 PG 那点事儿](https://cloud.tencent.com/developer/article/1006292)
[《大话 Ceph》 之 RBD 那点事儿](https://cloud.tencent.com/developer/article/1006283)
[Ceph RBD 的实现原理与常规操作 - 云物互联 - 博客园 (cnblogs.com)](https://www.cnblogs.com/jmilkfan-fanguiju/p/11825071.html#_2)
[Ubuntu22.04LTS基于cephadm快速部署Ceph Reef(18.2.X)集群](https://developer.aliyun.com/article/1604943)
[一文掌握Cephadm部署Ceph存储集群](https://blog.csdn.net/u013522701/article/details/143142428)
