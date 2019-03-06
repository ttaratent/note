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

注：我个人实践在Extjs的iframe中使用可以对Form中的相关textfield进行单击选中的功能，但是遇到一定问题暂时没有解决。以下是我处理的方式：    
```
// 如此设置后，在进行焦点触发时，确实会全选，但是之后似乎Ext.form本身后有一个将光标移动到最后的动作，导致全选只触发可一下子
var form = Ext.create('Ext.form.Panel', {
  formName : 'form',
  id : 'form',
  items : [
    {id:'text', fieldLabel : '测试输入', listeners : {
        focus : function (that, event, eOpts) {
          var input = Ext.get(that.inputEl.id).dom;
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
      }}
  ]
  });
```

[createTextRange](https://blog.csdn.net/baidu_33033415/article/details/62882699)
疑似iframe的实现[IFrame 系列4 ---- document.selection 全方位兼容解析以及TextRange[createTextRange,createRange]对象的深入解析](https://blog.csdn.net/baidu_33033415/article/details/62882703)    
参考[input中文本选中部分内容](https://www.jianshu.com/p/52373cc9c9d4)
