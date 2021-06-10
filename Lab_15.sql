use SHU_UNIVER
set nocount on

-- 1 задание
create table TR_AUDIT
(
	ID int identity,
	STMT varchar(20)  -- оператор
			check(STMT in ('INS', 'DEL', 'UPD')), 
	TRNAME varchar(50),
	CC varchar(300)
)

drop table TR_AUDIT

go
create trigger TR_TEACHER_INS
						on TEACHER after INSERT
as 
	print 'Событие: INSERT'
	declare @t char(10), 
			@tname varchar(100),
			@gender char(1),
			@p char(20),
			@values varchar(300);
	
	set @t = (select TEACHER from inserted);
	set @tname = (select TEACHER_NAME from inserted);
	set @gender = (select GENDER from inserted);
	set @p = (select PULPIT from inserted);

	set @values = CONCAT(@t,', ', @tname, ', ', @gender, ', ', @p)
	insert TR_AUDIT values('INS', 'TR_TEACHER_INS', @values)


insert TEACHER values('ДКТТМТ', 'Да кто ты такой мать твою', 'м', 'ИСиТ')
delete from TEACHER where TEACHER = 'ДКТТМТ'
select * from TR_AUDIT;
select * from TEACHER

drop trigger TR_TEACHER_INS

-- 2 задание
go
create trigger TR_TEACHER_DEL 
							on TEACHER after DELETE
as
	print 'Событие: DELETE'
	declare @t char(10), 
			@tname varchar(100),
			@gender char(1),
			@p char(20),
			@values varchar(300);

	set @t = (select TEACHER from deleted);
	set @tname = (select TEACHER_NAME from deleted);
	set @gender = (select GENDER from deleted);
	set @p = (select PULPIT from deleted);

	set @values = CONCAT(@t,', ', @tname, ', ', @gender, ', ', @p)
	insert TR_AUDIT values('DEL', 'TR_TEACHER_INS', @values)

delete from TEACHER where TEACHER = 'ДКТТМТ'
select * from TR_AUDIT;

drop trigger TR_TEACHER_DEL
-- 3 задание
go
create trigger TR_TEACHER_UPD 
							on TEACHER after UPDATE
as
	print 'Сработал триггер UPDATE'

	declare @t char(10), 
			@tname varchar(100),
			@gender char(1),
			@p char(20),
			@values varchar(300),

			@t2 char(10), 
			@tname2 varchar(100),
			@gender2 char(1),
			@p2 char(20),
			@values2 varchar(300);

	set @t = (select TEACHER from deleted);
	set @tname = (select TEACHER_NAME from deleted);
	set @gender = (select GENDER from deleted);
	set @p = (select PULPIT from deleted);

	set @t2 = (select TEACHER from inserted);
	set @tname2 = (select TEACHER_NAME from inserted);
	set @gender2 = (select GENDER from inserted);
	set @p2 = (select PULPIT from inserted);

	set @values = CONCAT(@t,', ', @tname, ', ', @gender, ', ', @p)
	set @values2 = CONCAT(@t2,', ', @tname2, ', ', @gender2, ', ', @p2)

	insert TR_AUDIT values('UPD', 'TR_TEACHER_UPD', CONCAT('Было: ', @values, 'Стало: ', @values2))

update TEACHER set TEACHER = 'ТСМ', TEACHER_NAME ='Ты меня снимаешь' where TEACHER = 'ДКТТМТ'
select * from TR_AUDIT;
delete from TEACHER where TEACHER = 'ТСМ'
drop trigger TR_TEACHER_UPD

-- 4 задание
go
create trigger TR_TEACHER 
						on TEACHER after INSERT, DELETE, UPDATE
