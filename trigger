--每当成功插入一个数据是，自动打印一句话
create trigger saynewemp
after insert
on emp
---for each row [when(条件)]
declare
begin
  dbms_output.put_line('成功插入新员工');
end;
/
--语句级触发器：针对的是表
--行级触发器：针对的是行，触发作用的每一条记录都被触发，在行级触发器中使用 :old 和:new 伪记录变量，识别值的状态


--1.实施复杂的安全性检查
--select to_char(sysdate,'day') in ('星期六','星期日') from dual
--select to_number(to_char(sysdate,'hh24')) not between 9 and 18 from dual



create or replace trigger securityemp
before insert
on emp
begin
  if  to_char(sysdate,'day') in ('星期六','星期日') or 
    to_number(to_char(sysdate,'hh24')) not between 9 and 18 then
    raise_application_error(-20001,'禁止在非工作时间插入新员工');        --错误代码范围-20000到-29999
  end if;
end;

--2.数据的确认
--涨工资不能越涨越少
--:old 和:new 代表同一条记录
--:old 表示操作该行之前，这一行的值
--:new 表示操作该行之后，这一行的值
create or replace trigger checksalary
before update
on emp
for each row 
begin
  if  :new.sal < :old.sal then
  raise_application_error(-20002,'涨工资不能越涨越少'||'涨后的薪水'||:new.sal||'涨前的薪水'||:old.sal);
  end if;
end;

--3.数据库的审计（跟踪表上的数据操作）（基于值的审计）
--4.数据的备份和同步




