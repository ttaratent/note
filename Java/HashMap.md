### HashMap
在Java中主要的存储结构主要包括顺序存储以及链表存储。而HashMap则综合了两种类型的存储方式，使用数组存储每一个不同hashCode的对象的链表。     
#### 构造
HashMap主要通过一个Entry<K,V>数组进行存储。transient关键字主要用途是当对象序列化是被该关键字标识的元素，不使用序列化保存。
```
transient Entry<K,V>[] table = (Entry<K,V>[]) EMPTY_TABLE;
```
其中Entry是HashMap的静态内部类


HashMap的数据存储的主体位置主要是通过hash函数，对Key值进行计算，计算出对应的下标，如果数组中该下标的位置链表不存在数据，则将该对象通过Entry<K,V>存入该位置，若已有数据，则在当前Entry对象的next记录新增对象的引用，进行存储。



HashMap主要性能取决于哈希散列函数对于不同关键字的散列情况。
