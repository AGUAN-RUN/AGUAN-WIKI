-- 6.12 按字母表顺序排列字符 思路
select e.ename eanme,group_concat(substr(e.ENAME,t.ID,1) order by substr(e.ENAME,t.ID,1) separator '') chars from emp e,t10 t where t.ID <= length(e.ENAME) group by e.ename;

select X.ename,group_concat(X.chars order by X.chars separator '')  from
(select e.ename ename,substr(e.ENAME,t.ID,1) chars from emp e,t10 t where t.ID <= length(e.ENAME))X group by X.ename;
-- 6.13  --分离出数字
create or replace view V as 
select concat(substr(ename,1,2),replace(cast(deptno as char(4)),' ',''),substr(ename,3,2)) as mixed from emp where deptno=10 
union all
select replace(cast(empno as char(4)),' ','') from emp where deptno=20 
union all
select ename from emp where deptno = 30;

select * from V;
     -- 抽取开始
select Y.mixed,group_concat(Y.cr separator '')	number from	(select V.mixed,substr(V.mixed,t10.ID,1) cr from V,t10 where t10.ID <= length(V.mixed))Y where ascii(Y.cr) between 48 and 57 group by Y.mixed;


-- 6.12 提取第n个分隔字符串 此处n=2
create or replace view V as 
select 'first' as name from t1
union all
select 'mo,larry,curly'  from t1union all select 'tina,gina,jaunita,regina,leena' as name from t1;
select * from V;
-- 我的写法
select substring_index(substring_index(name,',',2),',',-1) from V where locate(',',name) >0;



