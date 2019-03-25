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

ES6中明确允许了在块级作用域中声明函数，但在块级作用域中声明的函数只能在作用域中进行引用。    
在ES5中：
```
function f() {console.log('I am outside!');}

(function() {
  if (false) {
    // 重复声明一次函数f
    function f() { console.log('I am inside!'); }
  }

  f();
  }());
// ES5 中执行结果为I am inside！，原因是函数f会被提前到函数头部：
// ES5 环境
function f() { console.log('I am outside!'); }

(function () {
  function f() { console.log('I am inside!'); }
  if (false) {
  }
  f();
  }());
```
由于改变了块级作用域声明的函数的处理规则，会对老代码产生较大的影响，为了减轻因此产生的不兼容问题，ES6允许浏览器有自己的行为方式：
* 允许在块级作用域内声明函数
* 函数声明类似于`var`，即会提升到全局作用域或函数作用域的头部
* 同时，函数声明还会提升到所在的块级作用域的头部。
在[ECMAscript6入门](http://es6.ruanyifeng.com/#docs/intro)中建议，尽量使用函数表达式，而不是函数声明语句在块级作用域内声明函数。
```
// 函数声明语句
{
  let a = 'secret';
  function f() {
    return a;
  }
}

// 函数表达式
{
  let a = 'secret';
  let f = function() {
    return a;
  }
}
```
ES6的块级作用域允许声明函数的规则，只在使用大括号的情况下成立，如果没用大括号会报错。

### const命令
`const`声明一个只读的常量。一旦声明，常量的值就不能改变。     
根据文中的描述，const命令相当于Java的final命令，保证的是数据存储地址的不变动，而如果需要将对象等复杂数据类型进行常量化，可以使用`Object.freeze`方法
```
const foo = Object.freeze({});

// 还可以将对象的属性也冻结起来
var constantize = (obj) => {
  Object.freeze(obj);
  Object.keys(obj).forEach((key, i) => {
    if(typeof obj[key] === 'object') {
      constantize(obj[key]);
    }
  });
};
```

### ES6声明变量的六种方法： `let`、`const`、`var`、`function`、`import`、`class`

### 顶层对象：在浏览器环境中是`window`对象，在Node指的是`global`对象，在ES6中，`var`命令和`function`命令声明的全局变量，依旧是顶层对象的属性；另一方面规定，`let`命令、`const`命令、`class`命令声明的全局变量，不属于顶层对象的属性。

### global对象
据文中表述的：对于浏览器顶层对象来说，存在标准不统一的问题。
* 浏览器里面，顶层对象是window，但Node和Web Worker没有window
* 浏览器和Web Worker里面，self指向顶层对象，但是Node没有self
* Node里面，顶层对象是global，但其他环境都不支持。
同一段为了能够在各种环境中都能取到顶层对象，现在一般使用this变量，但：
* 全局环境中，this会返回顶层对象，但是Node模块和ES6模块中，this返回的是当前模块。
* 函数里面的this，如果函数不是作为对象的方法运行，而是单纯作为函数运行，this会指向顶层对象，但是，严格模式下，这时this会返回undefined、
* 不管是严格模式，还是普通模式，`new Function('return this')()`，总是会返回全局对象，但是，如果浏览器使用了CSP（Content Security Policy，内容安全策略），那么eval、new Function这些方法都可能无法使用
在[阮一峰的ES6入门](http://es6.ruanyifeng.com/#docs/let)中，阮大大提供了两种勉强使用的方法：
```
// 方法一
(typeof window !== 'undefined'
  ? window
  : (typeof process === 'object' &&
     typeof require === 'function' &&
     typeof global === 'object')
     ? global
     : this);
// 方法二
var getGlobal = function() {
  if (typeof self !== 'undefined') { return self; }
  if (typeof window !== 'undefined') { return window; }
  if (typeof global !== 'undefined') { return global; }
  throw new Error('unable to locate global object');
}
```
一种处理形式，在语言标准的层面，引入global作为顶层对象，也就是在所有环境上，global都是存在的，都可以从它拿到顶层对象。

垫片库`system.global`模拟了这个提案，可以在所有环境拿到global。
```
// 保证代码可以再各种环境中，global对象都是存在的
// CommonJS 的写法
require('system.global/shim')();

// ES6 模块的写法
import shim from 'system.global/shim'; shim();
```

```
// 将顶层对象放入变量global中
// CommonJS 的写法
var global = require('system.global')();

// ES6 模块的写法
import getGlobal from 'system.global';
const global = getGlobal();
```
