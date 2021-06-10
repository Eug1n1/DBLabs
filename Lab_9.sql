use SHU_UNIVER

declare @a char = 'Б', 
	@b varchar = 'БГУГиТ', 
	@c datetime, 
	@d time, 
	@e int, 
	@f smallint, 
	@g tinyint, 
	@h numeric(12, 5);

	set @c = getdate();
	set @d = getdate();
	set @e = (select count(*) from STUDENT);
	set @f = (select count(*) from STUDENT where STUDENT.IDGROUP = 5);
	set @g = (select min(AUDITORIUM_CAPACITY) from AUDITORIUM);

	print 'a=' + @a;
	print 'b=' + @b;
	print 'c=' + cast(@c as varchar(20));

	select @d;
	select @e;
	select @f;
	select @g;
	select @h;

-- 2

declare @y1 int = (select sum(AUDITORIUM_CAPACITY) from AUDITORIUM),
@y2 int, @y3 numeric(8,3), @y4 int, @y5 numeric(8,3)
if @y1 > 200
begin
	select @y2 = (select count(*) from AUDITORIUM),
		   @y3 = (select cast(avg(AUDITORIUM_CAPACITY) as numeric(8,3)) from AUDITORIUM)
	set @y4 = (select count(*) from AUDITORIUM where AUDITORIUM_CAPACITY < @y3)
	set @y5 = (@y4 * 100) / @y2
	select @y1 'Общаяя вместительность', @y2 'Количество аудиторий',
		   @y3 'Средняя вместительность', @y4 'кол-во с вместимостью меньше средней',
		   @y5 'процент аудиторий, вместимость которых меньше средней'
end
else if @y1 < 200 print 'Общая вместительность: ' + cast(@y1 as varchar(10));
else print 'Общая вместительность равна 200';

select * from AUDITORIUM;

-- 3

print '@@VERSION = ' + @@VERSION
print '@@ROWCOUNT = ' + cast(@@ROWCOUNT as varchar(10))
print '@@SPID = ' + cast(@@SPID as varchar(10))
print '@@ERROR = ' + cast(@@ERROR as varchar(10))
print '@@SERVERNAME = ' + cast(@@SERVERNAME as varchar(10))
print '@@TRANCOUNT = ' + cast(@@TRANCOUNT as varchar(10))
print '@@FETCH_STATUS = ' + cast(@@FETCH_STATUS as varchar(10))
print '@@NESTLEVEL = ' + cast(@@NESTLEVEL as varchar(10))

-- 4.1

declare @t int = 1, @z float, @x int = 5;
if (@t > @x) set @z = power(sin(@t), 2)
else if (@t < @x) set @z = 4 * (@t + @x)
else set @z = 1 - exp(@x - 2);

print 'z = ' + cast(@z AS VARCHAR(10));
 
-- 4.2

declare @data4b nvarchar(50);
declare @result4b nvarchar(50);
set @data4b = 'Шумский Евгений Сергеевич';

print 'Полное ФИО: ' + @data4b;

set @result4b = substring(@data4b, 1, charindex(' ', @data4b)) +
				substring(@data4b, charindex(' ', @data4b) + 1, 1) + '.' +
				substring(@data4b, charindex(' ', @data4b, charindex(' ', @data4b) + 1) + 1, 1) + '.';

print 'Сокращённое ФИО: ' + @result4b;

-- 4.3

declare @month nchar(2) = month(DATEADD(month, 1, GETDATE()));

select IDSTUDENT, IDGROUP, NAM, BDAY, datediff(YEAR, BDAY, GETDATE()) as AGE
from STUDENT where month(BDAY) = @month;

-- 4.4

declare @group_number int = 5;

select top(1) datename(weekday, PDATE) AS "WEEKDAY"
from PROGRESS join STUDENT
on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
join GROUPS
on STUDENT.IDGROUP = GROUPS.IDGROUP
where GROUPS.IDGROUP =  @group_number;

-- 5

declare @studentsCount int = (select count(*) from STUDENT)

if @studentsCount < 100
	print 'студентов меньше 100'
else
	print 'студентов больше 100'

-- 6

declare @faculty_name nvarchar(10) = 'ХТиТ';

select case
	   when NOTE between 1 and 3 then 'не сдал'
	   when NOTE between 3 and 6 then 'удовлетворительно'
	   when NOTE between 6 and 8 then 'хорошо'
	   when NOTE between 8 and 10 then 'отлично'
	   else 'ошибка'
	   end оценка, count(*) [количество студентов]
from PROGRESS
join STUDENT on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
join GROUPS on STUDENT.IDGROUP = GROUPS.IDGROUP
where FACULTY = @faculty_name
group by case
	   when NOTE between 1 and 3 then 'не сдал'
	   when NOTE between 3 and 6 then 'удовлетворительно'
	   when NOTE between 6 and 8 then 'хорошо'
	   when NOTE between 8 and 10 then 'отлично'
	   else 'ошибка'
	   end;

-- 7

create table #FIRST_TEMP_TABLE
(
	COL1 int identity(1,1),
	COL2 int,
	COL3 nvarchar(50)
);

declare @rows int = 10;
declare @i int = 0;

while @i < @rows
begin
	insert #FIRST_TEMP_TABLE (COL2, COL3)
		values(floor(300 * rand()), CAST(CONCAT('row', @i + 1) as nvarchar(50)));
	set @i = @i + 1;
end;

select * from #FIRST_TEMP_TABLE;
drop table #FIRST_TEMP_TABLE;

-- 8

declare @y int = 0;

while @y < 10
begin
	if @y = 5 return;
	else begin
		print @y;
		set @y = @y + 1;
	end
end

-- 9

begin TRY
	print 'a' + 1
end try
begin CATCH
	print '################# ERROR ######################'
	print error_number()
	print error_message()
	print error_line()
	print error_procedure()
	print error_severity()
	print error_state()
	print '################# ERROR ######################'
end catch
