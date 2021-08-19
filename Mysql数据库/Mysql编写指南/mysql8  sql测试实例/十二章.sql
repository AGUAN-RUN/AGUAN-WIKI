-- 12.1 变换结果集为一行
select deptno,count(1) from emp group by deptno;

select sum(case deptno when 10 then 1 else 0 end) dept_10,
sum(case deptno when 20 then 1 else 0 end) dept_20,
sum(case deptno when 30 then 1 else 0 end) dept_30 from emp;

-- 12.2 变换结果集为多行
select 
max(case JOB when 'CLERK' then ename else null end) CLERK,
max(case JOB when 'ANALYST' then ename else null end) ANALYST,
max(case JOB when 'MANAGER' then ename else null end) MANAGER,
max(case JOB when 'PRESIDENT' then ename else null end) PRESIDENT,
max(case JOB when 'SALESMAN' then ename else null end) SALESMAN
from 
(select e1.job,e1.ename,(select count(1) from emp e2 where e2.JOB=e1.JOB and e2.EMPNO<=e1.EMPNO) gp from emp e1)V
group by gp order by gp;

-- 12.3 反向变换结果集
select v2.deptno,
case v2.deptno when 10 then v1.dept_10               when 20 then v1.dept_20
               when 30 then v1.dept_30 end counts_by_dept from 
(select sum(case deptno when 10 then 1 else 0 end) dept_10,
sum(case deptno when 20 then 1 else 0 end) dept_20,
sum(case deptno when 30 then 1 else 0 end) dept_30 from emp)v1,(select deptno from dept where deptno <= 30)v2;

-- 12.4 反向变换结果集为一列
select  case id when 1 then ename when 2 then job when 3 then sal else '' end emps from
(select t.id, ename,job,sal from emp,(select id from t10 where id<5)t where deptno = 10 order by empno,t.id)v

-- 12.5 删除重复数据
select case when num=1 then deptno else '' end deptno,ename from
(select e.deptno,e.ename,(select count(1) from emp e1 where e1.DEPTNO=e.deptno and e1.EMPNO<=e.EMPNO) num from emp e order by e.deptno,num)v;

-- 12.6 变换结果集以实现跨行计算
select total_sal_20-total_sal_10 d20_10_diff,total_sal_30-total_sal_20 d30_20diff from
(select sum(case e.deptno when 10 then e.sal else 0 end) total_sal_10,
sum(case e.deptno when 20 then e.sal else 0 end) total_sal_20,
sum(case e.deptno when 30 then e.sal else 0 end) total_sal_30
from emp e)v;
-- 12.7 创建固定大小的数据桶
select ceil(num/5.0) id,empno,ename from
(select e.empno,e.ename,(select count(1) from emp e2 where e2.empno <= e.empno) num from emp e)v order by id;

-- 12.8创建预定数目的桶
select mod(num,4)+1 id,empno,ename from
(select e.empno,e.ename,(select count(1) from emp e2 where e2.empno <= e.empno) num from emp e)v order by id;
# 12.9创建水平直方图
select deptno,LPAD('',count(*),'*') from emp e group by deptno order by deptno;
  select count(1)  from aa01  t ;

-- 12.10 创建垂直直方图
select
Max(case deptno when 10 then '*' else null end) dept_10,
Max(case deptno when 20 then '*' else null end) dept_20,
Max(case deptno when 30 then '*' else null end) dept_30 from
(select e1.deptno,e1.empno,(select count(1) from emp e2 where e2.DEPTNO = e1.DEPTNO and e2.empno <= e1.empno) rn from emp e1)v group by rn  order by dept_10 desc,dept_20 desc,dept_30 desc

-- 12.12计算简单的小计
select coalesce(job,'total'),sum(sal) sal from emp group by job with rollup;
-- 12.13 计算所有可能表达式组合的小计
(select deptno,job,'total by dept and job' category,sum(sal) from emp group by deptno,job order by deptno)
union all
(select null ,job,'total by job' category,sum(sal) sal from emp group by job)
union all
(select deptno,null,'total by deptno' category,sum(sal) sal from emp group by deptno order by deptno);
-- 12.18 多维度聚合运算
select e1.empno,e1.deptno,(select count(*) from emp e2 where e2.deptno = e1.deptno) same_dept_sum,e1.job,(select count(1)  from emp e3 where e3.job=e1.job) same_job_sum,(select count(1) from emp) total from emp e1 
order by e1.deptno,e1.job;
-- 12.19动态区间聚合运算
select e1.hiredate,e1.sal,(select sum(e2.sal) from emp e2 where e2.HIREDATE between subdate(e1.hiredate,90) and e1.hiredate) spending_pattern from emp e1 order by e1.hiredate;
-- 12.20 变换带有小计的结果集
(select mgr,
sum(case deptno when 10 then total else 0 end) dept10,
sum(case deptno when 20 then total else 0 end) dept20,
sum(case deptno when 30 then total else 0 end) dept30,
null total
from
(select e1.mgr,e1.deptno,sum(sal) total from emp e1 group by mgr,deptno having mgr is not null and deptno is not null)v group by mgr order by mgr)
union all
select null mgr,(select sum(sal) from emp where deptno=10 and mgr is not null),(select sum(sal) from emp where deptno=20 and mgr is not null),(select sum(sal) from emp where deptno=30 and mgr is not null),(select sum(sal) from emp where mgr is not null);






