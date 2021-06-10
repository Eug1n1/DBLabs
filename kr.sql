use SHU_UNIVER
-- 1 TASK
create table Table1
(
	t1 int,
	t2 int
);

create table Table2
(
	t21 int identity,
	t22 date,
	t23 int
)


insert into Table1(t1) values (1), (2), (3), (10)
select * from Table1

insert into Table2(t21, t22) values 
	(
		(select avg(Table1.t1) from Table1),
		GETDATE()
	)

select * from Table2

drop table Table1
drop table Table2
-- 2 TASK	
select STUDENT.NAME 
	from STUDENT
	where STUDENT.IDSTUDENT in (select PROGRESS.IDSTUDENT from PROGRESS where PROGRESS.NOTE > 8 or PROGRESS.NOTE < 4)

select STUDENT.NAME 
	from STUDENT join PROGRESS
	on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT
	where PROGRESS.NOTE > 8 or PROGRESS.NOTE < 4

-- 3 TASK
select s.NAME
	from STUDENT as s
	where s.IDSTUDENT =any (select p.IDSTUDENT from PROGRESS as p where p.NOTE > 8)

insert into PROGRESS values ('ад', 1003, GETDATE(), 3)

select s.SUBJECT, s.PULPIT
	from SUBJECT as s
	where s.SUBJECT =any (select p.SUBJECT from PROGRESS as p where p.NOTE < 4)

select PROGRESS.SUBJECT, PROGRESS.NOTE 
	from PROGRESS
	where PROGRESS.NOTE = any(select Progress.NOTE from PROGRESS where PROGRESS.SUBJECT = 'ад')

-- 4 TASK
select s.SUBJECT, (select avg(PROGRESS.NOTE) from PROGRESS where PROGRESS.SUBJECT = s.SUBJECT)[average]
	from SUBJECT as s join PROGRESS
	on s.SUBJECT = PROGRESS.SUBJECT
	where PROGRESS.SUBJECT is not null
	group by s.SUBJECT

-- 6 TASK
create view view1(student, note) as 
	select STUDENT.NAME, PROGRESS.NOTE
	from STUDENT join PROGRESS
	on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT

drop view view1
