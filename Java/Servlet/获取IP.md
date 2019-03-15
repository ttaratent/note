### 如何通过javax.servlet.http.HttpServletRequest请求对象获取客户端IP：

```
public class UtilIp {
	/**
	 * 获取客户端和代理服务器IP
	 * @param request
	 * @return
	 */
	public static String getIpAddress(HttpServletRequest request) {
		StringBuffer sf = new StringBuffer();
	    String ip = request.getHeader("x-forwarded-for");
	    if (ip != null || ip.length() != 0 || (!"unknown".equalsIgnoreCase(ip))) {
	    	sf.append(ip).append(",");
	    }
	    ip = request.getHeader("Proxy-Client-IP");
	    if (ip != null || ip.length() != 0 || (!"unknown".equalsIgnoreCase(ip))) {
	    	sf.append(ip).append(",");
	    }
	    ip = request.getHeader("WL-Proxy-Client-IP");
	    if (ip != null || ip.length() != 0 || (!"unknown".equalsIgnoreCase(ip))) {
	    	sf.append(ip).append(",");
	    }
	    ip = request.getHeader("HTTP_CLIENT_IP");
	    if (ip != null || ip.length() != 0 || (!"unknown".equalsIgnoreCase(ip))) {
	    	sf.append(ip).append(",");
	    }
	    ip = request.getHeader("HTTP_X_FORWARDED_FOR");
	    if (ip != null || ip.length() != 0 || (!"unknown".equalsIgnoreCase(ip))) {
	    	sf.append(ip).append(",");
	    }
	    ip = request.getHeader("X-Real-IP");
	    if (ip != null || ip.length() != 0 || (!"unknown".equalsIgnoreCase(ip))) {
	    	sf.append(ip).append(",");
	    }
	    ip = request.getRemoteAddr();
	    if (ip != null || ip.length() != 0 || (!"unknown".equalsIgnoreCase(ip))) {
	    	sf.append(ip).append(",");
	    }
	    if (sf.length() > 1) {
	    	sf.delete(sf.length()-1, sf.length());
	    }
	    return sf.toString();
	}

}
```

研究了下涉及的报文头，其中x-forwarded-for可能与Nginx等代理服务器的代理有关，在通过Nginx进行代理过程中，代理服务器会根据配置添加代理信息，这部分代理信息添加在了X-Forwarded-For中，通过逗号连接。而X-Real-IP则是一个变量，后者的相关配置会覆盖之前的内容，所以一般获取到的是最后一个设置该属性的代理服务器之前的那个地址，而由于X-Real-IP是通过覆盖进行传递的，所以通过伪造该属性对于IP来说没有影响，仍取决与最后一个代理服务器，若代理服务器未配置相关属性，则会使用伪造的这个值。

* WL_Proxy_Client_IP：是WebLogic系统对于request对象再包装之后特有的请求头信息。
* Proxy-Client-Ip：是Apache Http代理时对于request对象添加的请求头。
* X-Forwarded-For：这是一个 Squid 开发的字段，只有在通过了HTTP代理或者负载均衡服务器时才会添加该项。
* X-Real-IP：nginx代理一般会加上此请求头
* HTTP_CLIENT_IP：代理服务器一般会加上，但未成标准
* HTTP_VIA
* HTTP_X_FORWARDED-FOR
* REMOTE_ADDR 绝对真实，是与你通过HTTP协议三次握手通信的IP地址，但可能是代理服务器等     

