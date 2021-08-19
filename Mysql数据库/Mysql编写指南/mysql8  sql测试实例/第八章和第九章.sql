-- 8.1 年月日加减法
select now() from dual union all
select now() + interval 5 year from dual union all
select now() + interval 5 day from dual union all
select now() + interval 5 hour from dual union all
select now() + interval 5 minute from dual union all
select now() + interval 5 second from dual union all
-- 8.2计算两个日期之间的天数
select datediff(ward_hd,allen_hd) from (select hiredate as ward_hd from emp where ename = 'WARD')x,(select hiredate as allen_hd from emp where ename = 'ALLEN')y
-- 9.1、判断当前年份是否是闰年
  -- 整除法
	select (case when mod(year(date('2021-1-1')),400) =0 or (mod(year(date('2021-1-1')),100)<>0 and mod(year(date('2021-1-1')),4)=0) then '闰年' else '非闰年' end) '是否闰年' from dual;
	-- 判断二月份的天数法
	select (case DATEDIFF(LAST_DAY(MAKEDATE(year(date('2020-10-2')),32)),MAKEDATE(year(date('2020-10-2')),31)) when 29 then '闰年' else '非闰年' end) '是否瑞年' from dual;
	
-- 9.2计算今年有多少天
select datediff(x.currentYearFirstDay + interval 1 year,x.currentYearFirstDay) from (select (now() - interval (dayofyear(now())+1) day) currentYearFirstDay from dual)x;
-- 9.3从给定日期中提取年月日时分秒
select date_format(now(),'%Y'),date_format(now(),'%m'),date_format(now(),'%d'),date_format(now(),'%k'),date_format(now(),'%i'),date_format(now(),'%s') from dual;
-- 9.4 计算一个月的第一天和最后一天
   -- 使用函数dayofmonth(date)、last_day(date)和subdate(date,n) 函数
	 select  subdate(now(),dayofmonth(now())-1) firstDay,last_day(now()) lastDay from dual;
	 
-- 9.5 列出一年中所有的星期五
-- 辅助表以及数据插入
create table t500 as select * from t1 where 1=2; 

create PROCEDURE insertT500()
begin
declare num int;
set num=1;
while num<501 do
insert into t500(id) values(num);
set num=num+1;
end while;
end;

call insertT500;
select * from t500;
-- 使用id递增辅助数据通过笛卡尔积生成每一天，筛选出所有的星期五。使用函数makedate(year_data,day)和weekday(date)
select makedate(year(now()),t.id) from t500 t where year(makedate(year(now()),t.id))=year(now()) and weekday(makedate(year(now()),t.id)) = 4;


-- 9.6找出当前月份第一个和最后一个星期一
select SUBDATE(LAST_DAY(now()),t.id) from t500 t where WEEKDAY(SUBDATE(LAST_DAY(now()),t.id)) = 0 limit 1;
select adddate(subdate(now(),dayofmonth(now())-1),t.id) from t500 t where weekday(adddate(subdate(now(),dayofmonth(now())-1),t.id)) = 0 limit 1;
-- 9.7为当前月份生成日历
select week(date('2021-04-04')),WEEKOFYEAR(date('2021-04-04')) from dual;

select 
max(case when weekday(W.dayTime) = 0 then day(W.dayTime) else '' end) MO,
max(case when weekday(W.dayTime) = 1 then day(W.dayTime) else '' end) TU,
max(case when weekday(W.dayTime) = 2 then day(W.dayTime) else '' end) WE,
max(case when weekday(W.dayTime) = 3 then day(W.dayTime) else '' end) TH,
max(case when weekday(W.dayTime) = 4 then day(W.dayTime) else '' end) FR,
max(case when weekday(W.dayTime) = 5 then day(W.dayTime) else '' end) SA,
max(case when weekday(W.dayTime) = 6 then day(W.dayTime) else '' end) SU
from
(select  adddate(fristDay,t.id) dayTime, WEEKOFYEAR(adddate(fristDay,t.id)) weekNum from
(select subdate(now(),dayofmonth(now())) fristDay, dayofmonth(now()) + datediff(last_day(now()),now()) dayNum from dual)y,t500 t where t.id <= y.dayNum)W group by W.weekNum;
 
-- 9.8列出一年中每个季度的开始日期和结束日期
select MAKEDATE('2021',1) one_st,subdate(adddate(MAKEDATE('2021',1),interval 3 month),1) one_end,adddate(MAKEDATE('2021',1),interval 3 month) tow_st,subdate(adddate(MAKEDATE('2021',1),interval 6 month),1) tow_end,adddate(MAKEDATE('2021',1),interval 6 month) three_st,subdate(adddate(MAKEDATE('2021',1),interval 9 month),1) three_end,adddate(MAKEDATE('2021',1),interval 9 month) four_st,subdate(adddate(MAKEDATE('2021',1),interval 12 month),1) four_end  from dual;
-- 9.9计算一个季度的开始日期和结束日期
   -- 问题：以yyyyq格式给出了年份和季度序号，找出该季度的开始时间和结束时间
select adddate(makedate(Y.yearStr,1),interval (num-1)*3 month) firstDay, subdate(adddate(makedate(Y.yearStr,1),interval num*3 month),1) endDay from	
	(select SUBSTR('20212',1,4) yearStr,SUBSTR('20212',5,1) num from dual)Y;
-- 9.10、填充缺失的日期  先借助辅助生成每个月的数据，再左连接emp表关联数据并按月分组统计
select Y.dateTime,count(e.HIREDATE) from
(select adddate(date('1980-12-1'),interval t.id month) dateTime from t500 t where t.id <= 24)Y
left join emp e on year(Y.dateTime)=year(e.HIREDATE) and month(Y.dateTime)=month(e.HIREDATE) group by Y.dateTime order by Y.dateTime;

-- 9.13 识别重叠的日期区间
select t1.empno,t1.ename,concat('project ',t2.proj_id,' overlaps project ',t1.proj_id)
from emp_project t1,emp_project t2 where t1.empno = t2.empno and t2.proj_start <= t1.proj_end and t2.proj_start >= t1.proj_start and t1.proj_id <> t2.proj_id order by t1.EMPNO,t1.proj_id;





