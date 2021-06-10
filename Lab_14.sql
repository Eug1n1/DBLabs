go
-- 1 задание
drop function COUNT_STUDENTS
go
create function COUNT_STUDENTS(@faculty varchar(20)) returns int
as 
begin
	declare @count int = 0;
	set @count = (select count(*)
			from faculty join groups
			on faculty.faculty = groups.faculty
			join student
			on student.idgroup = groups.idgroup
			where faculty.faculty = @faculty);

	return @count;
end


go
print dbo.count_students('ХТиТ')

alter function COUNT_STUDENTS(@faculty varchar(20) = null,
			@prof varchar(20) = null) returns int
as begin
	declare @count int = 0;
	set @count = (select count(*) 
	from faculty join groups 
	on faculty.faculty = groups.faculty
	join student
	on student.idgroup = groups.idgroup
	where faculty.faculty = @faculty and groups.profession = isnull(@prof, groups.profession))

	return @count;
end

print dbo.count_students('ХТиТ', '1-36 01 08')

select distinct faculty.faculty, dbo.count_students(faculty.faculty, groups.profession)
	from faculty
	join groups 
	on faculty.faculty = groups.faculty

-- 2 задание
go
create function fsubjects(@p varchar(20)) returns varchar(300)
as begin
	declare @subj varchar(300) = 'Дисциплины:';
	declare @temp varchar(10) = '';
	declare subjCursor cursor local static 
	for select SUBJ from [SUBJECT]
		where PULPIT = @p;

	open subjCursor
		fetch subjCursor into @temp;

		while @@FETCH_STATUS = 0
		begin
			set @subj = @subj + ',' + rtrim(@temp);
			fetch subjCursor into @temp;
		end
	close subjCursor
	return @subj
end

select pulpit, dbo.fsubjects(pulpit)
	from pulpit


-- 3 задание
go
create function FFACPUL(@f varchar(10), @p varchar(20)) returns table
as 
return
	select f.faculty, p.pulpit
		from faculty as f
		left join pulpit as p
		on f.faculty = p.faculty
		where f.faculty = isnull(@f, f.faculty)
		and p.pulpit = isnull(@p, p.pulpit);

select * from dbo.FFACPUL('ИДиП', null)
select * from dbo.FFACPUL('ИДиП', 'БФ')
select * from dbo.FFACPUL(null, 'ИСиТ')
select * from dbo.FFACPUL(null, null)
select * from dbo.FFACPUL('ss', 'fff')

drop function FFACPUL
	
-- 4 задание
go
create function FTEACHER(@p varchar(20)) returns int
as 
begin
	declare @count int = 0;

	set @count = (select count(*) 
			from teacher as t
			where t.pulpit = isnull(@p, t.pulpit))
	return @count
end

select pulpit, dbo.FTEACHER(pulpit)
	from pulpit

select dbo.FTEACHER(null)

-- 5 задание
use SHU_MYBASE2
go
create function COUNT_EMPLOYEEES() returns int
as 
begin
	declare @count int = (select count(*) from EMPLOYEES)
	return @count
end

go
print dbo.COUNT_EMPLOYEEES()
go
drop function COUNT_EMPLOYEEES
go

create function SHOW_ALL() returns table
as 
	return select en.ID, en.DEPARTMENT, en.POSITION_NAME, em.NAME, em.SURNAME, em.ID[другой id], p.REQUIREMENTS 
	from
	EMPLOYEES as em join ENROLLMENT as en
	on em.ID = en.ID
	join POSITION as p
	on p.POSITION_NAME = en.POSITION_NAME

go
select * from SHOW_ALL()

drop function SHOW_ALL

-- 6 задание
use SHU_UNIVER
go
create function COUNT_PULPITS(@f varchar(10)) returns int
as
begin
	declare @count int = 0;
	set @count = (select count(*) 
			from pulpit
			where pulpit.faculty = @f)
	return @count
end
go
create function COUNT_GROUPS(@f varchar(10)) returns int
as
begin
	declare @count int = 0;
	set @count = (select count(*) 
			from groups
			where groups.faculty = @f)
	return @count
end

go
create function COUNT_PROFESSIONS(@f varchar(10)) returns int 
as
begin
	declare @count int = 0;
	set @count = (select count(*) 
			from profession
			where profession.faculty = @f)
	return @count
end

drop function COUNT_PULPITS
drop function COUNT_GROUPS
drop function COUNT_PROFESSIONS


go
create function FACULTY_REPORT(@c int) 
	returns @fr table( [Факультет] varchar(50), [Количество кафедр] int, [Количество групп]  int, 
	          [Количество студентов] int, [Количество специальностей] int )
as begin 
   declare cc CURSOR static for 
	  select FACULTY from FACULTY 
          where dbo.COUNT_STUDENTS(FACULTY, default) > @c; 
	    declare @f varchar(30);
	    open cc;  
        fetch cc into @f;
	    while @@fetch_status = 0
		begin
			insert @fr values
			(
				@f,  
				dbo.COUNT_PULPITS(@f),
			       dbo.COUNT_GROUPS(@f),   
				dbo.COUNT_STUDENTS(@f, default),
				dbo.COUNT_PROFESSIONS(@f)
			); 
			fetch cc into @f;  
		end;   
       return; 
end;

select * from FACULTY_REPORT(0)

drop function FACULTY_REPORT

-- 7 задание
create procedure PRINT_REPORTX @ff char(10) = null, @pp char(10) = null 
as
declare pulpits cursor for select PULPIT from  PULPIT
declare faculties cursor for select FACULTY from FACULTY

declare @f varchar(10) = @ff, @p varchar(10) = @pp, @tchNum int = 0, @s varchar(10) = '', @ss varchar(300) = ''
open faculties
	fetch faculties into @f
	while @@FETCH_STATUS = 0
	begin
		print 'факультет: ' + @f
		------------------------
		open pulpits
		fetch pulpits into @p
		while @@FETCH_STATUS = 0
		begin
			if exists(select PULPIT from PULPIT where PULPIT = @p and PULPIT.FACULTY = @f)
			begin
				print '   кафедра: ' + @p
				set @tchNum = dbo.FTEACHER(@p)
				print '      количество преподавателей: ' + cast(@tchNum as varchar(10))
				------------------------------------------------------------------------
				set @ss = dbo.fsubjects(@p)
				if @ss = ''
					print '      предметы: нет'
				else
					print '      предметы: ' + @ss
				set @ss = ''
				----------------------------------------------------------------------
			end
			fetch pulpits into @p
		end
		close pulpits
		------------------------
		fetch faculties into @f
	end
close faculties
deallocate faculties
deallocate pulpits


drop procedure print_reportx

exec print_reportx @ff = '', @pp = ''
