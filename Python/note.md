Python
```
def func(args):
  print(args)

func("test")
```    

是通过回车，来进行一个函数定义的结束，而

```
def f(args1: "参数注释", args2: str = 'args2') -> "返回值注释" :
  print("Annotations:", f.__annotations__)
  print("Arguments:", args1, args2)
  return args1 + ' and ' + args2
```
在参数传递时，`:`用于参数的注释；在参数之后的`->`是用于返回值的注释
