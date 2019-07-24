具体出现的情况有：
1. 请求未完全发出，在chrome中显示请求状态(canceled)
2. 请求发出状态200成功，但response中无数据

可能的原因是由于，提交的<button>未设置`type="button"`的问题，例如：
```
<form >
<input type="text" />
<button name="sub"/>
</form>
```
应该为button加上type属性
