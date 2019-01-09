[quartz定时任务cron表达式详解](https://www.cnblogs.com/lazyInsects/p/8075487.html)    
[cron表达式详解](https://www.cnblogs.com/javahr/p/8318728.html)

cron表达式是一个字符串，字符串中各个域通过空格进行分隔，主要有六个域与七个域两种格式：
1. 七位：Seconds Minutes Hours DayofMonth Month DayofWeek Year
2. 六位：Seconds Minutes Hours DayofMonth Month DayofWeek

一、结构

|字段|允许值|允许的特殊字符|
|:--:|:--:|:--:|
|秒(Seconds)|0~59的整数|,-*/ 四个字符|
|分(Minutes)|0~59的整数|,-*/ 四个字符|
|小时(Hours)|0~23的整数|,-*/ 四个字符|
|日期(DayofMonth)|1~31的整数（但是你需要考虑月的天数）|,-*?/L W C八个字符|
|月份(Month)|1~12的整数或者JAN-DEC|,-*/ 四个字符|
|星期(DayofWeek)|1~7的整数或者SUN-SAT(1=SUN)|,-*?/ L C # 八个字符|
|年(可选，留空)(Year)|1970~2099|,-*/ 四个字符|

1. *:表示匹配该域的任意值。假如在Minutes域使用*，即表示每分钟都会触发事件。
2. ?:只能用在DayofMonth和DayofWeek两个域。它也匹配域的任意值，但实际不会。因为DayofMonth和DayofWeek会相互影响。例如想在每月20日触发调度，不管20日到底是星期几，则只能使用如下写法：13 13 15 20 * ?，其中最后一位只能使用?（暂未找到使用*会怎么样，好像两个Dayof的同时任意只能使用一个*和?）
3. -:表示范围。区间
4. /:表示起始时间开始触发，然后每隔固定时间触发一次。例如在Minutes域中使用5/20表示从20分钟起每5分钟触发一次。
5. ,:表示列出枚举值。
6. L:表示最后，只能出现在DayofWeek和DayofMonth域。如果在DayofWeek域使用5L，意味着在最后的一个星期四触发。
7. W:表示有效工作日（周一到周五），只能出现在DayofMonth域，系统将在离指定日期最近的有效工作日触发事件。例如：在DayofMonth使用5W，如果5日是星期六，则将在最近的工作日：星期五，即4日触发。
8. LW:两个字符连用，表示在某个月最后一个工作日，即最后一个星期五。
9. #:用于确定每个月第几个星期几，只能出现在DayofMonth域。例如在4#2，表示某月的第二个星期三。
