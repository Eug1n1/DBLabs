-- 1 �������
use SHU_UNIVER
go
create procedure psubject
as
begin
	select s.SUBJ[���], s.SUBJECT_NAME[����������], s.PULPIT[�������]
		from [SUBJECT] as s
	return 	@@rowcount
end

drop procedure psubject

set nocount on
declare @rows int;
exec @rows =  psubject
print'���������� �����: ' +  cast(@rows as varchar)


-- 2 �������

go
alter procedure [dbo].[psubject] @p varchar(20) = null, @c int output 
as begin

	select s.SUBJ[���], s.SUBJECT_NAME[����������], s.PULPIT[�������]
		from [SUBJECT] as s
		where s.PULPIT = @p
	set @c = @@ROWCOUNT;
	declare @r int = (select count(*) from [SUBJECT])
	return 	@r
end

drop procedure psubject

go
declare @k int = 0, @r int =0, @p varchar(20);
exec @k = psubject @p = '����', @c = @r output

print '���������� �����: ' + cast(@k as varchar)
print '���������� ���������:' + cast(@r as varchar)


-- 3 �������

create table #subject
(
  s char(10),
  s_name varchar(100),
  p char(20)
)

go
alter procedure psubject  @p varchar(20) = null
as begin
	select s.SUBJ, s.SUBJECT_NAME, s.PULPIT
		from [SUBJECT] as s
		where s.PULPIT = @p
end

insert #subject exec psubject @p = '����'

select * from #subject

-- 4 �������
go
drop procedure PAUDITORIUM_INSERT
go
create procedure PAUDITORIUM_INSERT @a char(20), @n varchar(50), @c int = 0, @t char(10)
as 
	declare @rc int = 1;
	begin try
		insert AUDITORIUM values(@a, @n, @c, @t);
		return @rc
	end try
	begin catch
		
		print '����� ������: ' + cast(error_number() as varchar)
		print '���������: ' + error_message();
		print '�������: ' + cast(error_severity() as varchar)
		if error_procedure() is not null
			print '��� ���������: ' + error_procedure();
		
		return -1;
	end catch


go
declare @rc int; 
exec @rc = pauditorium_insert @a = '222-2', @n = '��-�', @c = 60, @t = '222-2' --������

go
declare @rc int; 
exec @rc = PAUDITORIUM_INSERT @a = '222-2', @n = '��-�', @c = 60, @t = '222-2'
delete from AUDITORIUM where AUDITORIUM = '222-2'

select * from AUDITORIUM

-- 5 �������


go
create procedure subject_report 
	@p varchar(10)
as
begin try
	declare @rc int = 0;
		
	declare @sbj char(20),  @s char(300) = '';
	declare SpecsCursor cursor local
	for select s.SUBJ from [SUBJECT] as s where s.PULPIT = @p
	
		if not exists (select s.SUBJ from [SUBJECT] as s where s.PULPIT = @p)
			raiserror('������ � ����������', 11, 1);
		else 
			open SpecsCursor;
			fetch SpecsCursor into @sbj;
			while @@FETCH_STATUS = 0
			begin
				set @rc = @rc + 1;
				set @s = rtrim(@sbj)+', '+@s;
				fetch SpecsCursor into @sbj;
			end
			print substring(@s, 0 , len(@s));
			close SpecsCursor
		return @rc
end try
begin catch 
		print '����� ������: ' + cast(error_number() as varchar)
		print '���������: ' + error_message();
		print '�������: ' + cast(error_severity() as varchar)
		if ERROR_PROCEDURE() is not null
			print '��� ���������: ' + error_procedure();
		
		return -1;
end catch

drop procedure subject_report

go
declare @subjs int = 0
exec @subjs = subject_report @p = '����'
print '���������� �����: ' + cast(@subjs as varchar)


--- 6 �������
go
drop procedure PAUDITORIUM_INSERTX
go
create procedure PAUDITORIUM_INSERTX @a char(20), @n varchar(50), @c int = 0, @t char(10), @tn varchar(50) 
as
declare @rc int = 1;
begin try
	set transaction isolation level serializable;
	begin tran
		insert AUDITORIUM_TYPE values(@n, @tn);
		exec @rc = pauditorium_insert @a, @n, @c, @t
	commit tran
	return @rc
end try
begin catch
	print '����� ������: ' + cast(error_number() as varchar)
	print '���������: ' + error_message();
	print '�������: ' + cast(error_severity() as varchar)
	if ERROR_PROCEDURE() is not null
		print '��� ���������: ' + error_procedure();
	if @@TRANCOUNT > 0
		rollback tran;
	return -1;
