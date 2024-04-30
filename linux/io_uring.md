# io_uring

## refs

[图解原理｜Linux I/O 神器之 io_uring](https://cloud.tencent.com/developer/article/2187655)

[[译] Linux 异步 I/O 框架 io_uring：基本原理、程序示例与性能压测（2020）](https://arthurchiao.art/blog/intro-to-io-uring-zh/)

[AIO 的新归宿：io_uring](https://zhuanlan.zhihu.com/p/62682475)


```text
IO_uring 的官方文档和示例代码可以在 GitHub 上找到。以下是一些资源链接：

1. IO_uring 官方 GitHub 仓库：https://github.com/axboe/liburing
   这个仓库包含了 IO_uring 的源代码、示例代码和文档。

2. IO_uring 用户指南：
   - 英文版：https://github.com/axboe/liburing/blob/master/Documentation/uring.txt
   - 中文版：https://github.com/axboe/liburing/blob/master/Documentation/uring-zh_CN.txt

3. IO_uring 示例代码：
   - https://github.com/axboe/liburing/tree/master/examples
   这个目录下包含了一些使用 IO_uring 的示例代码，涵盖了不同类型的异步 IO 操作。

4. IO_uring 开发者文档和演示视频：
   - 英文版：https://kernel.dk/io_uring.pdf
   - 中文版：https://zhuanlan.zhihu.com/p/352256924
   这些文档提供了更详细的关于 IO_uring 的介绍和使用方法，以及一些实际的示例和演示视频。

请注意，IO_uring 是一个在 Linux 内核中实现的异步 IO 框架，使用它需要对 Linux 系统编程和异步 IO 有一定的了解。在使用之前，建议先阅读相关的官方文档和示例代码，以便更好地理解和使用 IO_uring。
```
