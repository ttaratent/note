## Character
1JDK1.7之后通过使用UnicodeBlock以及UnicodeScript来进行不同语言不同字符的区别
详细之后整理
见于[
Java 中文字符判断 中文标点符号判断](https://blog.csdn.net/weixin_41167961/article/details/81737481)
汉字包括一个主号码段CJK Unified Ideographs(0x4E00-0x9FCC)总共包括74617个汉字，我们日常使用的大部分汉字都在里面了    
之后还有4个汉字的扩展UnicodeBlock--CJK Unified Ideographs Extension A,B,C,D分别扩展了例如古籍上的汉字。    
