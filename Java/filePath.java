// 获取路径的几种方式
// 一、获取可执行jar包所在目录
// 1
System.getProperty("java.class.path");
// 获取classpath的路径，若没有其他依赖，在cmd下运行该可执行jar包，则该值即为该jar包的绝对路径。

String file = System.getProperty("java.class.path");
String pathSplist = System.getProperty("path.separator"); // 得到当前操作系统的分隔符

if (filePath.contains(pathSplit)) {
	filePath = filePath.substring(0, filePath.indexOf(pathSplit));
} else if (filePath.endsWith(".jar")) { // 截取路径中的jar包名，可执行jar包运行的结果里包含.jar
	filePath = filePath.substring(0, filePath.lastIndexOf(File.separator) + 1);
}
System.out.println("jar包所在目录:"+filePath);

// 2
ClassName.class.getProtectionDomain().getCodeSource().getLocation().getPath();

// 但是这种方法不支持中文，需要使用以下代码方法，进行转换
// 获取当前可执行jar包所在目录
URL url = JarTest.class.getProtectionDomain().getCodeSource().getLocation();
try {
	filePath = URLDecoder.decode(url.getPath(), "utf-8"); // 转化为utf-8编码，支持中文
} catch (Exception e) {
	e.printStackTrace();
}
if (filePath.endsWith(".jar")) { // 可执行jar包运行的结果里包含.jar
	// 获取jar包所在目录
	filePath = filePath.substring(0, filePath.lastIndexOf("/") + 1);
}

File file = new File(filePath);
filePath = file.getAbsolutePath(); // 得到windows下的正确路径
System.out.println("jar包所在目录:" + filePath);

// 二、获取当前JVM运行目录
System.getProperty("user.dir");

// 三、获取jar包内的资源文件
// 文件与classes在同一目录下，或者使用maven构建时，文件存在于resources文件夹下，可以使用getResourceAsStream
InputStream is = JarTest.class.getResourceAsStream("/test.txt");
BufferedReader br = new BufferedReader(new InputStreamReader(is));
String s = "";
try {
	while((s=br.readLine()!=null)
		System.out.println(s);
} catch (IOException e) {
	e.printStackTrace();
}