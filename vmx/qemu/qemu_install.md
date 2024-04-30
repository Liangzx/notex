# qemu install ub2204

## refs
[QEMU源码编译安装](https://blog.csdn.net/wxh0000mm/article/details/124041823)
[qemu-kvm](https://www.cnblogs.com/dream397/p/13926042.html)

## install 安装

```shell
sudo apt install qemu
sudo apt install qemu-user-static
```

## 可能的依赖

```shell
sudo apt install gcc
sudo apt install make
sudo apt install libglib2.0-dev
sudo apt install libpixman-1-dev
sudo apt install ninja-build

```

## 源码安装

```shell
# 1. 下载源码
git clone https://gitlab.com/qemu-project/qemu.git -b v6.2.0

# 2. build
# 2.1 更新子项目
cd qemu
git submodule init
git submodule update --recursive

# 2.2 构建目录
mkdir build
cd build

# 2.3 构建安装
../configure --enable-debug
make
make install

# 3. 检查版本
qemu-system-x86_64 --version

# 卸载
sudo rm /usr/local/bin/qemu*
sudo rm -rf /usr/local/lib/qemu/
sudo rm -rf /usr/local/share/qemu/

```
