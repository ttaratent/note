// 参考http://www.cnblogs.com/ggjucheng/p/3352519.html

// 在JVM中并没有泛型这一概念
// 泛型主要是用户在编译之前对代码进行的一种约束
// 泛型示例
public class Pair<T> {
	private T first = null;
	private T second = null;
	
	public Pair(T fir, T sec) {
		this.first = fir;
		this.second = sec;
	}
	
	public T getFirst() {
		return this.first;
	}
	
	public T getSecond() {
		return this.second;
	}
	
	public void setFirst(T fir) {
		this.first = fir;
	}
}

// 1、Generic class 创建对象
Pair<String> pair1 = new Pair("string", 1);   // 1
Pair<String> pair2 = new Pair<String>("String", 1); //2

// 1代码在编译器不会出错 2代码在编译器会检查出错误
// 重点：
// （1）JVM本身并没有泛型对象，所有泛型对象在编译器中会全部变成普通对象
// 所以在代码1中的编译是能够通过的，对于String以及Integer对象来说，都属于Object类型
// 但是一旦执行pair1.getSecond()时就会抛出ClassCastException异常，这是因为，在1中
// 对于JVM来说，会根据第一个string参数类型定义出T类型为“String”类型，所以再返回Second的时候，期望返回String类型
// 但事实上编译器以默认将second变量定义为值为1的Integer类型，就不符合JVM运行要求了

// 代码2中，会在编译器报错，是因为实例对象以指明了具体的对象类型。

// 2、JVM如何理解泛型概念 -- 类型擦除
// JVM并不知道泛型，所以泛型在编译阶段就已经被处理成了普通类和方法
// 处理方法很简单，类型变量T的擦除（erased）
// 无论如何定义泛型类型，相应的都会有一个原始类型被自动提供，原始类型的名字就是擦除类型参数的泛型类型的名字
//   如果泛型类型的类型变量没有限定<T>，那么就用Object作为原始类型
//   如果有限定(<T extends XClass>)，就将XClass作为原始类型
//   如果有多个限定(<T extends XClass1&XClass2>)，就用第一个边界变量类型XClass1作为原始类型

// 3、泛型约束和局限性--类型擦除所带来的麻烦
// 1）继承泛型类型的多态麻烦（--子类没有覆盖住父类的方法）
class SonPair extends Pair<String>{
	public void setFirst(String fir){...}
}
// 本意想在SonPair类中覆盖父类Pair<String>的setFirst(T fir)这个方法，但由于泛型的缘故，父类实际方法为setFirst(Object)，没有覆盖掉
// 编译器通过自动创建一个桥方法来覆盖父类对象
public void setFirst(Object fir) {
	setFirst(String fir);
}
// 通过桥方法成功覆盖了父类对象

// 如果需要对getFirst()进行覆盖呢？
// 由于需要桥方法，所以编译器自动在SonPair中生成一个public Object getFirst()桥方法
// 但SonPair中出现了两个方法签名一样的方法(只是返回类型不同)

// 方法签名 确实只有方法名+参数列表
// 人为无法编写方法签名一样的多个方法，但编译器自己可以，
// 重点：JVM会用参数类型和返回类型来确定一个方法，一旦编译器通过某种方式自己编译出方法签名一样的两个方法(只能编译器自己来创造)，JVM是能够分辨的，前提是返回类型不一样。

// 泛型对象没有equals方法
public class Pair<T> {
	public boolean equals(T value) {
		return (first.equals(value));
	}
}
// Error Name clash: The method equals(T) of type Pair<T> has the same erasure as equals(Object) of type Object but does not overriede it


// 3）没有泛型数组
Pair<String>[]  stringPairs = new Pair<String>[10];
Pair<Integer>[] intPairs = new Pair<Integer>[10];
// Cannot create a generic array of Pair<String>的错误
// 泛型擦除之后，Pair<String>[]会变成Pair[],进而又可以转换为Object[]
// 理论上将Object[]可以存储所有Pair对象，但这些Pair对象是泛型对象，他们的类型变量都不一样，那么调用每一个Object[]
// 数组元素的对象方法可能都会得到不同的记过，这对于JVM是无法预料的

// 重点：数组必须牢记它的元素类型，也就是所有的元素对象都必须一个样，泛型类型恰恰做不到这一点。

// 总结 ： 泛型代码与JVM
// 1、虚拟机中没有泛型，只有普通类和方法
// 2、在编译阶段，所有泛型类的类型参数都会被Object或者它们的限定边界来替换。（类型擦除）
// 3、在继承泛型类型的时候，桥方法的合成是为了避免类型变量擦除所带来的多态灾难

