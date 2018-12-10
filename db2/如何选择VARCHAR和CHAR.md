引用：[DB2数据库性能：如何选择CHAR或VARCHAR](https://blog.csdn.net/tttk/article/details/1635908)
间接引用：[SQL Server Performance Tuning for SQL Server Developers](http://www.databasejournal.com/features/mssql/article.php/1466951)

Choose the Appropriate Data Types
While you might think that this topic should be under database design, I have decided to discuss it here because Transact-SQL is used to create the physical tables that were designed during the earlier database design stage.
Choosing the appropriate data types can affect how quickly SQL Server can SELECT, INSERT, UPDATE, and DELETE data, and choosing the most optimum data type is not always obvious. Here are some suggestions you should implement when creating physical SQL Server tables to help ensure optimum performance.

Always choose the smallest data type you need to hold the data you need to store in a column. For example, if all you are going to be storing in a column are the numbers 1 through 10, then the TINYINT data type is more appropriate that the INT data type. The same goes for CHAR and VARCHAR data types. Don't specify more characters for character columns that you need. This allows SQL Server to store more rows in its data and index pages, reducing the amount of I/O needed to read them. Also, it reduces the amount of data moved from the server to the client, reducing network traffic and latency.

If the text data in a column varies greatly in length, use a VARCHAR data type instead of a CHAR data type. Although the VARCHAR data type has slightly more overhead than the CHAR data type, the amount of space saved by using VARCHAR over CHAR on variable length columns can reduce I/O, improving overall SQL Server performance.

Don't use the NVARCHAR or NCHAR data types unless you need to store 16-bit character (Unicode) data. They take up twice as much space as VARCHAR or CHAR data types, increasing server I/O overhead.

If you need to store large strings of data, and they are less than 8,000 characters, use a VARCHAR data type instead of a TEXT data type. TEXT data types have extra overhead that drag down performance.

If you have a column that is designed to hold only numbers, use a numeric data type, such as INTEGER, instead of a VARCHAR or CHAR data type. Numeric data types generally require less space to hold the same numeric value as does a character data type. This helps to reduce the size of the columns, and can boost performance when the columns is searched (WHERE clause) or joined to another column.

Forum: Char OR VARCHAR?
[http://archives.postgresql.org/pgsql-sql/2001-03/msg00520.php]
There is *no* performance advantage of CHAR(n) over VARCHAR(n).
If anything, there is a performance lossage due to extra disk I/O
(because all those padding blanks take space, and time to read).

My advice is to use CHAR(n) when that semantically describes your data (ie, truly fixed-width data, like US postal codes), or VARCHAR(n) when that semantically describes your data (ie, variable-width with a hard upper bound), or TEXT when that semantically describes your data (ie, variable width with no specific upper bound).  Worrying about performance differences is a waste of time, because there aren't any.


If the text data in a column varies greatly in length, use a VARCHAR
data type instead of a CHAR data type. Although the VARCHAR data type has slightly more overhead than the CHAR data type, the amount of space saved by using VARCHAR over CHAR on variable length columns can reduce I/O, improving overall SQL Server performance.

Several other people at the session who were familiar with the
performance effects of using char vs. varchar confirmed my advice. One person said his team was charged with deploying an application that used SQL Server. After deploying the application, the team found that it performed terribly. Upon inspecting the database, team members discovered that all the fields were varchar. They changed the fields to char, and the application now performs fine.

Here's the advice from IBM in from the DB2 Admin guide SC96-9003) Copyright IBM Corp. 1982, 1999 " Choosing CHAR or VARCHAR: VARCHAR
> saves DASD space, but costs a 2-byte overhead for each value and the additional processing required for varying-length records. Thus, CHAR is preferable to VARCHAR, unless the   space saved by the use of VARCHAR is significant. The savings are not significant if the maximum length is small or the lengths of the values do not have a significant variation. In general, do not define a column as   VARCHAR(n) unless n is at least 18.  (Consider, also, using data compression if your main  concern is DASD savings.  See "Compressing data  in a table space or partition" in topic 2.6.2 for more information.)      

If you use VARCHAR, do not specify a maximum length that is greater
than  necessary. Although VARCHAR saves space in a table space, it
does not save space in an index, because index records are padded with blanks to the    maximum length. Note particularly the restrictions on columns of strings  longer than 255 bytes; for example, they cannot be indexed. These restrictions are listed in Chapter 3 of DB2 SQL Reference.
