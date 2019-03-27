1. 无论是否在严格模式下，全局执行环境中，this都指向全局对象。
2. 函数的this的取值取决于函数运行时的调用对象。

Javascript中函数调用是以栈的方式来存储的，当进行函数调用时，会在将调用对象放入栈中，调用完成后，再进行出栈。

apply语法：func.apply(thisArg, [argsArray])

call语法：func.call(thisArg, arg1, arg2, ...)

apply第二个参数接受的是一个参数数组，而call接受的是不限数量的参数
（如果thisArg为基础类型，则this执行基础类型的包装类）

bind：将函数绑定this，并返回该函数，并不执行函数。
语法：func = func.bind(thisArg[, arg1 [, arg2[, ...]]]);

原型链中的this指向其实例化的对象。

[前端进击的巨人（六）：知否知否，须知this](https://www.cnblogs.com/kenz520/p/10335231.html)    
[Javascript中的词法作用域、动态作用域、函数作用域和块作用域（四）](https://www.cnblogs.com/yy95/p/9703257.html)
