# OverlayFS 工作原理

```shell
# OverlayFS 使用三个主要层：
# Lower Layer（下层）：只读层，包含了基础数据。可以包含多个只读层，形成一个叠加的视图。
# Upper Layer（上层）：可写层，所有的更改（如创建、修改文件）都发生在这个层。
# Merged Layer（合并层）：提供给用户的最终文件系统视图，它将上层和下层合并在一起。
# 当文件被读取时，系统首先从上层查找文件。如果文件存在，就使用上层的文件；如果文件不存在，则查找下层。当写入操作发生时，
# OverlayFS 将在上层创建或修改文件，原下层的文件不会被改变。

# 使用 OverlayFS 的基本步骤
# 1. 检查系统对 OverlayFS 的支持
lsmod | grep overlay

# 2. 创建 OverlayFS 所需的目录结构
# 我们需要创建以下三个目录：
# Lower（下层）：存储只读文件
# Upper（上层）：存储可写文件
# Work（工作层）：OverlayFS 用于管理合并的临时数据
# Merged（合并层）：提供最终合并的视图
mkdir -p /tmp/overlay/lower
mkdir -p /tmp/overlay/upper
mkdir -p /tmp/overlay/work
mkdir -p /tmp/overlay/merged

# 3. 准备 Lower Layer 内容
# 3.1 向 lower 目录中添加一些测试文件
echo "This is lower layer" > /tmp/overlay/lower/lower.txt

# 4. 挂载 OverlayFS
# lowerdir：指向只读层的目录。
# upperdir：指向可写层的目录。
# workdir：用于 OverlayFS 的临时数据目录。
# /tmp/overlay/merged：挂载点，提供合并后的视图。
sudo mount -t overlay overlay -o lowerdir=/tmp/overlay/lower,upperdir=/tmp/overlay/upper,workdir=/tmp/overlay/work /tmp/overlay/merged

# 5. 验证挂载结果
# 应该看到 lower.txt 文件。
ls /tmp/overlay/merged

# 6. 修改 OverlayFS 的内容
# 在合并层创建一个新文件：
echo "This is a new file in merged layer" > /tmp/overlay/merged/upper.txt

# 可以看到 upper.txt 文件，而 lower 目录未发生改变。
ls /tmp/overlay/upper

# 多个 Lower Layer 的堆叠实现
# 实现多个 Lower Layer 的步骤
# 1. 准备 OverlayFS 所需的目录结构
# 创建多个 Lower Layer 目录以及 Upper Layer、Work Layer 和 Merged Layer：
# 创建 Lower Layer 1
mkdir -p /tmp/overlay/lower1
echo "This is lower layer 1" > /tmp/overlay/lower1/file1.txt

# 创建 Lower Layer 2
mkdir -p /tmp/overlay/lower2
echo "This is lower layer 2" > /tmp/overlay/lower2/file2.txt

# 创建 Upper Layer 和 Work Layer
mkdir -p /tmp/overlay/upper
mkdir -p /tmp/overlay/work

# 创建 Merged Layer
mkdir -p /tmp/overlay/merged

# 2. 挂载多个 Lower Layer 使用 OverlayFS
# 使用 mount 命令将多个 Lower Layer 叠加在一起：
# lowerdir=/tmp/overlay/lower2:/tmp/overlay/lower1：指定多个 Lower Layer，
# 层次从左到右依次为最上层到最下层。lower2 在上面，lower1 在下面。
# upperdir=/tmp/overlay/upper：指定可写层。
# workdir=/tmp/overlay/work：指定工作层。
/tmp/overlay/merged：最终的合并视图挂载点。
sudo mount -t overlay overlay \
  -o lowerdir=/tmp/overlay/lower2:/tmp/overlay/lower1,upperdir=/tmp/overlay/upper,workdir=/tmp/overlay/work \
  /tmp/overlay/merged

# 3. 验证合并结果
ls /tmp/overlay/merged
# 输出应包含来自 lower1 和 lower2 的文件：
# file1.txt  file2.txt

# 工作原理解释
# 文件查找顺序：OverlayFS 首先从 lower2 查找文件，如果找到文件，则直接使用；如果未找到，则继续从 lower1 查找。
# 文件的隐藏（覆盖）：如果多个 Lower Layer 中存在同名文件，上面的层会覆盖下面层的文件。例如，
# 如果 lower2 和 lower1 都有一个名为 file1.txt 的文件，那么合并视图中将显示 lower2 的版本，而 lower1 的文件将被隐藏。
# 读写分离：合并视图中的文件是只读的，所有写入操作都发生在上层的可写层（upperdir）。


```
