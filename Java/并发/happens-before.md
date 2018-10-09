参考 [【死磕Java并发】—–Java内存模型之happens-before](http://cmsblogs.com/?p=2102)  
 happen-before原则
 在JMM中，如果一个操作执行的结果需要对另一个操作可见，那么这两个操作之间必须存在happens-before关系。

1. **如果一个操作happens-before另一个操作，那么第一个操作的执行结果将对第二个操作可见，而且第一个操作的执行顺序排在第二个操作之前。**
1. **两个操作之间存在happens-before关系，并不意味着一定要按照happens-before原则制定的顺序来执行。如果重新排序之后的执行结果与按照happens-before关系来执行的结果一致，那么这种重排序并不非法。**

下面是happens-before原则规则：
1. 程序次序规则：一个线程内，按照代码顺序，书写在前面的操作先行发生于书写在后面的操作；
1. 锁定规则：一个unLock操作先行发生于后面对同一个锁额lock操作；
1. volatile变量规则：对一个变量的写操作先行发生于后面对这个变量的读操作；
1. 传递规则：如果操作A先行发生于操作B，而操作B又先行发生于操作C，则可以得出操作A先行发生于操作C；
1. 线程启动规则：Thread对象的start()方法先行发生于此线程的每个动作；
1. 线程中断规则：对线程interrupt()方法的调用先行发生于被中断线程的代码检测到中断事件的发生；
1. 线程终结规则：线程中所有的操作都先行发生于线程的终止检测，我们可以通过Thread.join()方法结束、Thread.isAlive()的返回值手段检测到线程已经终止执行；
1. 对象终止规则：一个对象的初始化完成先行发生于他的finalize()方法的开始；

可以推导出以下6条规则：
1. 将一个元素放入一个线程安全的队列的操作Happens-Before从队列中取出这个元素的操作
1. 将一个元素放入一个线程安全容器的操作Happens-Before从容器中取出这个元素的操作
1. 在CountDownLatch上的倒数操作Happens-Before CountDownLatch#await()操作
1. 释放Semaphore许可的操作Happens-Before或者许可操作
1. Future表示的任务的所有操作Happens-Before Future#get()操作
1. 向Executor提交一个Runnable或Callable的操作Happens-Before任务开始执行操作  
`happens-before原则是JMM中非常重要的原则，它是判定数据是否存在竞争、线程是否安全的主要依据，保证了多线程环境下的可见性`  
