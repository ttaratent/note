[SQL - Order By如何处理NULL](https://www.cnblogs.com/tjxing/archive/2019/03/19/10558065.html)

## NULL最大派
这一派包括PostgreSQL、Oracle、DB2等。它们的原则是，排序时NULL比其他的值都要大。一般支持NULLS FIRST和NULLS LAST语句

## NULL最小派
最小派认为排序时NULL小于所有的值。属于这一派的有MySQL、SQL Server等。还有Apache Hive也是这一派，不支持NULLS FIRST/NULLS LAST。

最小派里还有一个另类人物，SparkSQL。它不是数据库，但是支持SQL。SparkSQL也将NULL视为最小，同时它也支持NULLS FIRST/LAST。