end catch

select * from AUDITORIUM
select * from AUDITORIUM_TYPE
go
declare @rc int;
exec @rc = PAUDITORIUM_INSERTX @a = '1337', @n = '���', @c = 100, @t = '1337', @tn = '�������'
delete from AUDITORIUM where AUDITORIUM = '1337'
delete from AUDITORIUM_TYPE where AUDITORIUM_TYPE = '���'

-- 7 �������
use SHU_MYBASE2
go
create procedure EMPLOYES_COUNT
as 
begin
	select * from EMPLOYEES
	return @@rowcount
end
go
declare @r int

go
drop procedure PRINT_EMPLOYES
go
create procedure PRINT_EMPLOYES
as 
begin
	declare @name nvarchar(64)
	declare employeeCursor cursor local
	for select [NAME] from EMPLOYEES
	open employeeCursor
		fetch employeeCursor into @name
		while @@FETCH_STATUS = 0
		begin
			print @name
			fetch employeeCursor into @name
		end
	close employeeCursor
end
go
declare @r int

exec @r = PRINT_EMPLOYES
print @r



-- 8 �������
go
deallocate  faculties
deallocate  pulpits
deallocate  subjects
drop procedure PRINT_REPORT

go
create procedure PRINT_REPORT @f char(10) = null, @p char(10) = null 
as
declare faculties cursor  static 
for select FACULTY from FACULTY

declare pulpits cursor  static 
for select PULPIT from  PULPIT

declare subjects cursor static 
for select SUBJ from [SUBJECT]

declare @tchNum int = 0, @s varchar(10) = '', @ss varchar(300) = ''

if @f != '' and @p = ''
	begin
	print '���������: ' + @f
	------------------------
	open pulpits
	fetch pulpits into @p
	while @@FETCH_STATUS = 0
	begin
		if exists(select PULPIT from PULPIT where PULPIT = @p and PULPIT in (select PULPIT from  PULPIT where FACULTY = @f))
		begin
			print '   �������: ' + @p
			set @tchNum = (select count(*) from TEACHER where PULPIT = @p)
			print '      ���������� ��������������: ' + cast(@tchNum as varchar(10))
			------------------------------------------------------------------------
			open subjects
			fetch subjects into @s
			while @@FETCH_STATUS = 0
			begin
				if @s in (select SUBJ from [SUBJECT] where PULPIT = @p)
					set @ss = RTRIM(@s) + ', ' + @ss
				fetch subjects into @s
			end
			if @ss = ''
				print '      ��������: ���'
			else
				print '      ��������: ' + @ss
			set @ss = ''
			close subjects
			------------------------------------------------------------------------
		end
		fetch pulpits into @p
	end
	close pulpits
end 
else if @f != '' and @p != ''
	begin
		print '���������: ' + @f
		print '   �������: ' + @p
		set @tchNum = (select count(*) from TEACHER where PULPIT = @p)
		print '      ���������� ��������������: ' + cast(@tchNum as varchar(10))
		------------------------------------------------------------------------
		open subjects
		fetch subjects into @s
		while @@FETCH_STATUS = 0
		begin
			if @s in (select SUBJ from [SUBJECT] where PULPIT = @p)
				set @ss = RTRIM(@s) + ', ' + @ss
			fetch subjects into @s
		end
		if @ss = ''
			print '      ��������: ���'
		else
			print '      ��������: ' + @ss
		set @ss = ''
		close subjects
	end
else if @f = '' and @p != ''
	begin 
		set @f = (select FACULTY from PULPIT where PULPIT = @p)
		print '���������: ' + @f
		print '   �������: ' + @p
		set @tchNum = (select count(*) from TEACHER where PULPIT = @p)
		print '      ���������� ��������������: ' + cast(@tchNum as varchar(10))
		------------------------------------------------------------------------
		open subjects
		fetch subjects into @s
		while @@FETCH_STATUS = 0
		begin
			if @s in (select SUBJ from [SUBJECT] where PULPIT = @p)
				set @ss = RTRIM(@s) + ', ' + @ss
			fetch subjects into @s
		end
		if @ss = ''
			print '      ��������: ���'
		else
			print '      ��������: ' + @ss
		set @ss = ''
		close subjects
	end
deallocate  faculties
deallocate  pulpits
deallocate  subjects



exec PRINT_REPORT @f = '��', @p = ''

drop procedure PRINT_REPORT

