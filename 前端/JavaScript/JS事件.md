### JS事件处理
[JS自定义事件的定义和触发(createEvent, dispatchEvent)](https://www.cnblogs.com/stephenykk/p/4861420.html)

[js事件绑定的几种方式](https://www.cnblogs.com/javawebstudy/p/5266168.html)

[谈谈JS的观察者模式（自定义事件）](https://www.cnblogs.com/LuckyWinty/p/5796190.html)

基础的input等一些标签绑定以申明的事件主要通过：`document.getElementById("demo").onclick=function(){}`进行
自定义事件主要根据浏览器的类型进行对应的方法，进行事件的绑定：
**addEventListener()函数： **    
elmentObject.addEventListener(eventName,handle,useCapture);    

| 参数 | 说明 |
| :--: | :--: |
|elementObject|DOM对象(即DOM元素)|
|eventName|事件名称。注意，这里的事件名称没有"on"，如鼠标单击事件click，鼠标双击事件doubleclick，鼠标移入事件mouseover，鼠标移出事件mouseout等。|
|handle|事件句柄函数，即用来处理事件的函数。|
|useCapture|Boolean类型，是否使用捕获，一般用false。这里涉及到JavaScript事件流的概念。|

**attachEvent()函数语法：**    
elementObject.attachEvent(eventName,handle);   

|参数|说明|
|:--:|:--:|
|elementObject|DOM对象(即DOM元素)|
|eventName|事件名称。注意，这里与addEventListener()不同，这里的事件名称有"on"，如鼠标单击事件onclick，鼠标双击事件ondoubleclick，鼠标移入事件onmouseover，鼠标移出事件onmouseout等|
|handle|事件句柄函数，即用来处理事件的函数（函数名）|

addEventListener()是标准的绑定事件监听函数的方法，是W3C所支持的，Chrome、FireFox、Opera、Safari、IE9.0及其以上版本都支持该函数；但IE8及以下版本不支持该方法，通常使用attachEvent()来绑定事件监听函数。
