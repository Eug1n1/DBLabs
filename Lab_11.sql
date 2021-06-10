use SHU_UNIVER
--- 1 задание
go
declare @sbj char(20),  @s char(300) = '';
declare Specs cursor local
	for select s.SUBJ from [SUBJECT] as s where s.PULPIT ='ИСиТ'

open Specs;
fetch Specs into @sbj;
print 'Предметы на ИСиТ'

while @@FETCH_STATUS = 0
begin
	set @s = rtrim(@sbj)+', '+@s;
	fetch Specs into @sbj;
end
print @s
close Specs

-- 2 задание

-- локальный
go
declare curs cursor local
	for select STUDENT.NAM from STUDENT

declare @str char(20)
open curs
fetch curs into @str
print @str
go
declare @str char(20)
fetch curs into @str
print @str
close curs
-- глобальный
go
declare curs cursor global
	for select STUDENT.NAM from STUDENT
declare @str char(20)
open curs
fetch curs into @str
print @str
close curs
go
declare @str char(20)
open curs
fetch curs into @str
print @str
close curs

-- 3 задание

insert FACULTY values('Ф', 'факультет физры')

go
declare @st char(20), @st2 char(20)


declare Curs cursor local static 
	for select FACULTY.FACULTY from FACULTY


open curs;

--deallocate curs
--deallocate cursdyn
delete from FACULTY where FACULTY.FACULTY = 'Ф'

fetch first from curs into @st
while @@FETCH_STATUS = 0
begin
	 fetch curs into @st 
	 print @st
end

print '---------------------'
close curs

go
declare @st char(20), @st2 char(20)

declare CursDyn cursor local  dynamic 
	for select FACULTY.FACULTY from FACULTY
open cursdyn

insert FACULTY values('Ф', 'факультет физры')

fetch CursDyn into @st2
print @st2
while @@FETCH_STATUS = 0
begin
	 fetch CursDyn into @st2 
	 print @st2
end
close cursdyn


-- 4 задание
go
declare curs4 cursor local dynamic scroll
	for select row_number() over (order by student.Nam)[номер строки],
		STUDENT.NAM
		from student 

declare @str char(50), @numb int
open curs4
fetch last from curs4 into @numb, @str;
print str(@numb) + ' ' + @str

fetch absolute 3 from curs4 into @numb, @str
print str(@numb) + ' ' + @str

fetch relative 2 from curs4 into @numb, @str
print str(@numb) + ' ' + @str

fetch relative -2 from curs4 into @numb, @str
print str(@numb) + ' ' + @str

fetch prior from curs4 into @numb, @str
print str(@numb) + ' ' + @str

fetch next from curs4 into @numb, @str
print str(@numb) + ' ' + @str


close curs4


-- 5 задание
go
update student set bday = '2018-02-02' where IDSTUDENT = 1000
select * from student
declare @fac char(40), @gr date
declare curs cursor	local dynamic scroll 
	for select NAM, BDAY from STUDENT for update

open curs
fetch  from curs into @fac, @gr;
print @fac
update student set bday = getdate() where current of curs
--delete student where current of curs
close curs

select * from student


-- 6 задание
insert PROGRESS values('ОАиП',1000,	getdate(), 3)
insert PROGRESS values('ОАиП',1005,	getdate(), 3)
insert PROGRESS values('ОАиП',1003,	getdate(), 3)

select * from PROGRESS 

go
declare @str char(50)
--deallocate curs2
declare curs2 cursor local dynamic
	for select student.IDSTUDENT 
		from student join PROGRESS
		on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT
		join groups 
		on groups.IDGROUP = STUDENT.IDGROUP
		where PROGRESS.note < 4 for update


open curs2
fetch curs2 into @str

while @@FETCH_STATUS = 0
begin

	print @str
	delete from progress where current of curs2
	fetch curs2 into @str
	--delete from student where current of curs2
end

close curs2

select student.NAM, progress.note
		from student join PROGRESS
		on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT
		where PROGRESS.note < 4



declare @stid int = 1001, @note int

update progress set note = 5 where IDSTUDENT  = @stid

declare curs cursor local dynamic 
	for select PROGRESS.note 
	from STUDENT join PROGRESS
	on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT
	where STUDENT.IDSTUDENT = 1001 for update

open curs

fetch curs into @note 
while @@FETCH_STATUS = 0
begin
	update PROGRESS set note = note + 1 where current of curs
	fetch curs into @note 
end

close curs

-- 7 задание
go
use SHU_MYBASE2

declare @str char(64) 

declare curs cursor local dynamic
	for select SURNAME from EMPLOYEES

open curs
fetch curs into @str

while @@FETCH_STATUS = 0 
begin
	print @str
	fetch curs into @str
end

close curs

print '-------------------------'

go 
declare @str char(64) 
declare curs cursor local static
	for select [NAME] from EMPLOYEES 

open curs
	fetch  absolute 2 from curs into @str
	print @str
	fetch relative -1 from curs into @str
	print @str
close curs

-- 8 задание
use SHU_UNIVER
go
declare mycurs cursor local dynamic
	for select FACULTY.FACULTY,PULPIT.PULPIT, count(*), s.SUBJ
	from FACULTY join PULPIT
	on FACULTY.FACULTY=PULPIT.FACULTY
	full join [SUBJECT] as s ON PULPIT.PULPIT=s.PULPIT
	full JOIN TEACHER ON TEACHER.PULPIT=PULPIT.PULPIT
	GROUP BY FACULTY.FACULTY,PULPIT.PULPIT,s.SUBJ

declare @FACULTY varchar(50),
		@PULPIT varchar(50),
		@TEACHER int,
		@SUBJECT varchar(50),
		@FACULTY2 varchar(50),
		@set_str varchar(Max)=''

open mycurs
fetch mycurs into @FACULTY, @PULPIT, @TEACHER, @SUBJECT

while  @@FETCH_STATUS=0
BEGIN

	set @FACULTY2=@FACULTY
	
	print 'Факультет:'+ @FACULTY
	print ' Кафедра:'+ @PULPIT
	if(@TEACHER=0)
		begin
			print '  Количество преподавателей:нет'
		end
	else
		begin
			print '  Количество преподавателей:'+cast(@TEACHER as varchar(10))
		end
	while( @FACULTY2=@FACULTY)
	BEGIN
		set @set_str=rtrim(@SUBJECT)+','+@set_str;
		fetch mycurs into @FACULTY,@PULPIT,@TEACHER,@SUBJECT
	END
	print '   Предмет:'+@set_str
	set @set_str=''
	fetch mycurs into @FACULTY,@PULPIT,@TEACHER,@SUBJECT
END
close mycurs
