### SpringMVC事务处理
[Spring事务管理只对出现运行期异常进行回滚](https://blog.csdn.net/abc19900828/article/details/39497631)
当SpringMVC与Spring结合时，会有多个spring配置XML文件，这个时候需要对配置文件的内部信息进行调整，才能使得事务启用，且SpringMVC事务主要针对于默认对非检查型异常和运行时异常进行事务处理。    
对非检查型类异常可以不用捕获，而检查型异常则必须用try语句块进行处理或者把异常交给上级方法处理总之就是必须写代码处理它。所以必须在service捕获异常，然后再次抛出，这样事务方才起效。     

如何改变默认规则：    
1. 让检测异常也回滚：在整个方法前加上 @Transactional(rollbackFor=Exception.class)    
2. 让非检测异常不回滚： @Transactional(notRollbackFor=RunTimeException.class)    
3. 不需要事务管理的(只查询的)方法：@Transactional(propagation=Propagation.NOT_SUPPORTED)    
