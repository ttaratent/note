[参考](https://bbs.csdn.net/topics/392308967)
Java :
```
// 通过向HttpServletResponse设置Cookie，并设置该Cookie的生命周期为较短的时间
HttpServletResponse res; // 在Servlet中请求中可以获取
Cookie cookie = new Cookie("myCookie","success");
cookie.setMaxAge(2);
res.addCookie(cookie);
```

Extjs :
```
var expForm = Ext.create('Ext.form.Panel', {
  formName : 'expForm',
  id : 'expForm',
  standardSubmit : true,
  items : []
});

function downloadBb(id, name) {
  var time = null;
  loading(); // 遮幕
  var p = {
    id : id,
    name : name
  };
  expForm.getForm().sumbit({
    url : 'download.x',
    method : 'POST',
    submitEmptyText : false,
    params : p
  });

  time = setInterval(function() {
    var tmp = Ext.util.Cookies.get("myCookie");
    if(tmp == 'success') {
      loaded(); // 取消遮幕
      clearInterval(time);
      Ext.util.Cookies.clear('myCookie');
    }
  }, "1000");
}
```
