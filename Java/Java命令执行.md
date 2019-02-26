# 在Linux下面ClassPath前面是一个点号加一个冒号； 在Windows下面ClassPath前面是一个点号加一个分号。

Linux： java -Dfile.encoding=utf8 -cp .:./lib/commons-lang-2.6.jar:./lib/log4j-1.2.15.jar Mytest

Windows：java -Dfile.encoding=gbk -cp .;./lib/commons-lang-2.6.jar;./lib/log4j-1.2.15.jar Mytest



# 由于 -cp 参数不能用通配符，当依赖 jar 文件都在同一目录，可通过 -Djava.ext.dirs 指定目录。

# 注意： java中系统属性java.ext.dirs指定的目录由ExtClassLoader加载器加载，如果您的程序没有指定该系统属性（-Djava.ext.dirs=sss/lib）那么该加载器默认加载$JAVA_HOME/lib/ext目录下的所有jar文件。但如果你手动指定系统属性且忘了把 $JAVA_HOME/lib/ext 路径给加上，那么ExtClassLoader不会去加载$JAVA_HOME/lib/ext下面的jar文件，这意味着你将失去一些功能，例如java自带的加解密算法实现。

java -Djava.ext.dirs=lib Mytest



# 如果在MANIFEST.MF里配置了Main-Class，可以直接执行jar文件

java -jar xxx.jar



# 如果程序中需要解析在  classpath 下的一些配置文件，则可以将这些配置文件放到一个目录下，并使用 -classpath 指定

java -Djava.ext.dirs=lib -classpath conf  com.test.MyTest



-------------------------------------------------------------------------------------------------------------------------------------

总结下（在Linux环境下）：

1. 如果所有 jar 包都在 lib 目录下，配置文件在 conf 目录下：

java  -Dfile.encoding=utf8  -Djava.ext.dirs=./lib  -classpath  ./conf   com.test.MyTest



2. 如果所有依赖 jar 包在 lib 目录下，但是 主程序 jar 包在别的目录下，则要结合 -cp；此时就不能使用 -classpath conf 来指定配置文件目录了，必须要放到 -cp 下，将 conf 目录和 主程序 jar 连接在一起：

java  -Dfile.encoding=utf8  -Djava.ext.dirs=./lib  -cp ./conf:./test.jar   com.test.MyTest



3. 不使用 -Djava.ext.dirs ，仍然使用 -cp，则使用程序循环 jar 包拼接路径：
```
app_path=.
jars_path=$app_path/lib
conf_path=$app/conf

jars=`find $jars_path -name "*.jar"`

cp_env=$conf_path

for jar in jars
do
    cp_env=$cp_env:$jar
done

# 如果Main方法所在的主 jar 包，不在 lib 目录下，则需要再把主 jar 包也接入 cn_env
# cp_env=$cp_env:$app_path/test.jar

exec java -Dfile.encoding=utf8 -cp "$cp_env"  com.test.MyTest
```


转[原文地址](https://my.oschina.net/jsan/blog/657819)
