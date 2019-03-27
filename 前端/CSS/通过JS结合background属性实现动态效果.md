今天看到度娘的元宵节的Logo，感觉挺有趣的，一个动态的灯笼的样子，挺好奇是如何做到的。    
仔细学习了下，发现是结合了background的position属性将一个长图通过JS动态修改CSS样式中background-position的左右定位，调整展示的图像，让人视觉误认为是一个动态的动画效果。感觉上使用这种的原因可能是相对于动图文件来说，这种方式文件的大小相对来说更小，通过客户端浏览器脚本的形式进行“伪动画”处理，感觉苦了美工。。    
```
<html>
<div style="position: absolute; top: 0px; left: 50%; background: url('../imgages/yuanxiaoLogo.jpg') 0px 0px no-repeat; cursor: pointer; width: 270px; height: 129px; margin-left: -135px;" title="灯月相伴，中宵团圆"></div>
</html>
```
