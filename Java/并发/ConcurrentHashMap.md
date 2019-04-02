### ConcurrentHashMap 1.7
ConcurrentHashMap异步容器主要是通过将对象锁改为粒度更细的锁，默认分为16个segments并给每一个segment配置一个锁，而在存储数据的时候，将具体存储的数据划分到这16个segments中，而当有并发请求时，对该请求的segment进行加锁，来提高并发的性能，并保证数据的同步。    

将ConcurrentHashMap分成16个segments（桶），而数据键值对存放在HashEntry中，而HashEntry存放于桶的HashEntry数组中
![借鉴于https://blog.csdn.net/piaoslowly/article/details/81562284](./images/chashmap1.png)

```
// ConcurrentHashMap 类的变量
private static final long serialVersionUID = 7249069246763182397L; // 序列化UID
static final int DEFAULT_INITIAL_CAPACITY = 16; // 初始Segment数量，桶数
static final float DEFAULT_LOAD_FACTOR = 0.75F; // 负载因子 即容量百分比到达负载因子，进行扩容
static final int DEFAULT_CONCURRENCY_LEVEL = 16; // 散列表的默认并发级别为16。该值表示当前更新线程的估计数
static final int MAXIMUM_CAPACITY = 1073741824; // 最大容量 1 << 30
static final int MAX_SEGMENTS = 65536; // 最大Segment数量 1 << 16

/*
 * Number of unsynchronized retries in size and containsValue
 * methods before resorting to locking. This is used to avoid
 * unbounded retries if tables undergo continuous modification
 * which would make it impossible to obtain an accurate result.
 */
static final int RETRIES_BEFORE_LOCK = 2;
final int segmentMask; // 是实际初始化的segment数-1
final int segmentShift; // 剩余二进制位数 32 - segments数的二进制位数
final Segment<K, V>[] segments; // 实际桶
transient Set<K> keySet;
transient Set<Map.Entry<K, V>> entrySet;
transient Collection<V> values;
```

当然划分的segment数量可以在数据初始化的时候进行设置，第三个参数应该就是设置segment数量：
```
// ConcurrentHashMap对象的构造方法
public ConcurrentHashMap(int paramInt1, float paramFloat, int paramInt2) {
  if ((paramFloat <= 0.0F) || (paramInt1 < 0) || (paramInt2 < 0)) {
    throw new IllegalArgumentException();
  }
  if (paramInt2 > MAX_SEGMENTS) {
    paramInt2 = MAX_SEGMENTS;
  }

  int i = 0;
  int j = 1;
  while (j < paramInt2) {
    ++i;
    j <<= 1;
  }
  this.segmentShift = (32 - i);
  this.segmentMask = (j - 1);
  this.segments = Segment.newArray(j);

  if (paramInt1 > MAXIMUM_CAPACITY)
    paramInt1 = MAXIMUM_CAPACITY;
  int k = paramInt1 / j; // 确认每个桶的大小
  if (k * j < paramInt1)
    ++k;
  int l = 1;
  while (l < k) {
    l <<= 1; // 按二进制进位的方法定义桶的大小
  }
  for (int i1 = 0; i1 < this.segments.length; ++i1)
    this.segments[i1] = new Segment(l, paramFloat);
}

public ConcurrentHashMap(int paramInt, float paramFloat) {
  this(paramInt1, paramFloat, DEFAULT_INITIAL_CAPACITY);
}

public ConcurrentHashMap(int paramInt) {
  this(paramInt, 0.75F, DEFAULT_INITIAL_CAPACITY);
}

public ConcurrentHashMap() {
  this(16, 0.75F, DEFAULT_INITIAL_CAPACITY);
}

public ConcurrentHashMap(Map<? extends K, ? extends V> paramMap) {
  this(Math.max((int) (paramMap.size() / 0.75F) + 1, 16), 0.75F, 16);

  putAll(paramMap);
}

public void putAll(Map<? extends K, ? extends V> paramMap) {
  for(Map.Entry localEntry : paramMap.entrySet())
    put(localEntry.getKey(), localEntry.getValue());
}
```

ConcurrentHashMap的锁主要在于其内部静态类 Segment<K, V>。该类通过继承了ReentrantLock类来实现锁。    
```
static final class Segment<K, V> extends ReentrantLock implements Serializable {
  private static final long serialVersionUID = 2249069246763182397L;
  volatile transient int count;
  transient int modCount;
  transient int threshold;
  volatile transient ConcurrentHashMap.HashEntry<K, V>[] table;
  final float loadFactor;

  Segment(int paramInt, float paramFloat) {
    this.loadFactor = paramFloat;
    setTable(ConcurrentHashMap.HashEntry.newArray(paramInt));
  }

  static final <K, V> Segment<K, V>[] newArray(int paramInt) {
    return new Segment[paramInt];
  }

  void setTable(ConcurrentHashMap.HashEntry<K, V>[] paramArrayOfHashEntry) {
    this.threshold = (int) (paramArrayOfHashEntry.length * this.loadEntry);
    this.table = paramArrayOfHashEntry;
  }

  ConcurrentHashMap.HashEntry<K, V> getFirst(int paramInt) {
    ConcurrentHashMap.HashEntry[] arrayOfHashEntry = this.table;
    return arrayOfHashEntry[(paramInt & arrayOfHashEntry.length - 1)];
  }

  V readValueUnderLock(ConcurrentHashMap.HashEntry<K, V> paramHashEntry) {
    lock();
    try {
      Object localObject1 = paramHashEntry.value;
      return localObject1;
    } finally {
      unlock();
    }
  }

  V get(Object paramObject, int paramInt) {
    if (this.count != 0) {
      ConcurrentHashMap.HashEntry localHashEntry = getFirst(paramInt);
      while (localHashEntry != null) {
        if ((localHashEntry.hash == paramInt) && (paramObject.equals(localHashEntry.key))) {
          Object localObject = localHashEntry.value;
          if (localObject != null)
            return localObject;
          return readValueUnderLock(localHashEntry);
        }
        localHashEntry = localHashEntry.next;
      }
    }
    return null;
  }

  boolean containsKey(Object paramObject, int paramInt) {
    if (this.count != 0) {
      ConcurrentHashMap.HashEntry localHashEntry = getFirst(paramInt);
      while (localHashEntry != null) {
        if ((localHashEntry.hash == paramInt) && (paramObject.equals(localHashEntry.key)))
          return true;
        localHashEntry = localHashEntry.next;
      }
    }
    return false;
  }

  boolean containsValue(Object paramObject) {
    if (this.count != 0) {
      ConcurrentHashMap.HashEntry[] arrayOfHashEntry = this.table;
      int i = arrayOfHashEntry.length;
      for (int j = 0; j < i; ++j) {
        for (ConcurrentHashMap.HashEntry localHashEntry = arrayOfHashEntry[j]; localHashEntry != null; localHashEntry = localHashEntry.next) {
          Object localObject = localHashEntry.value;
          if (localObject == null)
            localObject = readValueUnderLock(localHashEntry);
          if (paramObject.equals(localObject))
            return true;
        }
      }
    }
    return false;
  }

  boolean replace(K paramK, int paramInt, V paramV1, V paramV2) {
    lock();
    try {
      ConcurrentHashMap.HashEntry localHashEntry = getFirst(paramInt);
      while ((localHashEntry != null)
              && (((localHashEntry.hash != paramInt) || (!(paramK.equals(localHashEntry.key)))))) {
        localHashEntry = localHashEntry.next;
      }
      int i = 0;
      if ((localHashEntry != null) && (paramV1.equals(localHashEntry.value))) {
        i = 1;
        localHashEntry.value = paramV2;
      }
      int j = i;
      return j;
    } finally {
      unlock();
    }
  }

  V replace(K paramK, int paramInt, V paramV) {
    lock();
    try {
      ConcurrentHashMap.HashEntry localHashEntry = getFirst(paramInt);
      while ((localHashEntry != null)
        && (((localHashEntry.hash != paramInt) || (!(paramK.equals(localHashEntry.key)))))) {
        localHashEntry = localHashEntry.next;
      }
      Object localObject1 = null;
      if (localHashEntry != null) {
        localObject1 = localHashEntry.value;
        localHashEntry.value = paramV;
      }
      Object localObject2 = localObject;

      return localObject2;
    } finally {
      unlock();
    }
  }

  V put(K paramK, int paramInt, V paramV, boolean paramBoolean) {
    lock();
    try {
      int i = this.count;
      if (i++ > this.threshold)
        rehash();
      ConcurrentHashMap.HashEntry[] arrayOfHashEntry = this.table;
      int j = paramInt & arrayOfHashEntry.length - 1;
      ConcurrentHashMap.HashEntry localHashEntry1 = arrayOfHashEntry[j];
      ConcurrentHashMap.HashEntry localHashEntry2 = localHashEntry1;
      while ((localHashEntry2 != null)
        && (((localHashEntry2.hash != paramInt) || (!(paramK.equals(localHashEntry2.key))))))
        localHashEntry2 - localHashEntry2.next;
      Object localObject1;
      if (localHashEntry2 != null) {
        localObject1 = localHashEntry2.value;
        if (!(paramBoolean))
          localHashEntry2.value = paramV;
      } else {
        localObject1 = null;
        this.modCount += 1;
        arrayOfHashEntry[j] = new ConcurrentHashMap.HashEntry(paramK, paramInt, localHashEntry1, paramV);
        this.count = i;
      }
      Object localObject2 = localObject1;

      return localObject2;
    } finally {
      unlock();
    }
  }

  void rehash() {
    ConcurrentHashMap.HashEntry[] arrayOfHashEntry1 = this.table;
    int i = arrayOfHashEntry1.length;
    if (i >= 1073741824) {
      return;
    }

    ConcurrentHashMap.HashEntry[] arrayOfHashEntry2 = ConcurrentHashMap.HashEntry.newArray(i << 1);
    this.threshold = (int) (arrayOfHashEntry2.length * this.loadFactor);
    int j = arrayOfHashEntry2.length - 1;
    for (int k = 0; k < i; ++k) {
      ConcurrentHashMap.HashEntry localHashEntry1 = arrayOfHashEntry1[k];

      if (localHashEntry1 != null) {
        ConcurrentHashMap.HashEntry localHashEntry2 = localHashEntry1.next;
        int l = localHashEntry1.hash & j;

        if (localHashEntry2 == null) {
          arrayOfHashEntry2[l] = localHashEntry1;
        } else {
          Object localObject = localHashEntry1;
          int i1 = l;
          ConcurrentHashMap.HashEntry localHashEntry3 = localHashEntry2;
          int i2;
          while (localHashEntry3 != null) {
            i2 = localHashEntry3.hash & j;
            if (i2 != i1) {
              i1 = i2;
              localObject = localHashEntry3;
            }
            localHashEntry3 = localHashEntry3.next;
          }

          arrayOfHashEntry2[i1] = localObject;

          for (localHashEntry3 = localHashEntry1; localHashEntry3 != localObject; localHashEntry3 = localHashEntry3.next) {
            i2 = localHashEntry3.hash & j;
            ConcurrentHashMap.HashEntry localHashEntry4 = arrayOfHashEntry2[i2];
            arrayOfHashEntry2[i2] = new ConcurrentHashMap.HashEntry(localHashEntry3.key,
              localHashEntry3.hash, localHashEntry4, localHashEntry3.value);
          }
        }
      }
    }
    this.table = arrayOfHashEntry2;
  }

  V remove(Object paramObject1, int paramInt, Object paramObject2) {
    lock();
    try{
      int i = this.count - 1;
      ConcurrentHashMap.HashEntry[] arrayOfHashEntry = this.table;
      int j = paramInt & arrayOfHashEntry.length - 1;
      ConcurrentHashMap.HashEntry localHashEntry1 = arrayOfHashEntry[j];
      ConcurrentHashMap.HashEntry localHashEntry2 = localHashEntry1;
      while ((localHashEntry2 != null)
        && (((localHashEntry2.hash != paramInt) || (!(paramObject1.equals(localHashEntry2.key)))))) {
          localHashEntry2 = localHashEntry2.next;
        }
        Object localObject1 = null;
        Object localObject2 = null;
        if (localHashEntry2 != null) {
          localObject2 = localHashEntry2.value;
          if ((paramObject2 == null) || (paramObject2.equals(localObject2))) {
            localObject1 = localObject2;

            this.modCount += 1;
            ConcurrentHashMap.HashEntry localHashEntry3 = localHashEntry2.next;
            for (ConcurrentHashMap.HashEntry localHashEntry4 = localHashEntry1; localHashEntry4 != localHashEntry2; localHashEntry4 = localHashEntry4.next) {
              localHashEntry3 = new ConcurrentHashMap.HashEntry(localHashEntry4.key, localHashEntry4.hash,
                localHashEntry3, localHashEntry4.value);
            }
            arrayOfHashEntry[j] = localHashEntry3;
            this.count = i;
          }
        }
        localObject2 = localObject1;
        return localObject2;
    } finally {
      unlock();
    }
  }

  void clear() {
    if (this.count != 0) {
      lock();
      try {
        ConcurrentHashMap.HashEntry[] arrayOfHashEntry = this.table;
        for (int i = 0; i < arrayOfHashEntry.length; ++i)
          arrayOfHashEntry[i] = null;
        this.modCount += i;
        this.count = 0;
      } finally {
        unlock();
      }
    }
  }
}
```
基础存储单元HashEntry
```
static final class HashEntry<K, V> {
  final K key;
  final int hash;
  volatile V value;
  final HashEntry<K, V> next;

  HashEntry(K paramK, int paramInt, HashEntry<K, V> paramHashEntry, V paramV) {
    this.key = paramK;
    this.hash = paramInt;
    this.next = paramHashEntry;
    this.value = paramV;
  }

  static final <K, V> HashEntry<K, V>[] newArray(int paramInt) {
    return new HashEntry[paramInt];
  }
}
```

其中isEmpty方法，是通过循环遍历Segment内部类的count以及modCount变量来判断是否为true     
其中Segment的count是由volatie修饰的，<font color='red'>（！暂时想不通线程是否安全）</font>
```
public boolean isEmpty() {
  Segment[] arrayOfSegment = this.segments;

  int[] arrayOfInt = new int[arrayOfSegment.length];
  int i = 0;
  for (int j = 0; j < arrayOfSegment.length; ++j) {
    if (arrayOfSegment[j].count != 0) {
      return false;
    }
    i += (arrayOfInt[j] = arrayOfSegment[j].modCount);
  }

  if (i != 0) {
    for (j = 0; j < arrayOfSegment.length; ++j)
      if ((arrayOfSegment[j].count != 0) || (arrayOfInt[j] != arrayOfSegment[j].modCount)) {
        return false;
      }
  }
  return true;
}
```


参考：[ConcurrentHashMap总结](https://www.liangzl.com/get-article-detail-28344.html)
