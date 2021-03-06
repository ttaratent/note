**String**    
  在构造方法String(char value[], int offset, int count)中，有注解
```
// Note: offset or count might be near -1>>>1.
```
offset > value.length - count
  主要是由于整型的最大值为-1>>>1(即-1无符号右移一位，2147483647)  
  而offset以及count中可能存在有无限接近这一最大值的情况时，导致该逻辑因为整型溢出异常  

例：
```
int a = (-1>>>1); // 2147483647
System.out.printlun(a>a+1); // true
```

String 通过 StringBuffer 进行创建时通过了synchronized关键字进行线程同步  

String类中  
codePoint 开头的方法主要处理大于两个字节的Unicode字符(一些于之后添加的字符)   

方法  |  说明  
-------------  |  -------------  
codePointAt  |  
codePointBefore  |  
codePointCount  |  返回在指定区间内的个数（区别于length，主要在于大于两个字节的Unicode字符）  
offsetByCodePoints  |  返回此String 中从给定的 index 处偏移 codePointOffset 个代码点的索引  

当通过直接量（String a = "JAVA";）进行定义String对象的时候，String是在常量池中进行查找，若存在则直接指向，若不存在则创建；而当使用new进行创建时（String a = new String();）对象首先在堆中创建一个引用对象，之后在常量池中查找是否存在，若存在则指向，不存在则创建。
