### n=n >>> 0 或者  n>>>=0
该步骤将进行一下操作：
不仅仅将n进行数据类型的转换，转为number类型，同时也将数据类型转位32位bit类型，也就是Uint32。

### void 0
在JavaScript中，void是一个函数，接受一个参数并永远返回undefined。
this === void 0  即表示判断this对象是否为undefined。

### JavaScript call和apply方法：
* 继承（对象的继承）    
call()和apply()的第一个实参是要调用函数的母对象，它是调用上下文，在函数体内通过this来获得对它的引用。要想以对象o的方法来调用函数f()，可以这样使用call()和apply():
```
f.call(o)
f.apply(o)
// 每行代码和下面代码的功能类似
o.m = f;    // 将f存储为o的临时方法
o.m();      // 调用它，不传入参数
delete o.m; // 将临时方法删除
```
在ECMAScript5的严格模式中，call()和apply()的第一个实参都会变为this的值，
哪怕传入的实参是原始值甚至是null或undefined。在ECMAScript3和非严格模式中，传入的null和undefined都会被全局对象代替，而其他原始值则会被相应的包装对象(wrapper object)所替代
* 修改函数运行时的this指针    
贴吧大神的例子：    
```
var each = function(array, fn) {
  for(var index = 0; index < array.length; index++) {
    fn(index, array[index]);
  }
};
each([2,3,5], function(){
  console.log(this);
});
// VM683:2 Window {postMessage: ƒ, blur: ƒ, focus: ƒ, close: ƒ, parent: Window, …}
// VM683:2 Window {postMessage: ƒ, blur: ƒ, focus: ƒ, close: ƒ, parent: Window, …}
// VM683:2 Window {postMessage: ƒ, blur: ƒ, focus: ƒ, close: ƒ, parent: Window, …}
var each = function(array, fn) {
  for(var index = 0; index < array.length; index++) {
    fn.call(array[index],index, array[index]);
  }
};
each([2,3,5], function(){
  console.log(this);
});
// Number {2}__proto__: Number[[PrimitiveValue]]: 2
// VM686:7 Number {3}
// VM686:7 Number {5}
```
