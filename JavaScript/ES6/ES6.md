## ECMAScript 6标准
引用：[阮一峰的ES6入门](http://es6.ruanyifeng.com/#docs/intro)    
ES6-ECMAScript 6是JavaScript的下一代标准，ES6在2015年6月起正式发布，之后根据标准委员会决定每年6月份正式发布一次，作为当年的正式版本，这样一来，就不需要原来的版本号，而是使用年份做为标记。ES6的第一个版本在2015年6月正式发布，正式名称为《ECMAScript 2015标准》（简称ES2015），之后于2016年6月，小幅修订《ECMAScript 2016标准》（简称ES2016）如期发布，因此，ES6既是一个历史名词，也是一个泛指，含义是5.1版以后的JavaScript的下一代标准。    

常见的ES6、ES5转码器主要有Babel、Traceur、命令行转码器等

let命令：
* 用于在ES6中进行变量的声明，被通过let声明的变量，只有在声明的代码块内有效，当在外部调用通过let声明的变量时会报错`ReferenceError: i is not defined`。在[阮一峰的ES6入门-let](http://es6.ruanyifeng.com/#docs/let)中，通过：
```
// 由于i为var声明导致任意a[i]在输出时，指向全局变量i -- 10
var a = [];
for(var i = 0; i < 10; i++) {
  a[i] = function() {
    console.log(i);
  }
}
a[6](); // 10

// 感觉是在定义a[i]这个function的时候i值已经确定了，所以对于此时函数的值是固定的，而不会随着i的变化而变化
var a = [];
for(let i = 0; i < 10; i++) {
  a[i] = function() {
    console.log(i);
  }
}
a[6](); // 6
```
其中提及，`for`循环设置变量的部分是一个父作用域，而循环体内部是一个单独的子作用域。
```
for (let i = 0; i < 3; i++) {
  let i = 'abc';
  console.log(i);
}
// abc
// abc
// abc
```

* 通过var声明变量时，在声明之前使用时，值为undefined。而使用let之后，则会报错。
* 暂时性死区（temporal dead zone，简称 TDZ） 通过let声明的变量时，会暂时屏蔽原有的同名全局变量，（const命令中也会出现）
* 不允许在相同作用域中重复声明

## 加入块级作用域
ES6中加入了块级作用域，防止变量的溢出，而在ES5中，可能需要一个立即执行函数表达式(IIFE)进行数据约束：
```
// IIFE
(function() {
  // do something
  }());

// 块级作用域
{
  // do something
}
```
