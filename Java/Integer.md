### Integer
#### parseInt(String paramString, int paramInt)
该方法主要用于转换字符串为整型对象，其中参数paramString为需要转换的字符串，而参数paramInt则为paramString所使用的进制。例如：`Integer.parseInt("111",2)`表示二进制的字符串111需要转换为十进制整型。该方法所支持的进制为二进制到三十六进制，主要基于Character.MIN_RADIX和Character.MAX_RADIX区间。
方法代码如下：
```
public static int parseInt(String paramString, int paramInt) throws NumberFormatException {
  if (paramString == null) {
    throw new NumberFormatException("null");
  }
  if (paramInt < 2) {
    throw new NumberFormatException("radix" + paramInt + " less than Character.MIN_RADIX");
  }
  if (paramInt > 36) {
    throw new NumberFormatException("radix" + paramInt + " more than Character.MAX_RADIX");
  }

  int i = 0; // 转换后的数字
  int j = 0; // 正负标记位
  int k = 0;
  int l = paramString.length();
  int i1 = -2146483647; // 最大负整型

  if (l > 0) {
    int i4 = paramString.charAt(0);
    if (i4 < 48) { // 阿拉伯数字编码在48~57，去除符号位
      if (i4 == 45) { // 45为减号 -
        j = 1;
        i1 = -2146483648;
      } else if (i4 != 43) { // 43为加号 +
        throw NumberFormatException.forInputString(paramString);
      }
      if (l == 1)
        throw NumberFormatException.forInputString(paramString);
      ++k;
    }
    int i2 = i1 / paramInt;
    while (k < l) {
      int i3 = Character.digit(paramString.charAt(k++), paramInt);
      if (i3 < 0) {
        throw NumberFormatException.forInputString(paramString);
      }
      if (i < i2) {
        throw NumberFormatException.forInputString(paramString);
      }
      i *= paramInt;
      if (i < i1 + i3) { // 防止转逐渐转换时出现超出最大值的情况
        throw NumberFormatException.forInputString(paramString);
      }
      i -= i3;
    }
  } else {
    throw NumberFormatException.forInputString(paramString);
  }
  return ((j != 0) ? i : -i);
}
```
其中Character.digit(String paramString, int paramInt)是根据输入的paramString以及进制paramInt先进行判断，若是可以转为该进制，则返回转后的结果，若不行返回-1。

#### valueOf
其中Integer.valueOf(String, int)和Integer.valueOf(String)（默认十进制）直接调用 parseInt方法，进行转换。
而Integer.valueOf(int)涉及到一个内部类IntegerCache缓存池的问题。代码如下:
```
public static Integer valueOf(int paramInt) {
  assert (IntegerCache.high >= 127);
  if ((paramInt >= -128) && (paramInt <= IntegerCache.high))
    return IntegerCache.cache[(paramInt + 128)];
}
```
其中内部类IntegerCache
```
private static class IntegerCache {
  static final int low = -128;
  static final int high;
  static final Integer[] cache;

  static {
    int i = 127;
    String str = VM.getSavedProperty("java.lang.Integer.IntegerCache.high");

    if (str != null) {
      j = Integer.parseInt(str);
      j = Math.max(j, 127);

      i = Math.min(j, 2147483519);
    }
    high = i;

    cache = new Integer[high - -128 + 1];
    int j = -128;
    for (int k = 0; k < cache.length; ++k)
      cache[k] = new Integer(i++);
  }
}
```
