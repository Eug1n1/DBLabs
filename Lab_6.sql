use SHU_UNIVER
-- 1 task
select PULPIT.PULPIT_NAME 
	from PULPIT, FACULTY
	where FACULTY.FACULTY = PULPIT.FACULTY
	and PULPIT.FACULTY in (select PROFESSION.FACULTY from PROFESSION where PROFESSION.PROFESSION_NAME like '%технолог%' or PROFESSION.PROFESSION_NAME like '%технология%');

-- 2 task
select PULPIT.PULPIT_NAME 
	from PULPIT join FACULTY
	on PULPIT.FACULTY = FACULTY.FACULTY
	where PULPIT.FACULTY in (select PROFESSION.FACULTY from PROFESSION where PROFESSION.PROFESSION_NAME like '%технолог%' or PROFESSION.PROFESSION_NAME like '%технология%');

-- 3 task
select distinct PULPIT.PULPIT_NAME
	from FACULTY join PULPIT
	on FACULTY.FACULTY = PULPIT.FACULTY
	join PROFESSION
	on PROFESSION.FACULTY = PULPIT.FACULTY
	where PROFESSION.PROFESSION_NAME like '%технолог%';

-- 4 task
select a.AUDITORIUM_CAPACITY, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
	from AUDITORIUM as a join AUDITORIUM_TYPE
	on a.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
	where a.AUDITORIUM_CAPACITY = (select top(1) AUDITORIUM.AUDITORIUM_CAPACITY 
		from AUDITORIUM 
		where a.AUDITORIUM_TYPE = AUDITORIUM.AUDITORIUM_TYPE 
		order by AUDITORIUM.AUDITORIUM_CAPACITY desc);

-- 5 task
insert into FACULTY
values('ФДВ','Факультет диванных войск')

select FACULTY_NAME
	from FACULTY
	where not exists (select * from PULPIT where PULPIT.FACULTY = FACULTY.FACULTY);

-- 6 task
insert into PROGRESS
	values('БД',1000, '2020-10-10',10),
		('БД',1001, '2020-09-10',7)

select top(1)
	(select avg(PROGRESS.NOTE) from PROGRESS where PROGRESS.SUBJECT like 'ОАиП')[ОАиП],
	(select avg(PROGRESS.NOTE) from PROGRESS where PROGRESS.SUBJECT like 'БД')[БД],
	(select avg(PROGRESS.NOTE) from PROGRESS where PROGRESS.SUBJECT like 'СУБД')[СУБД]
	from PROGRESS;

-- 7 task
select *
	from GROUPS
	where GROUPS.IDGROUP >=all (select GROUPS.IDGROUP from GROUPS);

-- 8 task
select PROGRESS.SUBJECT, PROGRESS.NOTE from PROGRESS
	where PROGRESS.NOTE = any(select Progress.NOTE from PROGRESS where PROGRESS.SUBJECT = 'БД')

-- 10 task
select S1.BDAY, S1.NAME[Name1], S2.NAME[Name2]
	from STUDENT as S1 inner join STUDENT as S2
	on S1.BDAY = S2.BDAY and S1.NAME != S2.NAME 