as begin
	declare @ins int = (select count(*) from inserted),
			@del int = (select count(*) from deleted),
			@st varchar(20);

	declare @t char(10), 
			@tname varchar(100),
			@gender char(1),
			@p char(20),
			@values varchar(300);

	if @ins > 0 and @del = 0
	begin
		print 'Событие INSERT'
		set @t = (select TEACHER from inserted);
		set @tname = (select TEACHER_NAME from inserted);
		set @gender = (select GENDER from inserted);
		set @p = (select PULPIT from inserted);
		set @values = CONCAT(@t,', ', @tname, ', ', @gender, ', ', @p);
		insert TR_AUDIT values('INS', 'TR_TEACHER', @values);
	end
	else if @ins = 0 and @del > 0
	begin
		print 'Событие DELETE'
		set @t = (select TEACHER from deleted);
		set @tname = (select TEACHER_NAME from deleted);
		set @gender = (select GENDER from deleted);
		set @p = (select PULPIT from deleted);
		set @values = CONCAT(@t,', ', @tname, ', ', @gender, ', ', @p);
		insert TR_AUDIT values('DEL', 'TR_TEACHER', @values);

	end
	else if @ins > 0 and @del > 0
		begin
		print 'Событие UPDATE'
		set @t = (select TEACHER from inserted);
		set @tname = (select TEACHER_NAME from inserted);
		set @gender = (select GENDER from inserted);
		set @p = (select PULPIT from inserted);
		set @values = CONCAT(@t,', ', @tname, ', ', @gender, ', ', @p);

		set @t = (select TEACHER from deleted);
		set @tname = (select TEACHER_NAME from deleted);
		set @gender = (select GENDER from deleted);
		set @p = (select PULPIT from deleted);

		set @values = CONCAT('Было: ', @values, '. Стало: ', CONCAT(@t,', ', @tname, ', ', @gender, ', ', @p));
		insert TR_AUDIT values('UPD', 'TR_TEACHER', @values);
	end
end

delete from TR_AUDIT
drop trigger TR_TEACHER_INS
drop trigger TR_TEACHER_DEL
drop trigger TR_TEACHER_UPD

drop trigger TR_TEACHER

insert TEACHER values('ДКТТМТ', 'Да кто ты такой мать твою', 'м', 'ИСиТ')
update TEACHER set TEACHER = 'ТСfcМ', TEACHER_NAME ='Ты меня снимаешь' where TEACHER = 'ДКТТМТ'
delete from TEACHER where TEACHER = 'ДКТТМТ'

select * from TR_AUDIT
select * from TEACHER

-- 5 задание

alter table TEACHER add constraint Gender check(Gender in('м','ж', 'з'))
insert TEACHER values('КЖsТ', 'Кто же тsы', 'э', 'ИСиТ')
select * from TEACHER

alter table TEACHER drop constraint Gender

-- 6 задание
go
create trigger TR_TEACHER_DEL1
								on TEACHER after DELETE
as
	print 'Триггер DELETE1'
	
go
create trigger TR_TEACHER_DEL2
								on TEACHER after DELETE
as
	print 'Триггер DELETE2'

go
create trigger TR_TEACHER_DEL3
								on TEACHER after DELETE
as
	print 'Триггер DELETE3'
go

select t.name, e.type_desc 
   from sys.triggers  t join  sys.trigger_events e  
   on t.object_id = e.object_id  
   where OBJECT_NAME(t.parent_id) = 'TEACHER' and  e.type_desc = 'DELETE' ;  

exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL3', 
	                     @order = 'First',
						 @stmttype = 'DELETE';

exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL2', 
	                     @order = 'Last',
						 @stmttype = 'DELETE';

delete from TEACHER where TEACHER = 'SSSS'



-- 7 задание

go
create trigger TR_TEACHER_DELTRAN
								on TEACHER after DELETE
as
	declare @tname varchar(100)  = (select top(1) TEACHER from deleted)
	if @tname = 'ЖЛКК'
	begin
		raiserror('!!!Эм ты вообще с головой дружишь, ты занчешь что с тобой случится?!!!', 10, 1);
		rollback;
	end;
	return;

insert into TEACHER values ('ЖЛКК','Жиляк Надежда Александровна','ж','ИСиТ')
delete from TEACHER where TEACHER = 'ЖЛКК'
select * from teacher   

-- 8 задание
go
create trigger TR_FACULTY 
						on FACULTY instead of DELETE
as
	raiserror('Давай нападай дурачек', 10, 1)

delete from FACULTY where FACULTY = 'ИЭФ'
select * from FACULTY

drop trigger TR_UNIVER
drop trigger TR_FACULTY
drop trigger TR_TEACHER
drop trigger TR_TEACHER_INS
drop trigger TR_TEACHER_DEL
drop trigger TR_TEACHER_UPD

drop trigger TR_TEACHER_DELTRAN
drop trigger TR_TEACHER_DEL1
drop trigger TR_TEACHER_DEL2
drop trigger TR_TEACHER_DEL3

