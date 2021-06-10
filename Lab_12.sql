-- 1 задание
use SHU_UNIVER
set nocount on
if  exists (select * from  SYS.OBJECTS        -- таблица X есть?
	            where OBJECT_ID= object_id(N'DBO.X') )	            
	drop table X;           
declare @c int, @flag char = 'f';           -- commit или rollback?
set IMPLICIT_TRANSACTIONS  on	-- включ. режим неявной транзакции
create table X(K int );                         -- начало транзакции 
insert X values (1),(2),(3);
set @c = (select count(*) from X);
print 'количество строк в таблице X: ' + cast( @c as varchar(2));
if @flag = 'c'  commit;                   -- завершение транзакции: фиксация 
else   rollback;                                 -- завершение транзакции: откат  
set IMPLICIT_TRANSACTIONS  off   -- выключ. режим неявной транзакции
	
if  exists (select * from  SYS.OBJECTS       -- таблица X есть?
	 where OBJECT_ID= object_id(N'DBO.X') )
	print 'таблица X есть';  
else
	print 'таблицы X нет'
      

-- 2 задание

begin try
	begin tran
		insert FACULTY values('ФДВ', 'факультете диванных войск')
		insert FACULTY values('ПФ','просто факультет')
		select * from FACULTY
		delete from GROUPS where IDGROUP = 1
	commit tran
end try
begin catch
	print '############################	ERROR ############################'
	print error_number()
	print error_message()
	print @@trancount	
	print '############################	ERROR ############################'
	rollback tran
end catch

insert FACULTY values('ПФ','просто факультет')
-- 3 задание

select * from FACULTY
insert FACULTY values('ППФ','просто просто факультет')

delete from FACULTY where FACULTY = 'ПФA       '

declare @checkpoint varchar(3) = 'p0'
begin try
	begin tran
		select * from FACULTY
		save tran @checkpoint
		delete from FACULTY where FACULTY='ППФ'
		set @checkpoint = 'p1';
		save tran @checkpoint
		insert FACULTY values('ПФ','просто но не просто')
		set @checkpoint = 'p2';
		save tran @checkpoint;
	commit tran
end try
begin catch
	print error_number()
	print error_message()
	print @@trancount	
	print concat('Ошибка произошла на контрольной точке:', @checkpoint)
	if (@checkpoint = 'p0')
		print 'Невозможно произвести удаление'
	else
		print 'Невозможно произвести вставку значения'
	rollback tran @checkpoint
	commit tran
end catch

-- 4 задание
--------A----
set transaction isolation level READ UNCOMMITTED
begin transaction
-------------------------- t1 ------------------
	select @@SPID, count(*) from FACULTY
	select * from FACULTY
-------------------------- t2 -----------------
rollback tran


-- 5 задание

select * from FACULTY

set transaction isolation level READ COMMITTED
begin transaction
	select count(*) from FACULTY where FACULTY like 'П%';
	-------------------------- t1 ------------------
-------------------------- t2 -----------------
	select count(*) from FACULTY where FACULTY like 'П%';
	
rollback tran;


-- 6 задание
-- A ---
set transaction isolation level REPEATABLE READ
begin transaction
select * from [SUBJECT] where PULPIT = 'ИСиТ';
-------------------------- t1 ------------------
-------------------------- t2 -----------------
select * from [SUBJECT] where PULPIT = 'ИСиТ';
commit;

delete from [SUBJECT] where SUBJ = 'NewSubj'

-- 7 задание
-- A ---
set transaction isolation level SERIALIZABLE
begin transaction
insert [SUBJECT] values ('NewSubj2', 'NS2', 'ИСиТ');
update [SUBJECT] set SUBJECT_NAME = 1 where SUBJ = 'NewSubjs2'
select * from [SUBJECT] as s  where s.PULPIT= 'ИСиТ';
-------------------------- t1 -----------------
select * from [SUBJECT] as s  where s.PULPIT= 'ИСиТ';
-------------------------- t2 ------------------
commit;
rollback

dbcc useroptions	


-- 8 задание
create table #TEMPDB8(A int);
insert #TEMPDB8 values(3223);

begin tran
	insert #TEMPDB8 values(999)
		begin tran
			update #TEMPDB8 set A = 1
		commit tran
	if @@TRANCOUNT > 0 
		rollback

select * from #TEMPDB8
drop table #TEMPDB8


-- 9 задание

use SHU_MYBASE2

declare @mycheckpoint nvarchar(2)
begin try
	begin tran
	set @mycheckpoint = 'p0' 
	save tran @mycheckpoint
	insert POSITION values('Заменитель табуретки', 'пропустим', 'ровная спина')
	set @mycheckpoint = 'p1'
	save tran @mycheckpoint
	insert POSITION values('ВИКИ', 'станешь умным', 'должен быть умным')
	set @mycheckpoint = 'p3'
	save tran @mycheckpoint
	delete from POSITION where POSITION_NAME = 'ВИКИ'
	commit tran
end try
begin catch
	PRINT ERROR_MESSAGE()
    rollback tran @mycheckpoint
end catch

select * from POSITION