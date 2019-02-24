[深入理解ajax系列第一篇---XHR对象](https://www.cnblogs.com/xiaohuochai/p/6036475.html)    
Ajax的基础XHR对象，IE5-IE7时是通过new ActiveXObject('Microsoft.XMLHTTP')创建一个XHR对象，而在这之后直接通过new XMLHttpRequest()进行创建。一个XHR对象对应着一个AJAX请求，所以多个请求需要多个XHR对象进行处理。    
XHR对象通过open进行请求的发送：    
```
xhr.open("get", "example.php", false);
```
1. open()方法的第一个参数定义了请求发送的方式，，不区分大小写，例如：
* GET：获取资源
* POST：传输实体主体
* PUT：传输文件
* HEAD：获取报文首部
* DELETE：删除文件
* OPTIONS：询问支持的方法
* TRACE：追踪路径
* CONNECT：要求用隧道协议连接代理
2. open()方法的第二个参数为URL路径，仅对于执行代码的当前页面，而只能向同一个域中使用相同端口协议的URL发送请求。
3. 第三个的参数为异步值，默认为TURE，表示异步发送。
4. 如果请求一个受密码保护的服务器URL，第四第五个参数分别为登录名和密码。

xhr.send()接收一个参数，作为请求的发送参数，如果为get请求的话发参数或设置为null。

一个正确的请求相应包含四个属性：
1. responseText: 作为响应主体被返回的文本（文本形式）
2. responseXML: 如果响应的内容类型是'text/xml'或'application/xml'，这个属性中将保存着响应数据的XML DOM文档（document形式）
3. status: HTTP状态码（数字形式）
5. statusText: HTTP状态说明（文本形式）

```
if(xhr.status >= 200 && xhr.status <300 ||xhr.status == 304) {
  alert(xhr.responseText);
} else {
  alert('request was unsuccessful:' + xhr.status);
}
```