-- 9 заданиеw
go
create trigger TR_UNIVER on database
						 for DDL_DATABASE_LEVEL_EVENTS 
as begin
	declare @t varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(50)'),
			@t1 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(50)'),
			@t2 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]', 'varchar(50)'),
			@t3 nvarchar(64);

	print 'Тип события: ' + @t;
	print 'Имя объекта: ' + @t1;
	print 'Тип объекта: ' + @t2;

	if @t in('CREATE_TABLE', 'DROP_TABLE')
	begin
		if @t = 'CREATE_TABLE' 
			set @t3 = concat('Низя создать: ', @t1)
		else if @t = 'DROP_TABLE'
			set @t3 = concat('Низя удалить: ', @t1)
		
		raiserror(@t3, 10, 1);
		rollback;
	end
end

DROP TRIGGER TR_UNIVER ON DATABASE;

drop table TIMETABLE
create table tabletable(aboba int)
go

-- 10 задание
use SHU_MYBASE2
go

create trigger TR_MYBASE on database
						 for DDL_DATABASE_LEVEL_EVENTS 
as begin
	declare @t varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(50)'),
			@t1 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(50)'),
			@t2 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]', 'varchar(50)'),
			@t3 nvarchar(64);

	print 'Тип события: ' + @t;
	print 'Имя объекта: ' + @t1;
	print 'Тип объекта: ' + @t2;

	if @t in('CREATE_TABLE', 'DROP_TABLE')
	begin
		if @t = 'CREATE_TABLE' 
			set @t3 = concat('Низя создать: ', @t1)
		else if @t = 'DROP_TABLE'
			set @t3 = concat('Низя удалить: ', @t1)
		
		raiserror(@t3, 10, 1);
		rollback;
	end
end

drop table ENROLLMENT
create table prostoTable(a int)

drop trigger TR_MYBASE on database

create trigger TR_EMPLOYEES
						on EMPLOYEES after INSERT, UPDATE, DELETE
as begin
	declare @ins int = (select count(*) from inserted),
			@del int = (select count(*) from deleted);

	if @ins > 0 and @del = 0
		print 'Добавили'
	else if @ins = 0 and @del > 0
		print 'Удалили'
	else if @ins > 0 and @del > 0
		print 'Изменили'

end

insert EMPLOYEES values(321, 'asddsad','asddasda', GETDATE(), 'м', '')
update EMPLOYEES set NAME = '1' where ID = 321
delete from EMPLOYEES where ID = 321

drop trigger TR_EMPLOYEES

-- 11 задание
go
use SHU_UNIVER
go
create table WEATHER
(	
	id int identity,
	Город varchar(20),
	Начальная_дата datetime,
	Конечная_дата datetime,
	Температура int
)


insert WEATHER values('Минск', '01.01.2017 00:00', '01.01.2017 23:59', -6)

go
create trigger TR_WEATHER 
						on WEATHER after INSERT, UPDATE
as
begin
	declare @ins int = (select count(*) from inserted),
			@del int = (select count(*) from deleted),
			@count int,
			@newCity varchar(20),
			@beginDate datetime,
			@endDate datetime;

	set @newCity = (select top(1) Город from inserted);
	set @beginDate = (select top(1) Начальная_дата from inserted);
	set @endDate = (select top(1) Конечная_дата from inserted);
	
	if @beginDate >= @endDate
	begin 
		raiserror('Некорректно заданы Начальная_дата и Конечная_дата',10,1)
		rollback;
	end

	set @count = (select count(*) 
							from WEATHER 
							where Город = @newCity
							and (
								(Начальная_дата <= @beginDate and Конечная_дата >= @endDate)
								or
								(Начальная_дата >= @beginDate and Конечная_дата <= @endDate)
								)
				)

	print @count
	if @count > 1
	begin
		raiserror('Невозможно произвести действие',10,1)
		rollback;
	end
end

select * from WEATHER

insert WEATHER values('Минск', '01.01.2017 10:00', '01.01.2017 22:59', -2)

insert WEATHER values('Минск', '01.01.2017 23:59', '02.01.2017 02:59', -2)

update WEATHER set Начальная_дата = '01.01.2017 00:00', Конечная_дата = '01.01.2017 23:59'
		where Город = 'Минск' and Начальная_дата = '01.01.2017 23:59'

drop trigger TR_WEATHER

