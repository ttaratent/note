## Java Native Method

[Java中native的用法](https://www.cnblogs.com/youngnong/p/5792108.html)    
在阅读Java源码的过程中出现了`native`关键字，通过查询相关资料，native的出现主要是由于，Java语言本身不支持直接对操作系统底层进行访问，所有需要通过JNI接口调用其他语言（例如C）进行对底层的访问。以下内容摘录自引用：    
JNI是Java本机接口（Java Native Interface），是一个本机编程接口，它是Java软件开发工具箱（Java Software Development Kit， SDK）的一部分。JNI允许Java代码使用以其他语言编写的代码和代码库。Invocation API（JNI的一部分）可以用来将Java虚拟机（JVM）嵌入到本机应用程序中，从而允许程序员从本机代码内部调用Java代码。    
不过，对Java外部的调用通常不能移植到其他平台，在applet中还可能引发安全异常。实现本地代码将使您的Java应用程序无法通过100%纯Java测试。但是，如果必须执行本地调用，则要考虑几个准则：     
1. 将您的所有本地方法都封装到一个类中，这个类调用单个dll。对每一种目标操作系统平台，都可以用特定于适当平台的版本的DLL。这样可以将本地代码的影响减少到最小，并有助于将以后所需要的移植问题考虑在内。
2. 本地方法尽量简单。尽量使您的本地方法对第三方（包括Microsoft）运行时DLL的依赖减少到最小。使您的本地方法尽量独立，以将加载您的DLL和应用程序所需的开销减少到最小，如果需要运行时DLL，必须随应用程序一起提供。
-- 优先记录，之后整理 To be continue
