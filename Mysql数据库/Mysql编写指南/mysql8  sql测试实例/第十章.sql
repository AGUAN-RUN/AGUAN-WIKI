create table emp_project(
empno int,
ename char(10),
proj_id int,
proj_start TIMESTAMP,
proj_end TIMESTAMP
)engine = INNODB DEFAULT charset='utf8';
show columns from emp_project;
select * from emp_project;
insert into emp_project values 
(7782,'CLARK',1,'2005-6-16','2005-6-18'),
(7782,'CLARK',4,'2005-6-19','2005-6-24'),
(7782,'CLARK',7,'2005-6-22','2005-6-25'),
(7782,'CLARK',10,'2005-6-25','2005-6-28'),
(7782,'CLARK',13,'2005-6-28','2005-7-18'),
(7839,'KING',2,'2005-6-17','2005-6-21'),
(7839,'KING',8,'2005-6-23','2005-6-25'),
(7839,'KING',11,'2005-6-29','2005-6-30'),
(7839,'KING',14,'2005-6-26','2005-6-27'),
(7839,'KING',5,'2005-6-20','2005-6-24'),
(7934,'MILLER',3,'2005-6-18','2005-6-22'),
(7934,'MILLER',12,'2005-6-27','2005-6-28'),
(7934,'MILLER',15,'2005-6-30','2005-7-3'),
(7934,'MILLER',9,'2005-6-24','2005-6-27'),
(7934,'MILLER',6,'2005-6-21','2005-6-23');
commit;

-- 10.2计算同一组或分区的行之间的差
select deptno,ename,sal,hiredate,sal-nextSal salDiff from
(select e1.DEPTNO,e1.ENAME,e1.sal,e1.hiredate,(select e2.sal from emp e2 where e2.HIREDATE>e1.HIREDATE and e1.deptno =e2.DEPTNO order by HIREDATE limit 1) nextSal from emp e1)Y 
order by DEPTNO,hiredate

-- 10.4为值区间填充缺失值
select Y.YR ,count(e.hiredate) from
(select cast(1979+t.id as char(4)) YR from t10 t)Y left join emp e on year(e.HIREDATE)=Y.YR group by Y.YR order by Y.YR;
-- 10.5生成行号
select *,(@rownum:=@rownum+1) rn from emp,(select @rownum:=0)r;

-- 11.1结果集分页
select sal from emp order by sal limit 1,10;
-- 11.5 提取最靠前的n行记录
select ename,sal from
(select e1.ename,e1.sal,(select count(distinct e2.sal) from emp e2 where e2.sal >= e1.sal) st  from emp e1 order by e1.sal desc)Y where st <= 5;
-- 11.6找出最大和最小的记录
select ename,sal from emp where sal in ((select max(sal) from emp),(select min(sal) from emp));
-- 11.7 查询未来的行  如果有员工工资低于紧随其后入职的同事，找出这些员工
select ename,sal,hiredate from
(select e1.ename,e1.sal,e1.hiredate,(select e2.sal from emp e2 where e2.HIREDATE >= e1.hiredate and e1.EMPNO <> e2.EMPNO limit 1) nextHireSal from emp e1)V where sal<nextHireSal  order by HIREDATE;

-- 11.8行值轮转  返回每个员工的姓名、工资，以及下一个和前一个的工资。没有下一个的下一个为第一个，没有上一个的上一个为最后一个
select e1.ename,e1.sal,
coalesce((select min(e2.sal) from emp e2 where e2.sal > e1.sal or(e2.sal=e1.sal and e1.EMPNO<e2.EMPNO)),(select min(sal) from emp)) forward,
coalesce((select max(e2.sal) from emp e2 where e2.sal < e1.sal or(e2.sal=e1.sal and e1.EMPNO>e2.EMPNO)),(select max(sal) from emp)) rewind 
from emp e1 order by sal,empno;
-- 对结果排序
-- emp 表里的工资值排序
select e1.sal,(select count(distinct e2.sal) from emp e2 where e2.sal<=e1.sal) from emp e1  order by sal;
-- 11.10删除重复项
select distinct job from emp;
select job from emp group by job;
-- 11.11查找骑士值
select e1.deptno,e1.ename,e1.sal,e1.hiredate,(select max(e2.sal) from emp e2 where e2.DEPTNO = e1.DEPTNO and e2.HIREDATE = (select max(e3.HIREDATE) from emp e3 where e3.deptno = e1.deptno)) from emp e1 order by e1.DEPTNO;
-- 11.12
create or replace view V(id,order_date,process_date) as 
select 1  ,date('2005-8-25') ,date('2005-8-27')
union all
select 2  ,date('2005-8-26') ,date('2005-8-28')
union all
select 3  ,date('2005-8-27') ,date('2005-8-29')
select * from V;
select V.id,V.order_date,V.process_date,
(case t10.id when 1 then '' else adddate(V.process_date,1) end) virified,
(case t10.id when 3 then adddate(V.process_date,2) else '' end) shipped
from V,t10 where t10.id<4 order by V.id,t10.id;








