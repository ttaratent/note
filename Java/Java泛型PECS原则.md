转载：[狐狸糊涂-Java泛型PECS原则](https://my.oschina.net/foxty/blog/1582396)

我们偶尔会看到针对泛型的一些用法：比如<? extends T> 和 <? super T>，那么这两种定义有什么区别？分别适合用在什么场合？ 在回答这2个问题之前，我们先看一下几个相关的例子:

假设我们有5个类，结构如下：
```
class Animal {
}

class Dog extends Animal {
}

class SmallDog extends Dog {
}

class BigDog extends Dog {
}

class Cat extends Animal {
}
```

### 理解<? extends T> 的限制
```
public static void producerExtends(List<? extends Animal> animals) {
    // 读取animals
    Animal a1 = animals.get(0);

    // 添加animal
    //animals.add(new Animal());     //编译错
    //animals.add(new Dog());        //编译错
}


public static void main(String[] args) {
    List<Dog> dogs = new ArrayList<Dog>();
    dogs.add(new Dog());
    producerExtends(dogs);
}
```
把以上代码放入IDE中并且取消添加animal下方的注释后，animals.add(new Animal())/animals.add(new Dog())均提示编译错。为什么读取没有问题，但是写入会报错呢？

animals是一个List<? extends Animal>类型，其中对象必须是Animal或其后代类，读取的时候可以的安全的转换成Animal类型。

那为什么添加Animal和Dog就编译错呢?

因为会违反类型安全(violate type safe)，animals在例子中是List<Dog>，但是也可以是 List<BigDog>, List<SmallDog>, List<Cat>。这个时候向容器写入对象的时候无法做类型安全检查（比如 List<Dog>是无法添加Animal类型），所以就禁止写入任何对象。

因为这个特性，所以说<? extnebds T>适合进行读取操作，不能写入，也就是PECS中的PE(Producer Extends)。

<font color="red">注意：不能写入不代表不能修改List，还是可以调用list.clear()方法清空列表。</font>

### 理解<? super T>的限制
```
public static void consumerSuper(List<? super SmallDog> dogs) {
    dogs.add(new SmallDog());

    //dogs.add(new Dog());         //编译错
    //SmallDog dog1 = dogs.get(0);       //编译错

}

public static void main(String[] args) {

    List<Animal> animals = new ArrayList<>();
    animals.add(new Animal());
    animals.add(new BigDog());
    consumerSuper(animals);
}
```
如果理解了之前对于<? extends T>的解释，这里应该就更好理解了。这里对于添加Dog对象没问题，但是添加Animal或者读取都会编译错。

为什么add(new Dog())编译错？因为这里的<? super SmallDog>限制了传入的list中的对象必须是SmallDog或其父类（具体类型未知，可能是Animal，也可能是Dog），所以添加的对象必须是SmallDog或其子类，这样才能保证类型安全。

为什么SmallDog dog1 = dogs.get(0)编译错？因为这个list中的对象可能是SmallDog的任意祖先，是无法保证一定可以转化成SmallDog类型 （父类转化为子类必会失败 ClassCastException）。

<font color="red">所以说<? super T>适合进行写操作，不能读取，也就是PECS中的CS(Consumer Super)。</font>

这就是Java泛型中的PECS (Producer Exnteds Consumer Super)，如果说还是不了解应用场景的话，可以看看JDk自带的 Collections.addAll()和Collection.addAll()各自函数的定义有什么区别。
