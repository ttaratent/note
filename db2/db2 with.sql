-- db2 
-- with语句的用法 公共表表达式
-- with主要用于创建一个临时集合进行相关查询，其中较为常用的功能包括，行转列，递归查询等
-- 一般用法
create table user(
name varchar(20) not null, -- 姓名
sex integer, -- 性别（1、男 2、女）
birthday date -- 生日
);
-- 插入数据
insert into user (name,sex,birthday) values ('zhangshan','1','1990-1-1');
insert into user (name,sex,birthday) values ('lisi','2','1991-1-1');
insert into user (name,sex,birthday) values ('wangwu','1','1992-1-1');
insert into user (name,sex,birthday) values ('sunliu','2','1949-10-1');
insert into user (name,sex,birthday) values ('tianqi','1','1994-1-1');
insert into user (name,sex,birthday) values ('zhaoba','2','1995-1-1');

with test(name_test, bday_test) as -- test是括号中查询出来的结果集命名，后接重命名列
(
select name, birthday from user -- 语句1
)
select name_test from test where bday_test= '1949-10-1' -- 语句2

-- 首先执行语句1，产生一个有两列(NAME, BIRTHDAY)的结果集；接着将这个结果集重命名为test
-- 并且将列名重命名为NAME_TEST，BDAY_TEST；
-- 最后执行语句2，从临时集合中找到指定数据。


-- 相对较为复杂的情况
create table user2
(
name varchar(20) not null, -- 姓名
degree integer not null, -- 学历（1、专科 2、本科 3、硕士 4、博士）
startworkdate date not null, -- 入职时间
salary1 float not null, -- 基本工资
salary2 float not null -- 奖金
);

-- 插数据
insert into user2 (name, degree, startworkdate, salary1, salary2) values ('zhangshan', '1','1995-1-1',10000.00,1600.00);
insert into user2 (name, degree, startworkdate, salary1, salary2) values ('lisi', '2','1996-1-1',5000.00,1500.00);
insert into user2 (name, degree, startworkdate, salary1, salary2) values ('wangwu', '3','1997-1-1',6000.00,1400.00);
insert into user2 (name, degree, startworkdate, salary1, salary2) values ('sunliu', '4','1998-10-1',7000.00,1300.00);
insert into user2 (name, degree, startworkdate, salary1, salary2) values ('tianqi', '2','1999-1-1',7000,1300);
insert into user2 (name, degree, startworkdate, salary1, salary2) values ('zhaoba', '1','2000-1-1',9000,1400);
insert into user2 (name, degree, startworkdate, salary1, salary2) values ('qianjiu', '3','1997-1-1',2000,1000);
insert into user2 (name, degree, startworkdate, salary1, salary2) values ('dushe', '4','1992-1-1',3000,1000);

-- 查询 1、学历是硕士或博士 2、学历相同，入职时间相同，但是工资（基本工资+奖金）却比相同条件员工的平均工资低的员工

-- 1、查询学历是硕士或博士的那些员工得到结果集1
select name, degree, year(startworkdate) as worddate, salary1+salary2 as  from user2 where degree in (3,4);

-- 2、根据学历和入职年份分组，求平均工资 得到结果集2
select degree, year(startworkdate) as worddate, avg(salary1+salary2) as avg_salary from user2 where degree in (3,4)
group by degree, year(startworkdate);

-- 3、以学历和入职年份为条件 联合两个结果集，查找工资<平均工资的员工，以下是完整的SQL语句
with temp1(name, degree, worddate, salary) as 
(
select name, degree, year(startworkdate) as workdate, salary1+salary2 as salary from user2 where degree i (3,4)
),
temp2(degree, worddate, avg_salary) as
(
select degree, year(startworkdate) as worddate, avg(salary1+salary2) as avg_salary
from user2 where degree in (3,4)
group by degree, year(startworkdate)
)
select name from temp1, temp2 where temp1.degree = temp2.degree
and temp1.worddate = temp2.worddate
and salary<avg_salary;

-- 优化 减少部分重复查询的内容
with temp1(name, degree, worddate, salary) as 
(
select name, degree, year(startworkdate) as worddate, salary1+salary2 as salary from user2 where degree in (3,4)
),
temp2(degree, worddate, avg_salary) as
(
select degree, worddate, avg(salary) as avg_salary
from temp1
group by degree, worddate
)
select name from temp1, temp2 where 
temp1.degree = temp2.degree
and temp1.worddate = temp2.worddate
and salary<avg_salary;


