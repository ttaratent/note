[《深入java虚拟机》读书笔记之Java内存区域](https://www.cnblogs.com/liyus/p/10297012.html)

JVM的内存包括两块内容，分别为Native Memory和Heap Memory，Native Memory内存主要用于运行JVM等所需要的内存，所以当设置-Xms过大时，有可能导致native memory内存不足，导致OOM（Out of Memory）错误。    

Native Memory没有相应的参数来控制大小，其大小依赖于操作系统进程的最大值（对于32位系统就是3~4G，各种系统的实现并不一样），以及生成的Java字节码大小、创建的线程数量、维持java对象的状态信息大小（用于GC）以及一些第三方的包，比如JDBC驱动使用的native内存。

存于Native Memory中的数据：
1. 管理java heap的状态数据（用于GC）;
2. JNI调用，也就是Native Stack;
3. JIT（即使编译器）编译时使用Native Memory，并且JIT的输入（Java字节码）和输出（可执行代码）也都是保存在Native Memory；
4. NIO direct buffer。对于IBM JVM和Hotspot，都可以通过-XX:MaxDirectMemorySize来设置nio直接缓冲区的最大值。默认是64M。超过这个时，会按照32M自动增大。
5. 对于IBM的JVM某些版本实现，类加载器和类信息都是保存在Native Memory中的。

参考：
* [JVM的Native Memory和Native Memory](https://blog.csdn.net/cjf1002361126/article/details/52979296)    
* [关于native memory不足引起的OutOfMemory(OOM)问题](https://can-do.iteye.com/blog/2250704)
* [JVM NativeMemoryTracking 分析堆外内存泄露](https://my.oschina.net/foxty/blog/1934968)
