## Character
1JDK1.7之后通过使用UnicodeBlock以及UnicodeScript来进行不同语言不同字符的区别         
见于[Java 中文字符判断 中文标点符号判断](https://blog.csdn.net/weixin_41167961/article/details/81737481)    
汉字包括一个主号码段CJK Unified Ideographs(0x4E00-0x9FCC)总共包括74617个汉字，我们日常使用的大部分汉字都在里面了    
之后还有4个汉字的扩展UnicodeBlock--CJK Unified Ideographs Extension A,B,C,D分别扩展了例如古籍上的汉字。    
Character类中有三个静态内部类     

| Modifier and Type | Class and Description |
| :----: | :--- |
| static class | [Character.Subset](https://docs.oracle.com/javase/7/docs/api/java/lang/Character.Subset.html)<br>Instances of this class represent particular subsets of the Unicode character set. |
| static class | [Character.UnicodeBlock](https://docs.oracle.com/javase/7/docs/api/java/lang/Character.UnicodeBlock.html)<br>A family of character subsets representing the character blocks in the Unicode specification. |
| static class | [Character.UnicodeScript](https://docs.oracle.com/javase/7/docs/api/java/lang/Character.UnicodeScript.html)<br>A family of character subsets representing the character scripts defined in the [Unicode Standard Annex #24: Script Names](http://www.unicode.org/reports/tr24/).|

我的理解是UnicodeBlock主要用于标识字符集所处的字符集，而UnicodeScript主要是将字符集中的字符与具体的语言体系联系起来。

判断是否是中文字符的方法：    
```
// 使用UnicodeBlock方法判断
public boolean isChineseByBlock(char c) {
  // 取出具体在UnicodeBlock的位置
  Character.UnicodeBlock ub = Character.UnicodeBlock.of(c);
  if(ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS
    || ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS_EXTENSION_A
    || ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS_EXTENSION_B
    || ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS_EXTENSION_C
    || ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS_EXTENSION_D
    || ub == Character.UnicodeBlock.CJK_COMPATIBILITY_IDEOGRAPHS
    || ub == Character.UnicodeBlock.CJK_COMPATIBILITY_IDEOGRAPHS_SUPPLEMENT) {
      return true;
    } else {
      return false;
    }
}

// 使用UnicodeScript方法判断
public boolean isChineseByScript(char c) {
  Character.UnicodeScript sc = Character.UnicodeScript.of(c);
  if (sc == Character.UnicodeScript.HAN) {
    return true;
  } else {
    return false;
  }
}
```
以及中文的标点符号：中文标点符号主要存在于以下5个UnicodeBlock中：    
1. U2000-General Punctuation(百分号、千分号、单引号、双引号等)
2. U3000-CJK Symbols and Punctuation(顿号、句号，书名号，〸，〹，〺 等)
3. UFF00-Halfwidth and Fullwidth Forms ( 大于，小于，等于，括号，感叹号，加，减，冒号，分号等等)
4. UFE30-CJK Compatibility Forms  (主要是给竖写方式使用的括号，以及间断线﹉，波浪线﹌等)
5. UFE10-Vertical Forms (主要是一些竖着写的标点符号，    等等)
```
// 根据UnicodeBlock方法判断中文标点符号
public boolean isChinesePunctuation(char c) {
  Character.UnicodeBlock ub = Character.UnicodeBlock.of(c);
  if (ub == Character.UnicodeBlock.GENERAL_PUNCTUATION
        || ub == Character.UnicodeBlock.CJK_SYMBOLS_AND_PUNCTUATION
        || ub == Character.UnicodeBlock.HALFWIDTH_AND_FULLWIDTH_FORMS
        || ub == Character.UnicodeBlock.CJK_COMPATIBILITY_FORMS
        || ub == Character.UnicodeBlock.VERTICAL_FORMS) {
    return true;
  } else {
    return false;
  }
}
```
