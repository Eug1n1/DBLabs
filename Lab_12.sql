-- 1 �������
use SHU_UNIVER
set nocount on
if  exists (select * from  SYS.OBJECTS        -- ������� X ����?
	            where OBJECT_ID= object_id(N'DBO.X') )	            
	drop table X;           
declare @c int, @flag char = 'f';           -- commit ��� rollback?
set IMPLICIT_TRANSACTIONS  on	-- �����. ����� ������� ����������
create table X(K int );                         -- ������ ���������� 
insert X values (1),(2),(3);
set @c = (select count(*) from X);
print '���������� ����� � ������� X: ' + cast( @c as varchar(2));
if @flag = 'c'  commit;                   -- ���������� ����������: �������� 
else   rollback;                                 -- ���������� ����������: �����  
set IMPLICIT_TRANSACTIONS  off   -- ������. ����� ������� ����������
	
if  exists (select * from  SYS.OBJECTS       -- ������� X ����?
	 where OBJECT_ID= object_id(N'DBO.X') )
	print '������� X ����';  
else
	print '������� X ���'
      

-- 2 �������

begin try
	begin tran
		insert FACULTY values('���', '���������� �������� �����')
		insert FACULTY values('��','������ ���������')
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

insert FACULTY values('��','������ ���������')
-- 3 �������

select * from FACULTY
insert FACULTY values('���','������ ������ ���������')

delete from FACULTY where FACULTY = '��A       '

declare @checkpoint varchar(3) = 'p0'
begin try
	begin tran
		select * from FACULTY
		save tran @checkpoint
		delete from FACULTY where FACULTY='���'
		set @checkpoint = 'p1';
		save tran @checkpoint
		insert FACULTY values('��','������ �� �� ������')
		set @checkpoint = 'p2';
		save tran @checkpoint;
	commit tran
end try
begin catch
	print error_number()
	print error_message()
	print @@trancount	
	print concat('������ ��������� �� ����������� �����:', @checkpoint)
	if (@checkpoint = 'p0')
		print '���������� ���������� ��������'
	else
		print '���������� ���������� ������� ��������'
	rollback tran @checkpoint
	commit tran
end catch

-- 4 �������
--------A----
set transaction isolation level READ UNCOMMITTED
begin transaction
-------------------------- t1 ------------------
	select @@SPID, count(*) from FACULTY
	select * from FACULTY
-------------------------- t2 -----------------
rollback tran


-- 5 �������

select * from FACULTY

set transaction isolation level READ COMMITTED
begin transaction
	select count(*) from FACULTY where FACULTY like '�%';
	-------------------------- t1 ------------------
-------------------------- t2 -----------------
	select count(*) from FACULTY where FACULTY like '�%';
	
rollback tran;


-- 6 �������
-- A ---
set transaction isolation level REPEATABLE READ
begin transaction
select * from [SUBJECT] where PULPIT = '����';
-------------------------- t1 ------------------
-------------------------- t2 -----------------
select * from [SUBJECT] where PULPIT = '����';
commit;

delete from [SUBJECT] where SUBJ = 'NewSubj'

-- 7 �������
-- A ---
set transaction isolation level SERIALIZABLE
begin transaction
insert [SUBJECT] values ('NewSubj2', 'NS2', '����');
update [SUBJECT] set SUBJECT_NAME = 1 where SUBJ = 'NewSubjs2'
select * from [SUBJECT] as s  where s.PULPIT= '����';
-------------------------- t1 -----------------
select * from [SUBJECT] as s  where s.PULPIT= '����';
-------------------------- t2 ------------------
commit;
rollback

dbcc useroptions	


-- 8 �������
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


-- 9 �������

use SHU_MYBASE2

declare @mycheckpoint nvarchar(2)
begin try
	begin tran
	set @mycheckpoint = 'p0' 
	save tran @mycheckpoint
	insert POSITION values('���������� ���������', '���������', '������ �����')
	set @mycheckpoint = 'p1'
	save tran @mycheckpoint
	insert POSITION values('����', '������� �����', '������ ���� �����')
	set @mycheckpoint = 'p3'
	save tran @mycheckpoint
	delete from POSITION where POSITION_NAME = '����'
	commit tran
end try
begin catch
	PRINT ERROR_MESSAGE()
    rollback tran @mycheckpoint
end catch

select * from POSITION