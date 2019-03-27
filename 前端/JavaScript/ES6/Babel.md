#### [Babel](https://www.jb51.net/article/135225.htm)
Babel转码器：Babel是一个广泛使用的ES6转码器，可以将ES6代码转为ES5代码，从而在现有环境执行，这意味着，可以用ES6的方式编写程序，而不用担心现有环境是否支持。
安装Babel：
```
npm install --save-dev @babel/core
```
在使用Babel之前需要配置`.babelrc`文件，该文件用来设置转码规则和插件，基本格式如下：
```
{
  "presets":[],
  "plugins":[]
}
```
大致可分为以下三项：    
1. 语法转译器。主要对javascript最新的语法糖进行编译，并不负责转译javascript新增的api和全局对象。例如：let/const就可以被编译，而includes/Object.assign德等并不能被编译。常用的转译器包有：babel-preset-env、babel-preset-es2015、babel-preset-es2016、babel-preset-es2017、babel-preset-latest等，在实际开发中可以只选用babel-preset-env来代替余下的，但是官方推荐还需要配上javascript的制作规范一起使用。
2. 补丁转译器。主要负责转译javascript新增的api和全局对象，例如babel-plugin-transform-runtime这个插件能够编译Object.assign，同时也可以引入babel-polyfill进一步对includes这类用法保证在浏览器的兼容性。
3. jsx和flow插件，这类转译器用来转译JSX语法和移除类型声明的，使用React的时候将会用到它，转译器名称为babel-preset-react

```
{
  "presets":[
  ["env"， options],
  "stage-2"
  ]
}
```
babel主要提供4中类型的转译器包，括号里面是对应配置文件的配置项，其中stage-0包含stage-1，以此类推
```
babel-preset-stage-0(stage-0)
babel-preset-stage-1(stage-1)
babel-preset-stage-2(stage-2)
babel-preset-stage-3(stage-3)
```
