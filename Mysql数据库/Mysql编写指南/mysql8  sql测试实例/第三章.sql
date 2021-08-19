-- 问题3.4
select deptno from dept where deptno not in (select deptno from emp);
select deptno from dept where deptno not in (null);
      -- 使用 not exists()实现
select deptno from dept dp where not exists(select 1 from emp ep where ep.deptno = dp.deptno);	

-- 问题3.5  哪些部门没有人？
select dp.* from dept dp left join emp ep on ep.deptno=dp.deptno  where ep.DEPTNO is null;

-- 问题3.6 左外连接
select * from emp_bonus;
select * from emp;
select * from dept;
drop table emp_bonus;
create table emp_bonus(empno int(10),received TIMESTAMP,type int(2))engine=INNODB DEFAULT charset=utf8;
insert into emp_bonus values(7369,'2005-5-14',1),(7900,'2005-5-14',2),(7788,'2005-5-14',3);

select e.ename,d.loc,eb.received from emp e inner join dept d on e.deptno=d.deptno left join emp_bonus eb on eb.empno=e.EMPNO;
-- 问题3.9
delete from emp_bonus;
select * from emp_bonus;
insert into emp_bonus values(7934,'2005-5-17',1),(7934,'2005-5-17',2),(7839,'2005-5-17',3),(7782,'2005-5-17',1);
   -- 我的思路
select sum(v.sal) totalamt,sum(v.bonus) totalBouns  from (select e.sal sal,sum(case eb.type when 1 then e.sal*0.1 when 2 then e.sal*0.2 else e.sal*0.3 end) bonus from emp e ,emp_bonus eb where e.empno = eb.empno group by e.empno)v

show index from emp;

			