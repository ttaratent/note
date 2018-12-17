### Spring + Mybatis 配置笔记
Spring+SpringMVC+Mybatis整合的配置文件主要包括
appliactionContext.xml（Spring容器的配置文件）
mvc-dispatcher-servlet.xml（SpringMVC容器的配置文件）

参考[Spring+SpringMVC配置加载顺序](https://blog.csdn.net/xiao__oaix/article/details/76719200)    
Spring Web应用加载顺序：XML版
1. Web容器创建
2. 上下文创建，但暂不进行初始化
3. 监听器创建，并注册到Context上
4. 上下文初始化
5. 通知到监听者，Spring配置文件/@Configuration加载
6. load-on-startup>0的，ServletConfig创建，springMVC的
7. DispatcherServlet此时创建
8. SpringMVC上下文创建

P.S.: Spring容器是SpringMVC的父容器
所以需要留意的地方是，如果配置文件的先后顺序存在问题，可能会导致部分功能异常，例如：事务管理（如果对于Service的扫描已在spring配置文件中执行了，可能在springMVC中这部分扫描就会自动忽略）

JavaConfig版：    
1. Servlet3.0+容器，根据classpath下jar文件的META-INF信息，决定使用SpringServletContainerInitializer，并在创建出一个ServletContext后进行下一步；
2. 扫描cp，将WebApplicationInitializer的实现类封装成Set传给SSCI；
3. onStartup方法将Initializer按照onstartup级别排序，并调用每个Initializer的onStartup(ServletContext)方法；
4. 注册监听器，等待启动；
5. 其他操作
6. 处理完毕后，Servlet容器会对Context进行初始化，此时会通知监听器

其中在SpringMVC的配置中，与映射文件相关的内容包括：    
```
<!-- 配置映射文件 -->
<bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
  <property name="dataSource" ref="dataSource"/>
  <!-- 自动扫描路径下的文件 -->
  <!-- <property name="mapperLocations" value="classpath:mybatis/**/*.xml"/> -->
  <!-- 通过配置文件配置mapper与xml的关联 -->
  <property name="configLocation" value="classpath:mybatis-config.xml"/>
</bean>

<!-- DAO接口所在的包名，Spring会自动查找其下的类 -->
<bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
  <property name="basePackage" value="com.mapper"/>
  <property name="sqlSessionFactoryBeanName" value="sqlSessionFactory" />
</bean>
```


--- 待续
