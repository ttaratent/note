[db2 EXPLAIN分析SQL](https://blog.csdn.net/lyjiau/article/details/50351358)     

[如何写出更快的 SQL (db2)](https://www.jianshu.com/p/5aa16abd35c5)

[db2调优实践](http://blog.sina.com.cn/s/blog_6a2c7c97010181qs.html)

## db2exfmt    
db2exfmt 命令能够将 Explain 表中存储的存取计划信息以文本的形式进行格式化输出。db2exfmt 命令将各项信息更为直观的显示，使用起来更加方便。命令如清单 1 所示：
```
db2exfmt -d <db_name> -e <schema> -g T -o <output> -u <user> <password> -w <timestamp>
Example: db2exfmt -d test_db -e user -g T -o D:\temp\sql_1_result_db2exfmt.txt
 -u user password -w l
Query:
                sql_1.txt（附件中）
                Results:
                sql_1_result_db2exfmt.txt（附件中）
```
## db2expln    
db2expln 是命令行下的解释工具，和前面介绍的 Visual Explain 功能相似。通过该命令可以获得文本形式的查询计划。db2expln将存取计划以文本形式输出，它只提供存取计划中主要的信息，并不包含每一个操作占用多少 CPU、I/O、占用 Buffer 的大小以及使用的数据库对象等信息，方便阅读。但是 db2expln 也会将各项有关存取计划的信息存入 Explain 表中，用户可以使用 db2exfmt 察看详细的格式化文本信息。
命令如清单 2 所示:
```
   db2expln -d <db_name> -user <user> <password> -stmtfile <sql.file>
   -z @ -output <output> -g
Example: db2expln -d test_db -user user password -stmtfile D:\temp\sql_1.txt
 -z @ -output D:\temp\sql_1_result_db2expln.txt –g
Query:
                 sql_1.txt（附件中）
                Results:
                 sql_1_result_db2expln.txt（附件中）
```
## db2advis    
db2advis是DB2提供的另外一种非常有用的命令。通过该命令DB2可以根据优化器的配置以及机器性能给出提高查询性能的建议。这种建议主要集中于如何创建索引，这些索引可以降低多少查询代价，需要创建哪些表或者 Materialized Query Table(MQT) 等。命令如清单 3 所示：
```
db2advis -d <db_name> -a <user>/<password> -i <sql.file> -o <output>
Example: db2advis -d test_db -a user/password
 -i D:\temp\sql_2.txt > D:\temp\sql_2_result_db2advis.txt
Query:
                 sql_2.txt（附件中）
                Results:
                sql_2_result_db2advis.txt（附件中）  
```
通过 -i 指定的 SQL 文件可以包含多个查询，但是查询必须以分号分隔。这与db2expln命令不同，db2expln可以通过-z参数指定多个查询之间的分隔符。用户可以把某一个 workload 中所使用的所有查询写入 SQL 文件中，并在每个查询之前使用”--#SET FREQUENCY <num>”为其指定在这个workload中的执行频率。db2advis会根据每个查询在这个 workload 的频率指数进行权衡来给出索引的创建建议，从而达到整个workload的性能最优。
## db2batch
前面介绍的工具和命令只提供了查询的估算代价，但有些时候估算代价和实际的执行时间并不是完全呈线形关系，有必要实际执行这些查询。db2batch就是这样一个 Benchmark工具，它能够提供从准备到查询完成中各个阶段所花费地具体时间，CPU时间，以及返回的记录。命令如清单4 所示：
```
 db2batch -d <db_name> -a <user>/<password>
 -i <time_condition> -f <sql.file> -r <output>
Example: db2batch -d test_db -a user/password
 -i complete -f D:\temp\sql_3.txt -r d:\temp\sql_3_result_db2batch.txt
Query:
                 sql_3.txt（附件中）
                Results:
                 sql_3_result_db2batch.txt（附件中）
```
对于执行db2batch时一些详细的设置可以通过-o参数指定，也可以在SQL文件中指定，譬如本例中在SQL文件中使用了下面的配置参数 :

--#SET ROWS_FETCH -1 ROWS_OUT 5 PERF_DETAIL 1 DELIMITER @ TIMESTAMP

其中ROWS_FETCH和ROWS_OUT定义了从查询的结果集中读取记录数和打印到输出文件中的记录数，PERF_DETAIL设置了收集性能信息的级别，DELIMITER则指定了多个查询间的间隔符。
