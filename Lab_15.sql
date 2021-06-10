use SHU_UNIVER
set nocount on

-- 1 �������
create table TR_AUDIT
(
	ID int identity,
	STMT varchar(20)  -- ��������
			check(STMT in ('INS', 'DEL', 'UPD')), 
	TRNAME varchar(50),
	CC varchar(300)
)

drop table TR_AUDIT

go
create trigger TR_TEACHER_INS
						on TEACHER after INSERT
as 
	print '�������: INSERT'
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


insert TEACHER values('������', '�� ��� �� ����� ���� ����', '�', '����')
delete from TEACHER where TEACHER = '������'
select * from TR_AUDIT;
select * from TEACHER

drop trigger TR_TEACHER_INS

-- 2 �������
go
create trigger TR_TEACHER_DEL 
							on TEACHER after DELETE
as
	print '�������: DELETE'
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

delete from TEACHER where TEACHER = '������'
select * from TR_AUDIT;

drop trigger TR_TEACHER_DEL
-- 3 �������
go
create trigger TR_TEACHER_UPD 
							on TEACHER after UPDATE
as
	print '�������� ������� UPDATE'

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

	insert TR_AUDIT values('UPD', 'TR_TEACHER_UPD', CONCAT('����: ', @values, '�����: ', @values2))

update TEACHER set TEACHER = '���', TEACHER_NAME ='�� ���� ��������' where TEACHER = '������'
select * from TR_AUDIT;
delete from TEACHER where TEACHER = '���'
drop trigger TR_TEACHER_UPD

-- 4 �������
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
		print '������� INSERT'
		set @t = (select TEACHER from inserted);
		set @tname = (select TEACHER_NAME from inserted);
		set @gender = (select GENDER from inserted);
		set @p = (select PULPIT from inserted);
		set @values = CONCAT(@t,', ', @tname, ', ', @gender, ', ', @p);
		insert TR_AUDIT values('INS', 'TR_TEACHER', @values);
	end
	else if @ins = 0 and @del > 0
	begin
		print '������� DELETE'
		set @t = (select TEACHER from deleted);
		set @tname = (select TEACHER_NAME from deleted);
		set @gender = (select GENDER from deleted);
		set @p = (select PULPIT from deleted);
		set @values = CONCAT(@t,', ', @tname, ', ', @gender, ', ', @p);
		insert TR_AUDIT values('DEL', 'TR_TEACHER', @values);

	end
	else if @ins > 0 and @del > 0
		begin
		print '������� UPDATE'
		set @t = (select TEACHER from inserted);
		set @tname = (select TEACHER_NAME from inserted);
		set @gender = (select GENDER from inserted);
		set @p = (select PULPIT from inserted);
		set @values = CONCAT(@t,', ', @tname, ', ', @gender, ', ', @p);

		set @t = (select TEACHER from deleted);
		set @tname = (select TEACHER_NAME from deleted);
		set @gender = (select GENDER from deleted);
		set @p = (select PULPIT from deleted);

		set @values = CONCAT('����: ', @values, '. �����: ', CONCAT(@t,', ', @tname, ', ', @gender, ', ', @p));
		insert TR_AUDIT values('UPD', 'TR_TEACHER', @values);
	end
end

delete from TR_AUDIT
drop trigger TR_TEACHER_INS
drop trigger TR_TEACHER_DEL
drop trigger TR_TEACHER_UPD

drop trigger TR_TEACHER

insert TEACHER values('������', '�� ��� �� ����� ���� ����', '�', '����')
update TEACHER set TEACHER = '��fc�', TEACHER_NAME ='�� ���� ��������' where TEACHER = '������'
delete from TEACHER where TEACHER = '������'

select * from TR_AUDIT
select * from TEACHER

-- 5 �������

alter table TEACHER add constraint Gender check(Gender in('�','�', '�'))
insert TEACHER values('��s�', '��� �� �s�', '�', '����')
select * from TEACHER

alter table TEACHER drop constraint Gender

-- 6 �������
go
create trigger TR_TEACHER_DEL1
								on TEACHER after DELETE
as
	print '������� DELETE1'
	
go
create trigger TR_TEACHER_DEL2
								on TEACHER after DELETE
as
	print '������� DELETE2'

go
create trigger TR_TEACHER_DEL3
								on TEACHER after DELETE
