[从jvm角度看懂类初始化、方法重写、重载。](https://www.cnblogs.com/kubidemanong/p/9433758.html)

转载:[经典面试题|讲一讲JVM的组成](https://www.cnblogs.com/vipstone/p/10681211.html)    
参考：[深入理解JVM—JVM内存模型](https://www.cnblogs.com/dingyingsi/p/3760447.html)        
[Java堆外内存之六：堆外内存溢出问题排查](https://www.cnblogs.com/duanxz/p/6089421.html)     
JVM整体组成可以分为四个部分：
1. 类加载器（ClassLoader）
2. 运行时数据区（Runtime Data Area）
3. 执行引擎（Execution Engine）
4. 本地库接口（Native Interface）

程序在执行之前先要把java代码转换成字节码（class文件），jvm首先需要把字节码通过一定的方式 类加载器（ClassLoader） 把文件加载到内存中 运行时数据区（Runtime Data Area） ，而字节码文件是jvm的一套指令集规范，并不能直接交个底层操作系统去执行，因此需要特定的命令解析器 执行引擎（Execution Engine） 将字节码翻译成底层系统指令再交由CPU去执行，而这个过程中需要调用其他语言的接口 本地库接口（Native Interface）来实现整个程序的功能，这就是这4个主要组成部分的职责与功能。

而我们通常所说的jvm组成指的是运行时数据区（Runtime Data Area），因为通常需要程序员调试分析的区域就是“运行时数据区”，或者更具体的来说就是“运行时数据区”里面的Heap（堆）

jvm的运行时数据区，不同虚拟机实现可能略微有所不同，但都会遵从Java虚拟机规范，Java 8 虚拟机规范规定，Java虚拟机所管理的内存将会包括以下几个运行时数据区域：
1. 程序计数器（Program Counter Register）
2. Java虚拟机栈（Java Virtual Machine Stacks）
3. 本地方法栈（Native Method Stack）
4. Java堆（Java Heap）
5. 方法区（Methed Area）

①、Java程序计数器
程序计数器（Program Counter Register）是一块较小的内存空间，它可以看作是当前线程所执行的字节码的行号指示器。在虚拟机的概念模型里，字节码解析器的工作是通过改变这个计数器的值来选取下一条需要执行的字节码指令，分支、循环、跳转、异常处理、线程恢复等基础功能都需要依赖这个计数器来完成。

特性：内存私有

由于jvm的多线程是通过线程轮流切换并分配处理器执行时间的方式来实现的，也就是任何时刻，一个处理器（或者说一个内核）都只会执行一条线程中的指令。因此为了线程切换后能恢复到正确的执行位置，每个线程都有独立的程序计数器。

异常规定：无

如果线程正在执行Java中的方法，程序计数器记录的就是正在执行虚拟机字节码指令的地址，如果是Native方法，这个计数器就为空（undefined），因此该内存区域是唯一一个在Java虚拟机规范中没有规定OutOfMemoryError的区域。

②、Java虚拟机栈
Java虚拟机栈（Java Virtual Machine Stacks）描述的是Java方法执行的内存模型，每个方法在执行的同时都会创建一个线帧（Stack Frame）用于存储局部变量表、操作数栈、动态链接、方法出口等信息，每个方法从调用直至执行完成的过程，都对应着一个线帧在虚拟机栈中入栈到出栈的过程。

特性：内存私有，它的生命周期和线程相同。

异常规定：StackOverflowError、OutOfMemoryError

1、如果线程请求的栈深度大于虚拟机所允许的栈深度就会抛出StackOverflowError异常。

2、如果虚拟机是可以动态扩展的，如果扩展时无法申请到足够的内存就会抛出OutOfMemoryError异常。

③、本地方法栈
本地方法栈（Native Method Stack）与虚拟机栈的作用是一样的，只不过虚拟机栈是服务Java方法的，而本地方法栈是为虚拟机调用Native方法服务的。

在Java虚拟机规范中对于本地方法栈没有特殊的要求，虚拟机可以自由的实现它，因此在Sun HotSpot虚拟机直接把本地方法栈和虚拟机栈合二为一了。

特性和异常： 同虚拟机栈，请参考上面知识点。

④、Java堆
Java堆（Java Heap）是Java虚拟机中内存最大的一块，是被所有线程共享的，在虚拟机启动时候创建，Java堆唯一的目的就是存放对象实例，几乎所有的对象实例都在这里分配内存，随着JIT编译器的发展和逃逸分析技术的逐渐成熟，栈上分配、标量替换优化的技术将会导致一些微妙的变化，所有的对象都分配在堆上渐渐变得不那么“绝对”了。

特性：内存共享

异常规定：OutOfMemoryError

如果在堆中没有内存完成实例分配，并且堆不可以再扩展时，将会抛出OutOfMemoryError。

Java虚拟机规范规定，Java堆可以处在物理上不连续的内存空间中，只要逻辑上连续即可，就像我们的磁盘空间一样。在实现上也可以是固定大小的，也可以是可扩展的，不过当前主流的虚拟机都是可扩展的，通过-Xmx和-Xms控制。

⑤、方法区
方法区（Methed Area）用于存储已被虚拟机加载的类信息、常量、静态变量、即时编译后的代码等数据。

误区：方法区不等于永生代

很多人原因把方法区称作“永久代”（Permanent Generation），本质上两者并不等价，只是HotSpot虚拟机垃圾回收器团队把GC分代收集扩展到了方法区，或者说是用来永久代来实现方法区而已，这样能省去专门为方法区编写内存管理的代码，但是在Jdk8也移除了“永久代”，使用Native Memory来实现方法区。

特性：内存共享

异常规定：OutOfMemoryError

当方法无法满足内存分配需求时会抛出OutOfMemoryError异常。

三、扩展知识
本节将扩展一些和内存分配有关的知识。

运行时常量池
运行时常量池是方法区的一部分，Class文件中除了有类的版本、字段、方法、接口等描述信息外，还有一项信息是常量池（Constant Pool Table）用于存放编译期生成的各种字面量和符号引用，这部分在类加载后进入方法区的运行是常量池中，如String类的intern()方法。

直接内存
直接内存（Direct Memory）并不是虚拟机运行时数据区的一部分，但这部分内存也会被频繁的使用，而且可能导致OutOfMemoryError。在JDK 1.4中新加入了NIO类，引入了一种基于Channel与缓冲区Buffer的IO方式，它通过一个存储在Java堆中的DirectByteBuffer对象作为这块内存的引用操作，它因此更高效，它避免了Java堆和Native堆来回交换数据的时间。

注意 ：直接内存分配不会受到Java堆大小的限制，但是受到本机总内存大小限制，在设置虚拟机参数的时候，不能忽略直接内存，把实际内存设置为-Xmx，使得内存区域的总和大于物理内存的限制，从而导致动态扩展时出现OutOfMemoryError异常。
