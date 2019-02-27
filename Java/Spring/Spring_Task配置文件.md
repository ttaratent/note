转自：[关于Spring 任务调度之task:scheduler与task:executor配置的详解](https://blog.csdn.net/weixin_37848710/article/details/79635021)     

## 在配置文件头部加入Task的命名空间
````
<?xml version="1.0" encoding="UTF-8"?>
<beans
xmlns="http://www.springframework.org/schema/beans"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:p="http://www.springframework.org/schema/p"
xmlns:context="http://www.springframework.org/schema/context"
xmlns:aop="http://www.springframework.org/schema/aop"
xmlns:task="http://www.springframework.org/schema/task"
xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-4.0.xsd
http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-4.0.xsd
http://www.springframework.org/schema/aop http://www.springframework.org/schema/aop/spring-aop-4.0.xsd
http://www.springframework.org/schema/task http://www.springframework.org/schema/task/spring-task-4.0.xsd
</beans>
```
## 详细配置

注解方式：
```
<context:annotation-config />
	<!-- 自动调度需要扫描的包 -->
	<context:component-scan base-package="com.honest.sspc.timer" ></context:component-scan>
    <!-- 定时器开关 -->
    <task:executor id="executor" pool-size="5"/>
    <task:scheduler id="scheduler" pool-size="10"/>
    <task:annotation-driven executor="executor" scheduler="scheduler"/>
```
xml配置方式：
```
<context:annotation-config />
    <!-- 自动调度需要扫描的包 -->
    <context:component-scan base-package="com.honest.sspc.timer" ></context:component-scan>
    <!-- 定时器开关 -->
    <task:executor id="executor" pool-size="5"/>    
    <task:annotation-driven executor="executor" scheduler="scheduler"/>    

    <!-- 配置调度 需要在类名前添加 @Service -->  
    <task:scheduled-tasks>  
        <task:scheduled ref="demoTask" method="myTestWork" cron="0/10 * * * * ?"/>  
    </task:scheduled-tasks>
    <task:scheduler id="scheduler" pool-size="10"/>
    <!-- 不通过配置调度,需要在类名前 @Component/@Service,在方法名 前添加@Scheduled(cron="0/5 * * * * ? ")、即用注解的方式-->  
```
## 配置项参数说明
### 调度器：
* task:scheduler/@pool-size：调度线程池的大小，调度线程在被调度任务完成前不会空闲 
* task:scheduled/@cron：cron表达式，注意，若上次任务未完成，即使到了下一次调度时间，任务也不会重复调度
```
<task:scheduled-tasks scheduler="scheduler">  
    <task:scheduled ref="beanID" method="methodName" cron="CronExp" />  
</task:scheduled-tasks>  
<task:scheduler id="scheduler" pool-size="1" />
```
### 执行器
* task:executor/@pool-size：可以指定执行线程池的初始大小、最大大小 
* task:executor/@queue-capacity：等待执行的任务队列的容量 
* task:executor/@rejection-policy：当等待队列爆了时的策略，分为丢弃、由任务执行器直接运行等方式
```
<task:executor id="executor" keep-alive="3600" pool-size="100-200" queue-capacity="500" rejection-policy="CALLER_RUNS" />
```