这里摘录一篇博文[php中HTTP_X_FORWARDED_FOR 和 REMOTE_ADDR的使用](https://www.cnblogs.com/andhm/archive/2010/12/18/1910030.html)（主要是这个博主好像迁移([网址](http://huangmin.sinaapp.com/))了，但迁移的路径无效，此处进行引用）：
```
php中HTTP_X_FORWARDED_FOR 和 REMOTE_ADDR的使用
1.REMOTE_ADDR:浏览当前页面的用户计算机的ip地址
2.HTTP_X_FORWARDED_FOR: 浏览当前页面的用户计算机的网关
3.HTTP_CLIENT_IP:客户端的ip

在PHP 中使用 $_SERVER["REMOTE_ADDR"] 来取得客户端的 IP 地址，但如果客户端是使用代理服务器来访问，那取到的就是代理服务器的 IP 地址，而不是真正的客户端 IP 地址。要想透过代理服务器取得客户端的真实 IP 地址，就要使用 $_SERVER["HTTP_X_FORWARDED_FOR"] 来读取。

不过要注意的事，并不是每个代理服务器都能用 $_SERVER["HTTP_X_FORWARDED_FOR"] 来读取客户端的真实 IP，有些用此方法读取到的仍然是代理服务器的 IP。

还有一点需要注意的是：如果客户端没有通过代理服务器来访问，那么用$_SERVER["HTTP_X_FORWARDED_FOR"] 取到的值将是空的。

if ($_SERVER['HTTP_X_FORWARDED_FOR'] && preg_match('/^([0-9]{1,3}\.){3}[0-9]{1,3}$/',$_SERVER['HTTP_X_FORWARDED_FOR'])) {  
      $onlineip = $_SERVER['HTTP_X_FORWARDED_FOR'];  
} elseif  ($_SERVER['HTTP_CLIENT_IP']  && preg_match('/^([0-9]{1,3}\.){3}[0-9]{1,3}$/',$_SERVER['HTTP_CLIENT_IP'])) {  
      $onlineip = $_SERVER['HTTP_CLIENT_IP'];
}

获取用户IP地址的三个属性的区别 (HTTP_X_FORWARDED_FOR,HTTP_VIA,REMOTE_ADDR)
一、没有使用代理服务 器的情况：

REMOTE_ADDR = 您的 IP
HTTP_VIA = 没数值或不显示
HTTP_X_FORWARDED_FOR = 没数值或不显示

二、使用透明代理服务器的情 况：Transparent Proxies

REMOTE_ADDR = 最后一个代理服务器 IP
HTTP_VIA = 代理服务器 IP
HTTP_X_FORWARDED_FOR = 您的真实 IP ，经过多个代理服务器时，这个值类似如下：203.98.182.163, 203.98.182.163, 203.129.72.215。

这类代理服务器还是将您的信息转发给您的访问对象，无法达到隐藏真实身份的目的。

三、使用普通匿名代理服务器的情况：Anonymous Proxies

REMOTE_ADDR = 最后一个代理服务器 IP
HTTP_VIA = 代理服务器 IP
HTTP_X_FORWARDED_FOR = 代理服务器 IP ，经过多个代理服务器时，这个值类似如下：203.98.182.163, 203.98.182.163, 203.129.72.215。

隐藏了您的真实IP，但是向访问对象透露了您是使用代理服务器访问他们的。

四、使用欺骗性代理服务器的情况：Distorting Proxies

REMOTE_ADDR = 代理服务器 IP
HTTP_VIA = 代理服务器 IP
HTTP_X_FORWARDED_FOR = 随机的 IP ，经过多个代理服务器时，这个值类似如下：203.98.182.163, 203.98.182.163, 203.129.72.215。

告诉了访问对象您使用了代理服务器，但编造了一个虚假的随机IP代替您的真实IP欺骗它。

五、使用高匿名代理服务器的情况：High Anonymity Proxies (Elite proxies)

REMOTE_ADDR = 代理服务器 IP
HTTP_VIA = 没数值或不显示
HTTP_X_FORWARDED_FOR = 没数值或不显示 ，经过多个代理服务器时，这个值类似如下：203.98.182.163, 203.98.182.163, 203.129.72.215。

完全用代理服务器的信息替代了您的所有信息，就象您就是完全使用那台代理服务器直接访问对象。
```

引用参考：[UtilIp ](https://github.com/15172658790/testClass/blob/master/src/com/zys/UtilIp.java)    
[HTTP 请求头中的 X-Forwarded-For，X-Real-IP](https://www.cnblogs.com/diaosir/p/6890825.html)
[干货：Java正确获取客户端真实IP方法整理](https://blog.csdn.net/youanyyou/article/details/79406454)    
[获取客户端IP](https://segmentfault.com/q/1010000000686700)    
[简书：HTTP 请求头中的 X-Forwarded-For](https://www.jianshu.com/p/15f3498a7fad)