-- with 递归应用一
-- 比较典型的例子是对树状结构的表进行查询
create table bbs (
parentid integer not null,
id integer not null,
name varchar(200) not null --- 板块、文章、评论等
);

insert into bbs (parentid, id, name) values 
(0, 0, '论坛首页'),
(0, 1, '数据库开发'),
(1, 11, 'DB2'),
(11, 111, 'DB2 文章1'),
(111, 1111, 'DB2 文章1 的评论1'),
(111, 1112, 'DB2 文章1 的评论2'),
(11, 112, 'DB2 文章2'),
(1, 12, 'Oracle'),
(0, 2, 'Java技术');

-- 查询所有的DB2文章以及评论
with temp(parentid, id, name) as
(
select parentid, id, name from bbs where name='DB2' -- 语句1
union all -- 语句2
select b.parentid, b.id, b.name from bbs as b, temp as t where b.parentid = t.id -- 语句3
)
select name from temp; -- 语句4

-- with 子句内的第一个select语句是初始化表。它只执行一次，它的结果形成虚拟表的初始内容以作为递归的种子。
-- 第二个select语句执行多次，将种子作为输入传递给第二个select语句以产生下一个行集合。将结果添加到（union all）到虚拟表的当前内容
-- 中，并放回到其中以形成用于下一次传递的输入。只要有行产生，这个过程就会继续。

-- 执行原理
-- 1、首先，语句1将会执行，它只执行一次，作为循环的七点，得到结果集：DB2
-- 2、接着，将循环执行语句3。 首先语句3就是查找语句1产生结果集（DB2）的下一级，并且把查询的结果集作为下一次循环的起点，然后循环它们的下一级，直到没有下一级位置。
-- 3、第三，将执行语句2，将所有的结果集放在一起，最终得到temp结果集
-- 4、最后，通过语句4从temp临时集合中得到期望的查询结果。
-- 需要特别提醒的是：
-- 1、一定要注意语句3的关联条件，否则很容易造成死循环
-- 2、语句2必须是union all


-- with 递归应用二， 行转列
create table zxt_test
(
id varchar(10),
ivalue varchar(20),
iname varchar(20)
);

-- 2、插入测试数据
insert into zxt_test values('1','aa','x'),('2','bb','x'),('3','bb','x'),('1','bb','y'),('2','bb','y'),('3','bb','y');

with s as ( -- 这里是用iname来分区，id来排序。如果表没有这样序号分明的id字段，可以用rowNum()生成序号
select row_number() over (partition by iname order by id) id1,
	row_number() over(partition by iname order by id) id2,
	ivalue, iname from zxt_test
),
t(iname, id1, id2, ivalue) as 
(
select iname, id1, id2, cast(ivalue as varchar(100)) from s where id1 = 1 and id2 = 1; -- 语句1
union all
select t.iname, t.id1+1 , t.id2, cast(s.ivalue||','||t.ivalue as varchar(100)) -- 语句2必须是union
from s, t
where s.id2 = t.id1+1 and t.iname = s.iname
)
select iname, ivalue, from t where t.id1 = (select max(id1) from s where s.iname = t.iname);  --语句3


-- 行转列，其中效率较高
with s as(
select row_number() over() id1,
row_number() over() id2,
AAE004 from BB20 where AAE004 <> ''
),
t(id1, id2, AAE004) as
(
select id1, id2, AAE004 from s where id1 = 1 and id2 = 1
union all
select t.id1+1, t.id2, cast(s.AAE004||','||t.AAE004 as varchar(20000))
from s, t
where s.id2 = t.id1+1
)
select AAE004 from t where t.id1 = (select max(id1) from s);

-- 行转列，其中效率较低
with rs as (select AAE004, row_number() over() RN from BB20 where AAE004 <> '' 
),-- sql2
RPL(RN, AAE004) as
(
select ROOT.RN, cast(ROOT.AEE004 as varchar(20000)) from rs ROOT
union all 
select CHILD.RN, CHILD.AEE004||','||PARENT.AAE004 from
RPL parent, rs CHILD where 
PARENT.RN + 1=CHILD.RN
)
select rpl.RN, MAX(AAE004) AAE004 from RPL group by RN order by RN desc fetch for first 1 rows only;




