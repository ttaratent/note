### Markdown 语法整理  
markdown兼容HTML：
```
<table>
  <tr>
    <td>Foo</td><td>Foo1</td><td>Foo2</td>
  </tr>
  <tr>
    <td>Bob</td><td>Bob1</td><td>Bob2</td>
  </tr>
  <tr>
    <td>Alex</td><td>Alex1</td><td>Alex2</td>
  </tr>
  <tr>
    <td>Smith</td><td>Smith1</td><td>Smith2</td>
  </tr>
</table>
```
实际效果如下：
<table>
  <tr>
    <td>Foo</td><td>Foo1</td><td>Foo2</td>
  </tr>
  <tr>
    <td>Bob</td><td>Bob1</td><td>Bob2</td>
  </tr>
  <tr>
    <td>Alex</td><td>Alex1</td><td>Alex2</td>
  </tr>
  <tr>
    <td>Smith</td><td>Smith1</td><td>Smith2</td>
  </tr>
</table>  

同时表格也可以通过Markdown的语法展示
1. |、-、:之间的多余空格会被忽略，不影响布局。
2. 默认标题栏居中对齐，内容居左对齐。
3. -:表示内容和标题栏居右对齐，:-表示内容和标题栏居左对齐，:-:表示内容和标题栏居中对齐。
4. 内容和|之间的多余空格会被忽略，每行第一个|和最后一个|可以省略，-的数量至少有一个。  
```
|  Foo  |  Foo1  |  Foo2  |
|  Foo  |  Foo1  |  Foo2  |
```

|  A  |  A  |  A  |  
| ---: | :--- | :----: |
|  Foo  |  BBBBBB1  |  FoDDo2  |  

使用该类型写法时注意开头要留空一行，不然表格效果可能无效

MarkDown语法中，一个Markdown段落是由一个或多个连续地文本行组成，它的前后要有一个即以上的空行，才会另起一行进行显示（空行，即显示上看起来是空的即被视为空行，例如只有空格和制表符等）。普通段落不该用空格或者制表符缩进，无效果，若需要强制换行，则可使用两个以上的空格然后回车或者插入HTML换行符`<br/>`

标题  
Markdown支持两种标题的语法，类Setext和类atx形式  
类Setext形式是用底线的形式，例如：
```
This is an H1
==============

This is an H2
--------------
```

类Atx形式标题，支持H1到H6，例如：
```
# 这是 H1
## 这是 H2
###### 这是 H6
```

也可以选择性闭合类Atx样式标题
```
# 这是 H1 #
## 这是 H2 ##
###### 这是 H6 ######
```
