-- 1 задание
use SHU_UNIVER;

exec sp_helpindex 'AUDITORIUM_TYPE'
exec sp_helpindex 'FACULTY'

create table #TMPUN
(
    TIND int,
    TFIELD varchar(100)
);

go
set NOCOUNT on;
declare @i int = 0
while @i < 1000
    BEGIN
    INSERT #TMPUN(TIND, TFIELD)
        values(floor(20000 * Rand()), Replicate('aa',5))

        set @i = @i + 1;
    end;

select * from #TMPUN

checkpoint;
DBCC DROPCLEANBUFFERS;

create clustered index #TMPUN_CL on #TMPUN(TIND asc)

drop table #TMPUN

-- 2 задание
create table #EX2
(
	id int identity,
	N int,
	S varchar(20)
);

go
set nocount on;
declare @i int = 0;
while @i < 10000
begin
	insert #EX2 values(floor(3000 * rand()), replicate('a',5))
	set @i = @i +1;
end;


select * from #EX2

create index #EX2_NOCLU on #EX2(N,S)
select * from #EX2
drop table #EX2
-- 3 задание

create table #EX3
(
	N int,
	S varchar(20),
	R real
);

go
set nocount on;
declare @i int = 0;
while @i < 10000
begin
	insert #EX3 values(rand() * 1000, replicate('a',5), cast(rand()* 1000.0 as real))
	set @i = @i +1;
end;


create index #EX3_N_X on #EX3(N) include(s)

select s from #EX3 where N = 5

-- 4 задание
create table #EX4
(
	N int,
	S varchar(20),
	R real
);

go
set nocount on;
declare @i int = 0;
while @i < 10000
begin
	insert #EX4 values(rand() * 1000, replicate('a',5), cast(rand()* 1000.0 as real))
	set @i = @i +1;
end;
drop table #EX4
--select * from #EX4 where (N>100 and N<200)
select * from #EX4 where (N=150)

create index #EX4_WHERE on #EX4(N) where (N>100 and N<200)
--drop table #EX4

-- 5 задание
use tempdb;

CREATE  index #EX4_TKEY ON #EX4(N); 
--drop index #EX_TKEY on #EX4

SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
        FROM sys.dm_db_index_physical_stats(DB_ID(N'#TEMPDB'), 
        OBJECT_ID(N'#EX'), NULL, NULL, NULL) ss
        JOIN sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id  
        WHERE name is not null;

INSERT top(100000) #EX4(N, S,R) select N, S,R from #EX4;

--реорганизация
ALTER index #EX4_TKEY on #EX4 reorganize;
--перестройка
ALTER index #EX4_TKEY on #EX4 rebuild with (online = off);


--6 задание
DROP index #EX4_TKEY on #EX4;

CREATE index #EX_TKEY on #EX4(N)
           with (fillfactor = 65);

drop table #EX4 

INSERT top(100000) #EX4(N, S,R) select N, S,R from #EX4;
select * from #EX4
delete  from #EX4

SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
        FROM sys.dm_db_index_physical_stats(DB_ID(N'tempdb'), 
        OBJECT_ID(N'#EX4'), NULL, NULL, NULL) ss
        JOIN sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id WHERE name is not null;
		use tempdb
		exec sp_helpindex '#EX4'

--7 задание
use SHU_MYBASE2

exec sp_helpindex 'EMPLOYEES'
exec sp_helpindex 'ENROLLMENT'
exec sp_helpindex 'POSITION'

create index EMPLOYEES_WHERE on EMPLOYEES (GENDER) where GENDER = 'ж'
create index ENROLLMENT_CL on ENROLLMENT (POSITION_NAME) include (ID)

select * from EMPLOYEES where GENDER = 'ж'

select * from EMPLOYEES
select * from ENROLLMENT

drop index EMPLOYEES_WHERE on EMPLOYEES
drop index ENROLLMENT_CL on EMPLOYEES