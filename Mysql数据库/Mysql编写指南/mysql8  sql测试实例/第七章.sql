-- 7.1计算平均值
select avg(sal) avg_sal from emp;
-- 7.2最小最大值
select min(sal) min,max(sal) max from emp;
-- 7.3 求和
select sum(sal) total_sal from emp;
select sum(sal) dept_total_sal from emp group by DEPTNO;
-- 7.4 计算行数
select count(1) from emp;
-- 7.5 计算非null值
select count(comm) from emp;
-- 7.6 累计求和
select e.ename,e.sal,(select sum(t.sal) from emp t where t.EMPNO <= e.EMPNO) from emp e order by e.EMPNO;
-- 7.7 计算累计乘积
select e.ename,e.sal,(select exp(sum(ln(t.sal))) from emp t where t.EMPNO <= e.EMPNO and t.DEPTNO = e.DEPTNO) from emp e where e.DEPTNO = 10 order by e.EMPNO;
-- 7.8 计算累计差值
select e.EMPNO,e.ename,e.sal,(select case when e.empno= min(t.empno) then sum(t.sal) else sum(-t.sal) end from emp t where 
t.EMPNO <= e.EMPNO and e.DEPTNO = t.DEPTNO) diff_sum from emp e where e.DEPTNO = 10 order by e.EMPNO;
-- 7.9 计算众数
select e1.sal from emp e1 group by e1.sal having count(1) >= (select max(v.rn) from (select count(1) rn from emp e2  group by e2.sal)v);
-- 7.10 计算中位数
select v.sal,v.rn from (select e.sal,@rownum:=@rownum+1 rn from emp e,(select @rownum:= 0)r order by e.sal)v 
where v.rn = (floor((select count(1) from emp t)/2));
-- 计算百分比
select concat(cast(sum(case when deptno=10 then sal else 0 end) as decimal)/sum(sal)*100,'%') from emp;
-- 7.12  avg不忽略null项
select avg(comm)  avg_comm from emp  where deptno = 30;
select avg(ifnull(comm,0))  avg_comm from emp  where deptno = 30;
select avg(coalesce(comm,0))  avg_comm from emp  where deptno = 30;
-- 7.13 计算平均值忽略最小最大值
select avg(e.sal) from emp e where e.sal not in(select max(sal) from emp union select min(sal) from emp);

-- 7.15 修改累计值
create or replace view V(id,amt,trx) as
select 1,100,'pr' from t1 union all
select 2,100,'pr' from t1 union all
select 3,50,'py' from t1 union all
select 4,100,'pr' from t1 union all
select 5,200,'py' from t1 union all
select 6,50,'py' from t1 
select * from V;
select (case v1.trx when 'pr' then 'purchase' when 'py' then 'payment' end)  trx_type,v1.amt amt,
(select sum(case v2.trx when 'pr' then amt when 'py' then -amt end) from V v2 where v2.id <= v1.id)   
from V v1 order by id;
