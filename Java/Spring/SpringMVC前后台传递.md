前台通过Jquery的请求进行：
```
$.ajax({
  type:"POST",
   async:false,
   dataType:'json',
   contentType : "application/json;charset=utf-8",
   url:"",
   data: JSON.stringify({data1:'',col:'',text:''}),
   success:function (data) {

           }
  });
```
当前台设置contentType为application/json时，需要对data进行对应的序列化，之后后台可以通过注解@RequestBody获取对应的数据如下：
```
@RequestMapping(value = "...")
public @ResponseBody Map<String, Object> test2(@RequestBody com.alibaba.fastjson.JSONObject json) {
  String data1 = json.getString("data1");
  String col = json.getString("col");
  String text = json.getString("text");
  // todo somethings
}
```

当前台不设置contentType为application/json时，无需对data进行序列化，后台可以通过对应的字段名获取对应的值

```
$.ajax({
  type:"POST",
   async:false,
   dataType:'json',
   url:"",
   data: {data1:'',col:'',text:''},
   success:function (data) {

           }
  });
```
后台代码：
```
@RequestMapping(value = "...")
public @ResponseBody Map<String, Object> test1(String data1, String col, String text) {
  // todo somethings
}
```