as
	print '������� DELETE3'
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



-- 7 �������

go
create trigger TR_TEACHER_DELTRAN
								on TEACHER after DELETE
as
	declare @tname varchar(100)  = (select top(1) TEACHER from deleted)
	if @tname = '����'
	begin
		raiserror('!!!�� �� ������ � ������� �������, �� ������� ��� � ����� ��������?!!!', 10, 1);
		rollback;
	end;
	return;

insert into TEACHER values ('����','����� ������� �������������','�','����')
delete from TEACHER where TEACHER = '����'
select * from teacher   

-- 8 �������
go
create trigger TR_FACULTY 
						on FACULTY instead of DELETE
as
	raiserror('����� ������� �������', 10, 1)

delete from FACULTY where FACULTY = '���'
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

-- 9 �������w
go
create trigger TR_UNIVER on database
						 for DDL_DATABASE_LEVEL_EVENTS 
as begin
	declare @t varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(50)'),
			@t1 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(50)'),
			@t2 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]', 'varchar(50)'),
			@t3 nvarchar(64);

	print '��� �������: ' + @t;
	print '��� �������: ' + @t1;
	print '��� �������: ' + @t2;

	if @t in('CREATE_TABLE', 'DROP_TABLE')
	begin
		if @t = 'CREATE_TABLE' 
			set @t3 = concat('���� �������: ', @t1)
		else if @t = 'DROP_TABLE'
			set @t3 = concat('���� �������: ', @t1)
		
		raiserror(@t3, 10, 1);
		rollback;
	end
end

DROP TRIGGER TR_UNIVER ON DATABASE;

drop table TIMETABLE
create table tabletable(aboba int)
go

-- 10 �������
use SHU_MYBASE2
go

create trigger TR_MYBASE on database
						 for DDL_DATABASE_LEVEL_EVENTS 
as begin
	declare @t varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(50)'),
			@t1 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(50)'),
			@t2 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]', 'varchar(50)'),
			@t3 nvarchar(64);

	print '��� �������: ' + @t;
	print '��� �������: ' + @t1;
	print '��� �������: ' + @t2;

	if @t in('CREATE_TABLE', 'DROP_TABLE')
	begin
		if @t = 'CREATE_TABLE' 
			set @t3 = concat('���� �������: ', @t1)
		else if @t = 'DROP_TABLE'
			set @t3 = concat('���� �������: ', @t1)
		
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
		print '��������'
	else if @ins = 0 and @del > 0
		print '�������'
	else if @ins > 0 and @del > 0
		print '��������'

end

insert EMPLOYEES values(321, 'asddsad','asddasda', GETDATE(), '�', '')
update EMPLOYEES set NAME = '1' where ID = 321
delete from EMPLOYEES where ID = 321

drop trigger TR_EMPLOYEES

-- 11 �������
go
use SHU_UNIVER
go
create table WEATHER
(	
	id int identity,
	����� varchar(20),
	���������_���� datetime,
	��������_���� datetime,
	����������� int
)


insert WEATHER values('�����', '01.01.2017 00:00', '01.01.2017 23:59', -6)

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

	set @newCity = (select top(1) ����� from inserted);
	set @beginDate = (select top(1) ���������_���� from inserted);
	set @endDate = (select top(1) ��������_���� from inserted);
	
	if @beginDate >= @endDate
	begin 
		raiserror('����������� ������ ���������_���� � ��������_����',10,1)
		rollback;
	end

	set @count = (select count(*) 
							from WEATHER 
							where ����� = @newCity
							and (
								(���������_���� <= @beginDate and ��������_���� >= @endDate)
								or
								(���������_���� >= @beginDate and ��������_���� <= @endDate)
								)
				)

	print @count
	if @count > 1
	begin
		raiserror('���������� ���������� ��������',10,1)
		rollback;
	end
end

select * from WEATHER

insert WEATHER values('�����', '01.01.2017 10:00', '01.01.2017 22:59', -2)

insert WEATHER values('�����', '01.01.2017 23:59', '02.01.2017 02:59', -2)

update WEATHER set ���������_���� = '01.01.2017 00:00', ��������_���� = '01.01.2017 23:59'
		where ����� = '�����' and ���������_���� = '01.01.2017 23:59'

drop trigger TR_WEATHER

