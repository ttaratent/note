一种是直接通过DOM的input.select();方法

```
<script>
    var input = document.getElementsById('input');
    input.onfocus = function(){
        this.select()
    }
</script>
```

第二种自定义选择的范围：

主要使用setSelectionRange和createTextRange两种形式：    
`inputElement.setSelectionRange(selectionStart, selectionEnd, [optional] selectionDirection);`

* selectionStart：第一个被选中的字符的序号（index），从0开始。
* selectionEnd：被选中的最后一个字符的前一个。换句换说，不包括index为selectionEnd的字符，其中可以设置复数例如-1，表示全选。
* selectionDirection：选择的方向。可选值为forward(从前往后）、backward（从后往前）或none（忽略）。

例如:
```
<script>
    var input = document.getElementsById('input');
    function setSelected(input, selectionStart, selectionEnd) {
        if (input.setSelectionRange) { // Chrome等
            input.focus(); // 可不用根据情况决定
            input.setSelectionRange(selectionStart, selectionEnd);
        } else if (input.createTextRange) { // IE
            var range = input.createTextRange();
            range.collapse(true);
            range.moveEnd('character', selectionEnd);
            range.moveStart('character', selectionStart);
            range.select();
        }
    }
    setSelected(input,1,2);
</script>
```

根据：[createTextRange](https://blog.csdn.net/baidu_33033415/article/details/62882699)这两个api在iframe中不能实现。    
疑似iframe的实现[IFrame 系列4 ---- document.selection 全方位兼容解析以及TextRange[createTextRange,createRange]对象的深入解析](https://blog.csdn.net/baidu_33033415/article/details/62882703)    
参考[input中文本选中部分内容](https://www.jianshu.com/p/52373cc9c9d4)
